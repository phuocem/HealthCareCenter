// src/screens/patient/Book_appointment/BookByDate/SelectTimeSlot.js
import React, { useState, useEffect, useCallback } from 'react';
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
  const { date, department } = route.params;

  const [slots, setSlots] = useState([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  const fetchAvailableSlots = useCallback(async (isRefresh = false) => {
    if (!isRefresh) setLoading(true);
    else setRefreshing(true);

    try {
      const doctorIds = department.doctors.map(d => d.id);

      const { data, error } = await supabase
        .rpc('get_available_slots', {
          target_date: date,
          doctor_ids: doctorIds,
        });

      if (error) throw error;

      const grouped = {};
      data.forEach(row => {
        const docId = row.doctor_id;
        if (!grouped[docId]) {
          grouped[docId] = {
            doctor: {
              id: docId,
              name: row.doctor_name,
              room_number: row.room_number,
              avatar_url: row.avatar_url,
              specialization: row.specialization,
              experience_years: row.experience_years,
            },
            slots: [],
          };
        }
        const available = row.max_patients - row.booked_count;
        if (available > 0) {
          grouped[docId].slots.push({
            id: row.slot_id,
            start_time: row.start_time,
            end_time: row.end_time,
            available,
          });
        }
      });

      const result = Object.values(grouped).filter(g => g.slots.length > 0);
      setSlots(result);
    } catch (err) {
      console.error('Lỗi lấy giờ:', err);
      Alert.alert('Lỗi', 'Không thể tải khung giờ. Vui lòng thử lại.');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, [date, department.doctors]);

  useEffect(() => {
    fetchAvailableSlots();
  }, [fetchAvailableSlots]);

  const onRefresh = () => {
    fetchAvailableSlots(true);
  };

  const formatTime = (time) => {
    if (!time) return '';
    return time.toString().slice(0, 5);
  };

  const renderSlot = (slot, doctor) => {
    const timeStr = `${formatTime(slot.start_time)} - ${formatTime(slot.end_time)}`;
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
            <Text style={styles.doctorName}>{doctor.name || 'Bác sĩ'}</Text>
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
          {item.slots.length > 0 ? (
            item.slots.map((slot, idx) => (
              <View key={slot.id} style={idx > 0 && styles.slotMargin}>
                {renderSlot(slot, doctor)}
              </View>
            ))
          ) : (
            <Text style={styles.noSlot}>Không còn khung giờ</Text>
          )}
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
        <Text style={styles.loadingText}>Đang tìm khung giờ trống...</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      {/* HEADER */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#1F2937" />
        </TouchableOpacity>
        <Text style={styles.title}>Chọn giờ khám</Text>
      </View>

      {/* INFO BAR */}
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

      {/* LIST */}
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

// === STYLES HIỆN ĐẠI, MƯỢT, ĐẸP ===
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
    padding: 14,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#BBF7D0',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  slotButtonWarning: { backgroundColor: '#FFFBEB', borderColor: '#FDBA74' },
  slotButtonCritical: { backgroundColor: '#FEF2F2', borderColor: '#FCA5A5' },
  slotTime: { fontWeight: '600', color: '#166534', fontSize: 15 },
  slotAvailable: { fontSize: 13, color: '#16A34A', fontWeight: '500' },
  slotAvailableWarning: { color: '#DC2626' },
  noSlot: { color: '#9CA3AF', fontStyle: 'italic', textAlign: 'center', marginTop: 8 },
});