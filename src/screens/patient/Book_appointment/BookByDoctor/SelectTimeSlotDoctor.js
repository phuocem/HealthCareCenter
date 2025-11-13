// src/screens/patient/Book_appointment/BookByDoctor/SelectTimeSlotDoctor.js
import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  FlatList,
  ActivityIndicator,
  Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation, useRoute } from '@react-navigation/native';
import { supabase } from '../../../../api/supabase';
import Animated, { FadeInDown } from 'react-native-reanimated';

const Colors = {
  primary: '#1D4ED8',
  textPrimary: '#1E293B',
  textSecondary: '#4B5563',
  bg: '#F8FAFC',
  white: '#FFFFFF',
};

export default function SelectTimeSlotDoctor() {
  const navigation = useNavigation();
  const route = useRoute();
  const { doctor, selectedDate } = route.params || {};

  const [timeSlots, setTimeSlots] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!doctor?.id || !selectedDate) {
      Alert.alert('Lỗi', 'Thiếu thông tin bác sĩ hoặc ngày khám');
      navigation.goBack();
    }
  }, [doctor, selectedDate, navigation]);

  useEffect(() => {
    if (doctor?.id && selectedDate) {
      console.log('========== SELECT TIME SLOT ==========');
      console.log('Bác sĩ:', doctor.name, '| ID:', doctor.id);
      console.log('Ngày khám:', selectedDate);
      console.log('=====================================');
      fetchAvailableTimeSlots();
    }
  }, [doctor?.id, selectedDate]);

  const fetchAvailableTimeSlots = async () => {
    if (!doctor?.id || !selectedDate) return;

    setLoading(true);
    try {
      // 1. LẤY NGÀY TRONG TUẦN
      const date = new Date(selectedDate);
      const dayMap = ['Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
      const dayOfWeek = dayMap[date.getDay()];
      console.log('Ngày trong tuần:', dayOfWeek);

      // 2. LẤY LỊCH MẪU + ID
      const { data: templates, error: tempError } = await supabase
        .from('doctor_schedule_template')
        .select('id, start_time, end_time, max_patients_per_slot')
        .eq('doctor_id', doctor.id)
        .eq('day_of_week', dayOfWeek)
        .order('start_time');

      if (tempError) throw tempError;
      console.log('Lịch mẫu từ DB:', templates);

      if (!templates || templates.length === 0) {
        console.log('Không có lịch mẫu cho ngày này');
        setTimeSlots([]);
        setLoading(false);
        return;
      }

      // 3. TẠO SLOT 30 PHÚT + GÁN slot_id
      const rawSlots = [];
      const slotIdToTimestamp = {}; // Map: slot_id → timestamp

      templates.forEach(t => {
        const start = new Date(`${selectedDate}T${t.start_time}`);
        const end = new Date(`${selectedDate}T${t.end_time}`);
        let current = new Date(start);

        while (current < end) {
          const timestamp = current.getTime();
          const slotStart = current.toTimeString().slice(0, 5);
          const slotEnd = new Date(current.getTime() + 30 * 60 * 1000).toTimeString().slice(0, 5);

          rawSlots.push({
            start: slotStart,
            end: slotEnd,
            display: `${slotStart} - ${slotEnd}`,
            timestamp,
            max_patients: t.max_patients_per_slot || 5,
            slot_id: t.id, // GÁN slot_id
          });

          // Lưu ánh xạ: slot_id → timestamp
          slotIdToTimestamp[t.id] = timestamp;

          current = new Date(current.getTime() + 30 * 60 * 1000);
        }
      });

      console.log('Tổng số slot 30 phút:', rawSlots.length);
      console.log('Danh sách slot:', rawSlots.map(s => `${s.display} (slot_id: ${s.slot_id})`));

      // 4. LẤY SỐ LƯỢNG ĐÃ ĐẶT DỰA TRÊN slot_id
      const slotIds = rawSlots.map(s => s.slot_id);
      const { data: booked, error: bookError } = await supabase
        .from('appointments')
        .select('slot_id, status')
        .eq('doctor_id', doctor.id)
        .eq('date', selectedDate) // DÙNG CỘT date (kiểu date)
        .in('slot_id', slotIds)
        .neq('status', 'cancelled');

      if (bookError) throw bookError;

      console.log('Lịch đã đặt:', booked);

      // 5. TÍNH SỐ LƯỢNG ĐÃ ĐẶT CHO TỪNG slot_id
      const bookedCountBySlotId = {};
      booked?.forEach(b => {
        bookedCountBySlotId[b.slot_id] = (bookedCountBySlotId[b.slot_id] || 0) + 1;
      });

      console.log('Số lượt đã đặt theo slot_id:', bookedCountBySlotId);

      // 6. CHUYỂN VỀ bookedCount theo timestamp
      const bookedCount = {};
      rawSlots.forEach(slot => {
        const count = bookedCountBySlotId[slot.slot_id] || 0;
        if (count < slot.max_patients) {
          bookedCount[slot.timestamp] = count;
        }
      });

      // 7. LỌC SLOT CÒN TRỐNG
      const available = rawSlots.filter(slot => {
        const count = bookedCountBySlotId[slot.slot_id] || 0;
        return count < slot.max_patients;
      });

      console.log('Slot còn trống:', available.length);
      console.log('Danh sách hiển thị:', available.map(s => s.display));

      setTimeSlots(available);
    } catch (err) {
      console.error('Lỗi lấy khung giờ:', err);
      Alert.alert('Lỗi', 'Không thể tải khung giờ. Vui lòng thử lại.');
      setTimeSlots([]);
    } finally {
      setLoading(false);
    }
  };

  const handleSelectSlot = (slot) => {
    console.log('Người dùng chọn khung giờ:', slot.display, '| slot_id:', slot.slot_id);
    navigation.navigate('ConfirmBookingDoctor', {
      doctor,
      selectedDate,
      timeSlot: slot,
    });
  };

  const formatDate = (dateStr) => {
    const date = new Date(dateStr);
    return date.toLocaleDateString('vi-VN', {
      weekday: 'long',
      day: 'numeric',
      month: 'long',
      year: 'numeric',
    });
  };

  const renderSlot = ({ item }) => (
    <TouchableOpacity
      key={item.timestamp}
      style={styles.slot}
      onPress={() => handleSelectSlot(item)}
    >
      <Text style={styles.slotText}>{item.display}</Text>
      <Ionicons name="chevron-forward" size={16} color={Colors.textSecondary} />
    </TouchableOpacity>
  );

  if (!doctor || !selectedDate) return null;

  return (
    <View style={styles.container}>
      <Animated.View entering={FadeInDown.duration(400)} style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Ionicons name="arrow-back" size={26} color={Colors.primary} />
        </TouchableOpacity>
        <Text style={styles.title}>Chọn giờ khám</Text>
        <TouchableOpacity onPress={() => navigation.navigate('Home')}>
          <Ionicons name="home" size={24} color={Colors.primary} />
        </TouchableOpacity>
      </Animated.View>

      <View style={styles.infoCard}>
        <Text style={styles.doctorName}>{doctor.name}</Text>
        <Text style={styles.date}>{formatDate(selectedDate)}</Text>
      </View>

      {loading ? (
        <View style={styles.center}>
          <ActivityIndicator size="large" color={Colors.primary} />
        </View>
      ) : timeSlots.length === 0 ? (
        <View style={styles.empty}>
          <Ionicons name="calendar-outline" size={48} color="#9CA3AF" />
          <Text style={styles.emptyText}>Không có khung giờ trống</Text>
          <Text style={styles.emptySub}>Vui lòng chọn ngày khác</Text>
        </View>
      ) : (
        <FlatList
          data={timeSlots}
          keyExtractor={(item) => item.timestamp.toString()}
          renderItem={renderSlot}
          contentContainerStyle={styles.list}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.bg },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingTop: 50,
    paddingHorizontal: 16,
    paddingBottom: 16,
    backgroundColor: Colors.white,
    elevation: 2,
  },
  title: { fontSize: 20, fontWeight: '700', color: Colors.textPrimary },
  infoCard: {
    backgroundColor: Colors.white,
    margin: 16,
    padding: 16,
    borderRadius: 12,
    elevation: 2,
  },
  doctorName: { fontSize: 18, fontWeight: '700', color: Colors.textPrimary },
  date: { fontSize: 15, color: Colors.textSecondary, marginTop: 4 },
  list: { paddingHorizontal: 16 },
  slot: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: Colors.white,
    padding: 16,
    marginBottom: 8,
    borderRadius: 12,
    elevation: 1,
  },
  slotText: { fontSize: 16, fontWeight: '600', color: Colors.textPrimary },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  empty: { flex: 1, justifyContent: 'center', alignItems: 'center', paddingHorizontal: 32 },
  emptyText: { fontSize: 16, color: Colors.textSecondary, marginTop: 12, textAlign: 'center' },
  emptySub: { fontSize: 14, color: '#9CA3AF', marginTop: 4 },
});