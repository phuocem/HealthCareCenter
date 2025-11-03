// src/screens/patient/Book_appointment/BookByDate/SelectTimeSlot.js
import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  FlatList,
  ActivityIndicator,
  Alert,
  Image,
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

  useEffect(() => {
    fetchAvailableSlots();
  }, [date, department]);

  const fetchAvailableSlots = async () => {
    setLoading(true);
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
        grouped[docId].slots.push({
          id: row.slot_id,
          start_time: row.start_time,
          end_time: row.end_time,
          available: row.max_patients - row.booked_count,
        });
      });

      setSlots(Object.values(grouped));
    } catch (err) {
      console.error('Lỗi lấy giờ:', err);
      Alert.alert('Lỗi', 'Không thể tải khung giờ.');
    } finally {
      setLoading(false);
    }
  };

  const renderSlot = (slot, doctor) => {
    const timeStr = `${slot.start_time.slice(0, 5)} - ${slot.end_time.slice(0, 5)}`;
    return (
      <TouchableOpacity
        style={styles.slotButton}
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
        <Text style={styles.slotAvailable}>
          {slot.available} chỗ trống
        </Text>
      </TouchableOpacity>
    );
  };

  const renderDoctor = ({ item }) => {
    const doctorName = item.doctor.name || 'Bác sĩ';
    const firstLetter = doctorName.charAt(0).toUpperCase();
    const avatarUri = item.doctor.avatar_url ? { uri: item.doctor.avatar_url } : null;

    return (
      <View style={styles.doctorCard}>
        <View style={styles.doctorHeader}>
          {avatarUri ? (
            <Image source={avatarUri} style={styles.avatar} />
          ) : (
            <View style={styles.avatarFallback}>
              <Text style={styles.avatarText}>{firstLetter}</Text>
            </View>
          )}
          <View style={styles.doctorInfo}>
            <Text style={styles.doctorName}>{doctorName}</Text>
            {item.doctor.specialization && (
              <Text style={styles.specialization}>
                {item.doctor.specialization}
              </Text>
            )}
            {item.doctor.experience_years && (
              <Text style={styles.experience}>
                {item.doctor.experience_years} năm kinh nghiệm
              </Text>
            )}
            <Text style={styles.doctorRoom}>
              Phòng {item.doctor.room_number || '—'}
            </Text>
          </View>
        </View>

        <View style={styles.slotsContainer}>
          {item.slots.length > 0 ? (
            item.slots.map((slot, idx) => (
              <View key={slot.id} style={idx > 0 && styles.slotMargin}>
                {renderSlot(slot, item.doctor)}
              </View>
            ))
          ) : (
            <Text style={styles.noSlot}>Không còn khung giờ trống</Text>
          )}
        </View>
      </View>
    );
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Ionicons name="arrow-back" size={24} color="#1F2937" />
        </TouchableOpacity>
        <Text style={styles.title}>Chọn giờ khám</Text>
      </View>

      <View style={styles.info}>
        <Text style={styles.infoText}>
          {department.name} • {new Date(date).toLocaleDateString('vi-VN')}
        </Text>
      </View>

      {loading ? (
        <View style={styles.center}>
          <ActivityIndicator size="large" color="#3B82F6" />
          <Text style={styles.loadingText}>Đang tải khung giờ...</Text>
        </View>
      ) : slots.length === 0 ? (
        <View style={styles.center}>
          <Ionicons name="time-outline" size={48} color="#9CA3AF" />
          <Text style={styles.emptyText}>
            Không có khung giờ trống nào vào ngày này
          </Text>
        </View>
      ) : (
        <FlatList
          data={slots}
          keyExtractor={item => item.doctor.id}
          renderItem={renderDoctor}
          showsVerticalScrollIndicator={false}
          contentContainerStyle={{ padding: 16 }}
        />
      )}
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
  title: { fontSize: 20, fontWeight: '700', marginLeft: 12, color: '#1F2937' },
  info: {
    padding: 12,
    backgroundColor: '#ECFDF5',
    marginHorizontal: 16,
    marginTop: 8,
    borderRadius: 12,
  },
  infoText: { fontSize: 14, color: '#059669', fontWeight: '600' },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20 },
  loadingText: { marginTop: 12, color: '#6B7280' },
  emptyText: { marginTop: 12, color: '#6B7280', textAlign: 'center', fontSize: 15 },
  doctorCard: {
    backgroundColor: '#fff',
    borderRadius: 16,
    padding: 16,
    marginBottom: 16,
    elevation: 2,
  },
  doctorHeader: { flexDirection: 'row', alignItems: 'flex-start', marginBottom: 12 },
  avatar: { width: 48, height: 48, borderRadius: 24, marginRight: 12 },
  avatarFallback: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: '#3B82F6',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  avatarText: { color: '#fff', fontWeight: '800', fontSize: 18 },
  doctorInfo: { flex: 1 },
  doctorName: { fontWeight: '700', color: '#1F2937', fontSize: 16 },
  specialization: { fontSize: 13, color: '#059669', marginTop: 2 },
  experience: { fontSize: 13, color: '#6B7280', marginTop: 2 },
  doctorRoom: { fontSize: 13, color: '#6B7280', marginTop: 2 },
  slotsContainer: { gap: 8 },
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
  slotTime: { fontWeight: '600', color: '#166534', fontSize: 15 },
  slotAvailable: { fontSize: 13, color: '#16A34A' },
  noSlot: { color: '#9CA3AF', fontStyle: 'italic', textAlign: 'center' },
});