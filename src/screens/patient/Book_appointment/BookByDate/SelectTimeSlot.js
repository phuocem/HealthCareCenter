// src/screens/patient/Book_appointment/BookByDate/SelectTimeSlot.js
import React, { useState, useEffect, useCallback, useMemo } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  FlatList,
  ActivityIndicator,
  Alert,
  Image,
  RefreshControl,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation, useRoute } from '@react-navigation/native';
import { supabase } from '../../../../api/supabase';

export default function SelectTimeSlot() {
  const navigation = useNavigation();
  const route = useRoute();
  const { date, department, templates } = route.params;

  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  // === TẠO KHUNG GIỜ 1 TIẾNG 30 PHÚT ===
  const timeSlots = useMemo(() => {
    const slots = [];
    const duration = 90; // 1 tiếng 30 phút

    templates.forEach(t => {
      const [startH, startM] = t.start_time.split(':').map(Number);
      const [endH, endM] = t.end_time.split(':').map(Number);

      let currentH = startH;
      let currentM = startM;

      while (
        currentH < endH ||
        (currentH === endH && currentM < endM)
      ) {
        const startStr = `${currentH.toString().padStart(2, '0')}:${currentM.toString().padStart(2, '0')}`;
        const totalMinutes = currentH * 60 + currentM + duration;
        const endSlotH = Math.floor(totalMinutes / 60);
        const endSlotM = totalMinutes % 60;
        const endStr = `${endSlotH.toString().padStart(2, '0')}:${endSlotM.toString().padStart(2, '0')}`;

        // Kiểm tra không vượt quá end_time
        if (
          endSlotH < endH ||
          (endSlotH === endH && endSlotM <= endM)
        ) {
          slots.push({
            id: `${t.doctor_id || 'unknown'}_${startStr}`, // KEY DUY NHẤT
            doctor_id: t.doctor_id,
            doctor_name: t.doctors?.name || 'Bác sĩ',
            room_number: t.doctors?.room_number,
            avatar_url: t.doctors?.avatar_url,
            specialization: t.doctors?.specialization,
            experience_years: t.doctors?.experience_years,
            start_time: startStr,
            end_time: endStr,
            max_patients: 5,
            booked_count: 0,
          });
        } else {
          break; // Dừng nếu vượt quá
        }

        currentH = endSlotH;
        currentM = endSlotM;
      }
    });

    return slots;
  }, [templates]);

  const loadData = useCallback(async (isRefresh = false) => {
    if (!isRefresh) setLoading(true);

    try {
      const finalSlots = timeSlots
        .map(slot => ({
          ...slot,
          available: slot.max_patients - slot.booked_count,
        }))
        .filter(s => s.available > 0);

      const grouped = {};
      finalSlots.forEach(s => {
        const id = s.doctor_id;
        if (!grouped[id]) {
          grouped[id] = {
            doctor: {
              id,
              name: s.doctor_name,
              room_number: s.room_number,
              avatar_url: s.avatar_url,
              specialization: s.specialization,
              experience_years: s.experience_years,
            },
            slots: [],
          };
        }
        grouped[id].slots.push({
          id: s.id,
          start_time: s.start_time,
          end_time: s.end_time,
          available: s.available,
        });
      });

      setSlots(Object.values(grouped));
    } catch (err) {
      Alert.alert('Lỗi', 'Không thể tải khung giờ.');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, [timeSlots]);

  const [slots, setSlots] = useState([]);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const onRefresh = () => {
    setRefreshing(true);
    loadData(true);
  };

  const renderSlot = (slot, doctor) => {
    const timeStr = `${slot.start_time} - ${slot.end_time}`;
    const isLow = slot.available <= 2;
    const isCritical = slot.available === 1;

    return (
      <TouchableOpacity
        style={[
          styles.slotButton,
          isLow && styles.slotButtonWarning,
          isCritical && styles.slotButtonCritical,
        ]}
        onPress={() =>
          navigation.navigate('ConfirmBooking', {
            date,
            department,
            slot,
            doctor,
          })
        }
      >
        <Text style={styles.slotTime}>{timeStr}</Text>
        <Text style={[
          styles.slotAvailable,
          isLow && styles.slotAvailableWarning,
        ]}>
          {slot.available} chỗ
        </Text>
      </TouchableOpacity>
    );
  };

  const renderDoctor = ({ item }) => {
    const doctor = item.doctor;
    const firstLetter = doctor.name?.charAt(0).toUpperCase() || 'B';
    const hasAvatar = !!doctor.avatar_url;

    return (
      <View style={styles.doctorCard}>
        <View style={styles.doctorHeader}>
          {hasAvatar ? (
            <Image source={{ uri: doctor.avatar_url }} style={styles.avatar} />
          ) : (
            <View style={styles.avatarFallback}>
              <Text style={styles.avatarText}>{firstLetter}</Text>
            </View>
          )}
          <View style={styles.doctorInfo}>
            <Text style={styles.doctorName}>{doctor.name}</Text>
            {doctor.specialization && (
              <Text style={styles.specialization}>{doctor.specialization}</Text>
            )}
            <View style={styles.row}>
              {doctor.experience_years && (
                <Text style={styles.experience}>
                  {doctor.experience_years} năm
                </Text>
              )}
              {doctor.room_number && (
                <Text style={styles.doctorRoom}> • Phòng {doctor.room_number}</Text>
              )}
            </View>
          </View>
        </View>

        <View style={styles.slotsContainer}>
          {item.slots.map((slot, idx) => (
            <View key={slot.id} style={idx > 0 && styles.slotMargin}>
              {renderSlot(slot, doctor)}
            </View>
          ))}
        </View>
      </View>
    );
  };

  const renderEmpty = () => (
    <View style={styles.center}>
      <Ionicons name="calendar-clear-outline" size={56} color="#9CA3AF" />
      <Text style={styles.emptyTitle}>Chưa có lịch trống</Text>
      <Text style={styles.emptyText}>
        Không có bác sĩ nào trong khoa có khung giờ trống vào ngày này.
      </Text>
      <TouchableOpacity style={styles.retryButton} onPress={onRefresh}>
        <Text style={styles.retryText}>Tải lại</Text>
      </TouchableOpacity>
    </View>
  );

  if (loading && !refreshing) {
    return (
      <View style={styles.center}>
        <ActivityIndicator size="large" color="#3B82F6" />
        <Text style={styles.loadingText}>Đang tạo khung giờ...</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#1F2937" />
        </TouchableOpacity>
        <Text style={styles.title}>Chọn giờ khám</Text>
      </View>

      <View style={styles.info}>
        <Text style={styles.infoText}>
          {department.name} • {new Date(date).toLocaleDateString('vi-VN', {
            weekday: 'long',
            day: 'numeric',
            month: 'long',
            year: 'numeric',
          })}
        </Text>
      </View>

      <FlatList
        data={slots}
        keyExtractor={item => item.doctor.id}
        renderItem={renderDoctor}
        showsVerticalScrollIndicator={false}
        contentContainerStyle={styles.listContent}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
        }
        ListEmptyComponent={renderEmpty}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#F9FAFB' },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingTop: 50,
    paddingHorizontal: 16,
    paddingBottom: 16,
    backgroundColor: '#fff',
    borderBottomWidth: 1,
    borderBottomColor: '#E5E7EB',
  },
  backButton: { padding: 4 },
  title: { fontSize: 20, fontWeight: '700', marginLeft: 12, color: '#1F2937' },
  info: {
    marginHorizontal: 16,
    marginTop: 8,
    padding: 12,
    backgroundColor: '#ECFDF5',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#BBF7D0',
  },
  infoText: { fontSize: 15, color: '#059669', fontWeight: '600' },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20 },
  loadingText: { marginTop: 12, color: '#6B7280', fontSize: 15 },
  emptyTitle: { marginTop: 16, fontSize: 18, fontWeight: '600', color: '#374151' },
  emptyText: { marginTop: 8, color: '#6B7280', textAlign: 'center', fontSize: 14, lineHeight: 20 },
  retryButton: { marginTop: 16, paddingHorizontal: 24, paddingVertical: 10, backgroundColor: '#3B82F6', borderRadius: 8 },
  retryText: { color: '#fff', fontWeight: '600' },
  listContent: { padding: 16, paddingBottom: 32 },
  doctorCard: {
    backgroundColor: '#fff',
    borderRadius: 16,
    padding: 16,
    marginBottom: 16,
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 3,
  },
  doctorHeader: { flexDirection: 'row', alignItems: 'flex-start', marginBottom: 12 },
  avatar: { width: 52, height: 52, borderRadius: 26, marginRight: 12 },
  avatarFallback: {
    width: 52,
    height: 52,
    borderRadius: 26,
    backgroundColor: '#3B82F6',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  avatarText: { color: '#fff', fontWeight: '800', fontSize: 20 },
  doctorInfo: { flex: 1 },
  doctorName: { fontWeight: '700', color: '#1F2937', fontSize: 17 },
  specialization: { fontSize: 14, color: '#059669', marginTop: 2, fontWeight: '500' },
  row: { flexDirection: 'row', marginTop: 2 },
  experience: { fontSize: 13, color: '#6B7280' },
  doctorRoom: { fontSize: 13, color: '#6B7280' },
  slotsContainer: { gap: 10 },
  slotMargin: { marginTop: 8 },
  slotButton: {
    backgroundColor: '#F0FDF4',
    padding: 16,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#BBF7D0',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  slotButtonWarning: { backgroundColor: '#FFFBEB', borderColor: '#FDBA74' },
  slotButtonCritical: { backgroundColor: '#FEF2F2', borderColor: '#FCA5A5' },
  slotTime: { fontWeight: '600', color: '#166534', fontSize: 16 },
  slotAvailable: { fontSize: 13, color: '#16A34A', fontWeight: '500' },
  slotAvailableWarning: { color: '#DC2626' },
});