// src/screens/patient/Book_appointment/BookByDate/BookByDate.js
import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Alert,
  ActivityIndicator,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import { Calendar } from 'react-native-calendars';
import { supabase } from '../../../../api/supabase';

export default function BookByDate() {
  const navigation = useNavigation();
  const [selectedDate, setSelectedDate] = useState('');
  const [markedDates, setMarkedDates] = useState({});
  const [loading, setLoading] = useState(true);

  // CHUYỂN TIẾNG VIỆT → TIẾNG ANH
  const vietnameseToEnglish = (viDay) => {
    const map = {
      'Thứ 2': 'Monday', 'Thứ 3': 'Tuesday', 'Thứ 4': 'Wednesday',
      'Thứ 5': 'Thursday', 'Thứ 6': 'Friday', 'Thứ 7': 'Saturday',
      'Chủ nhật': 'Sunday',
    };
    return map[viDay] || viDay;
  };

  // LẤY NGÀY CÓ LỊCH
  const fetchAvailableDates = async () => {
    setLoading(true);
    try {
      const { data: templates, error } = await supabase
        .from('appointment_slots')
        .select('day_of_week')
        .eq('is_template', true);

      if (error) throw error;
      if (!templates || templates.length === 0) {
        Alert.alert('Thông báo', 'Chưa có lịch làm việc nào được thiết lập.');
        setLoading(false);
        return;
      }

      const today = new Date();
      const dates = {};

      for (let i = 0; i < 60; i++) {
        const date = new Date(today);
        date.setDate(today.getDate() + i);
        const dateStr = date.toISOString().split('T')[0];
        const dayOfWeekEn = date.toLocaleString('en-US', { weekday: 'long' });

        const hasTemplate = templates.some(t =>
          vietnameseToEnglish(t.day_of_week) === dayOfWeekEn
        );

        if (hasTemplate) {
          dates[dateStr] = {
            marked: true,
            dotColor: '#10B981',
            selectedColor: '#059669',
          };
        }
      }

      setMarkedDates(dates);
    } catch (err) {
      console.error('Lỗi lấy ngày:', err);
      Alert.alert('Lỗi', 'Không thể tải lịch khám.');
    } finally {
      setLoading(false);
    }
  };

  // XỬ LÝ CHỌN NGÀY
  const handleDayPress = async (day) => {
    if (!markedDates[day.dateString]) {
      Alert.alert('Không thể đặt', 'Ngày này không có khung giờ khám.');
      return;
    }

    setLoading(true);
    try {
      // TẠO SLOT
      const { error: rpcError } = await supabase.rpc('generate_slots_for_date_rpc', {
        target_date: day.dateString,
      });
      if (rpcError) throw rpcError;

      // KIỂM TRA SLOT TRỐNG
      const { data: hasSlot, error: checkError } = await supabase
        .rpc('has_available_slots', { target_date: day.dateString });

      if (checkError || !hasSlot) {
        Alert.alert('Hết chỗ', 'Ngày này hiện đã kín lịch. Vui lòng chọn ngày khác.');
        setLoading(false);
        return;
      }

      setSelectedDate(day.dateString);
      navigation.navigate('SelectDepartment', { date: day.dateString });

    } catch (err) {
      console.error('Lỗi tạo slot:', err);
      Alert.alert('Lỗi', 'Không thể tạo lịch. Vui lòng thử lại.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchAvailableDates();
  }, []);

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Ionicons name="arrow-back" size={24} color="#1F2937" />
        </TouchableOpacity>
        <Text style={styles.title}>Chọn ngày khám</Text>
      </View>

      {loading && (
        <View style={styles.loadingOverlay}>
          <ActivityIndicator size="large" color="#3B82F6" />
          <Text style={styles.loadingText}>Đang tải lịch khám...</Text>
        </View>
      )}

      <View style={styles.calendarContainer}>
        <Calendar
          onDayPress={handleDayPress}
          markedDates={{
            ...markedDates,
            [selectedDate]: {
              ...(markedDates[selectedDate] || {}),
              selected: true,
              selectedColor: '#059669',
            },
          }}
          minDate={new Date().toISOString().split('T')[0]}
          theme={{
            backgroundColor: '#ffffff',
            calendarBackground: '#ffffff',
            textSectionTitleColor: '#1F2937',
            selectedDayBackgroundColor: '#059669',
            selectedDayTextColor: '#ffffff',
            todayTextColor: '#10B981',
            todayBackgroundColor: '#ECFDF5',
            dayTextColor: '#1F2937',
            textDisabledColor: '#D1D5DB',
            dotColor: '#10B981',
            selectedDotColor: '#ffffff',
            arrowColor: '#4B5563',
            monthTextColor: '#1F2937',
            textDayFontWeight: '600',
            textMonthFontWeight: '800',
            textDayHeaderFontWeight: '700',
          }}
        />
      </View>

      <View style={styles.legend}>
        <View style={styles.legendItem}>
          <View style={[styles.dot, { backgroundColor: '#10B981' }]} />
          <Text style={styles.legendText}>Ngày có thể chọn</Text>
        </View>
        <View style={styles.legendItem}>
          <View style={[styles.dot, { backgroundColor: '#E5E7EB' }]} />
          <Text style={styles.legendText}>Ngày ngoài vùng đăng ký khám</Text>
        </View>
        <View style={styles.legendItem}>
          <View style={[styles.dot, { backgroundColor: '#FB923C' }]} />
          <Text style={styles.legendText}>Ngày nghỉ, lễ, tết</Text>
        </View>
      </View>

      <Text style={styles.note}>
        Vui lòng bấm chọn ngày có chấm xanh để đặt khám.
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#fff' },
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
  loadingOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(255,255,255,0.8)',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 100,
  },
  loadingText: { marginTop: 12, color: '#6B7280', fontSize: 15 },
  calendarContainer: {
    margin: 20,
    backgroundColor: '#fff',
    borderRadius: 16,
    padding: 8,
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.08,
    shadowRadius: 10,
  },
  legend: { marginHorizontal: 20, marginTop: 10 },
  legendItem: { flexDirection: 'row', alignItems: 'center', marginVertical: 6 },
  dot: { width: 12, height: 12, borderRadius: 6, marginRight: 10 },
  legendText: { fontSize: 13, color: '#6B7280' },
  note: {
    marginHorizontal: 20,
    marginTop: 16,
    marginBottom: 20,
    fontSize: 14,
    color: '#1F2937',
    fontWeight: '600',
    textAlign: 'center',
    lineHeight: 20,
  },
});