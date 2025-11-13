// src/screens/patient/Book_appointment/BookByDoctor/SelectDate.js
import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  Platform,
  Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation, useRoute } from '@react-navigation/native';
import Animated, { FadeInDown } from 'react-native-reanimated';

const Colors = {
  primary: '#1D4ED8',
  textPrimary: '#1E293B',
  textSecondary: '#4B5563',
  bg: '#F8FAFC',
  available: '#1D4ED8',
  today: '#DBEAFE',
  disabled: '#F3F4F6',
  holiday: '#FCA5A5',
  white: '#FFFFFF',
};

export default function SelectDate() {
  const navigation = useNavigation();
  const route = useRoute();
  const { doctor } = route.params || {};

  // LOG: Kiểm tra doctor nhận được
  React.useEffect(() => {
    console.log('========== SELECT DATE ==========');
    console.log('Nhận doctor từ BookByDoctor:', doctor);
    console.log('=================================');

    if (!doctor?.id || !doctor?.name) {
      Alert.alert('Lỗi', 'Thiếu thông tin bác sĩ. Vui lòng thử lại.');
      navigation.goBack();
    }
  }, [doctor, navigation]);

  // DỮ LIỆU NGÀY CÓ THỂ CHỌN – ĐÚNG THEO LỊCH THỰC TẾ
  const availableDates = [
    { day: 3, date: '2025-11-03' }, // Thứ 2
    { day: 10, date: '2025-11-10' }, // Thứ 2
    { day: 17, date: '2025-11-17' }, // Thứ 2
    { day: 24, date: '2025-11-24' }, // Thứ 2
  ];

  const handleSelect = (date) => {
    console.log('Người dùng chọn ngày:', date);
    navigation.navigate('SelectTimeSlotDoctor', {
      doctor,
      selectedDate: date,
    });
  };

  const renderDay = (index) => {
    const day = index + 1; // index 0 → ngày 1 (Chủ nhật)

    if (day > 30) {
      return <View key={`empty-${index}`} style={styles.emptyDay} />;
    }

    const dateObj = availableDates.find((d) => d.day === day);
    const isAvailable = !!dateObj;
    const isToday = dateObj?.isToday;

    return (
      <TouchableOpacity
        key={day}
        style={[
          styles.day,
          isToday && styles.today,
          isAvailable && styles.available,
          !isAvailable && styles.disabled,
        ]}
        onPress={() => isAvailable && handleSelect(dateObj.date)}
        disabled={!isAvailable}
      >
        <Text
          style={[
            styles.dayText,
            isToday && styles.todayText,
            isAvailable && styles.availableText,
            !isAvailable && styles.disabledText,
          ]}
        >
          {day}
        </Text>
        {isToday && <Text style={styles.todayLabel}>Hôm nay</Text>}
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      <Animated.View entering={FadeInDown.duration(400)} style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Ionicons name="arrow-back" size={26} color={Colors.primary} />
        </TouchableOpacity>
        <Text style={styles.title}>Chọn ngày khám</Text>
        <TouchableOpacity onPress={() => navigation.navigate('Home')}>
          <Ionicons name="home" size={24} color={Colors.primary} />
        </TouchableOpacity>
      </Animated.View>

      <ScrollView style={styles.content}>
        <View style={styles.calendar}>
          <View style={styles.monthHeader}>
            <TouchableOpacity>
              <Ionicons name="chevron-back" size={24} color={Colors.primary} />
            </TouchableOpacity>
            <Text style={styles.month}>Tháng 11 - 2025</Text>
            <TouchableOpacity>
              <Ionicons name="chevron-forward" size={24} color={Colors.primary} />
            </TouchableOpacity>
          </View>

          <View style={styles.weekdays}>
            {['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'].map((d) => (
              <Text key={d} style={styles.weekday}>
                {d}
              </Text>
            ))}
          </View>

          <View style={styles.daysGrid}>
            {Array.from({ length: 35 }, (_, i) => renderDay(i))}
          </View>
        </View>

        <View style={styles.legend}>
          <View style={styles.legendItem}>
            <View style={[styles.legendBox, { backgroundColor: Colors.available }]} />
            <Text style={styles.legendText}>Ngày có thể chọn</Text>
          </View>
          <View style={styles.legendItem}>
            <View style={[styles.legendBox, { backgroundColor: Colors.disabled }]} />
            <Text style={styles.legendText}>Ngày không khả dụng</Text>
          </View>
          <View style={styles.legendItem}>
            <View style={[styles.legendBox, { backgroundColor: Colors.holiday }]} />
            <Text style={styles.legendText}>Ngày nghỉ, lễ, tết</Text>
          </View>
        </View>

        <View style={styles.note}>
          <Ionicons name="information-circle" size={16} color={Colors.primary} />
          <Text style={styles.noteText}>
            Vui lòng chọn ngày có màu xanh dương để đặt khám.
          </Text>
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.bg },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingTop: Platform.OS === 'ios' ? 60 : 40,
    paddingHorizontal: 16,
    paddingBottom: 16,
    backgroundColor: Colors.white,
    elevation: 2,
  },
  title: { fontSize: 22, fontWeight: '800', color: Colors.primary },
  content: { flex: 1 },
  calendar: {
    backgroundColor: Colors.white,
    borderRadius: 16,
    margin: 16,
    padding: 16,
    elevation: 2,
  },
  monthHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  month: { fontSize: 18, fontWeight: '700', color: Colors.textPrimary },
  weekdays: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 8,
  },
  weekday: {
    fontSize: 13,
    color: Colors.textSecondary,
    width: 40,
    textAlign: 'center',
    fontWeight: '600',
  },
  daysGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  emptyDay: { width: 40, height: 40 },
  day: {
    width: 40,
    height: 40,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  today: { backgroundColor: Colors.today },
  available: { backgroundColor: Colors.available },
  disabled: { backgroundColor: Colors.disabled },
  dayText: {
    fontSize: 14,
    color: Colors.textPrimary,
  },
  todayText: { color: Colors.primary, fontWeight: '700' },
  availableText: { color: Colors.white, fontWeight: '700' },
  disabledText: { color: '#9CA3AF' },
  todayLabel: { fontSize: 9, color: Colors.primary, marginTop: 2 },
  legend: {
    marginHorizontal: 16,
    gap: 8,
    marginTop: 8,
  },
  legendItem: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  legendBox: {
    width: 16,
    height: 16,
    borderRadius: 8,
  },
  legendText: {
    fontSize: 13,
    color: Colors.textSecondary,
  },
  note: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginHorizontal: 16,
    marginTop: 16,
    marginBottom: 20,
    padding: 12,
    backgroundColor: '#EFF6FF',
    borderRadius: 12,
    gap: 8,
  },
  noteText: {
    flex: 1,
    fontSize: 14,
    color: Colors.primary,
    lineHeight: 20,
  },
});