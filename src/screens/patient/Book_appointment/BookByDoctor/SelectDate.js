// src/screens/patient/BookByDoctor/SelectDate.js
import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, Platform } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation, useRoute } from '@react-navigation/native';
import Animated, { FadeInDown } from 'react-native-reanimated';

const Colors = { primary: '#1D4ED8', textPrimary: '#1E293B', textSecondary: '#4B5563', bg: '#F8FAFC' };

export default function SelectDate() {
  const navigation = useNavigation();
  const route = useRoute();
  const { doctor } = route.params;

  const availableDates = [
    { day: 5, date: '2025-11-05', isToday: true },
    { day: 12, date: '2025-11-12' },
    { day: 19, date: '2025-11-19' },
    { day: 26, date: '2025-11-26' },
  ];

  const handleSelect = (date) => {
    navigation.navigate('SelectTimeSlotDoctor', { doctor, selectedDate: date });
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
            <TouchableOpacity><Ionicons name="chevron-back" size={24} color={Colors.primary} /></TouchableOpacity>
            <Text style={styles.month}>Tháng 11 - 2025</Text>
            <TouchableOpacity><Ionicons name="chevron-forward" size={24} color={Colors.primary} /></TouchableOpacity>
          </View>

          <View style={styles.weekdays}>
            {['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'].map(d => (
              <Text key={d} style={styles.weekday}>{d}</Text>
            ))}
          </View>

          <View style={styles.daysGrid}>
            {Array.from({ length: 35 }, (_, i) => {
              const day = i - 4;
              const dateObj = availableDates.find(d => d.day === day);
              const isAvailable = !!dateObj;
              const isToday = dateObj?.isToday;

              if (day < 1 || day > 30) return <View key={i} style={styles.emptyDay} />;

              return (
                <TouchableOpacity
                  key={day}
                  style={[
                    styles.day,
                    isToday && styles.today,
                    isAvailable && styles.available,
                    !isAvailable && styles.disabled
                  ]}
                  onPress={() => isAvailable && handleSelect(dateObj.date)}
                  disabled={!isAvailable}
                >
                  <Text style={[
                    styles.dayText,
                    isToday && styles.todayText,
                    isAvailable && styles.availableText,
                    !isAvailable && styles.disabledText
                  ]}>{day}</Text>
                  {isToday && <Text style={styles.todayLabel}>Hôm nay</Text>}
                </TouchableOpacity>
              );
            })}
          </View>
        </View>

        <View style={styles.legend}>
          <View style={styles.legendItem}>
            <View style={[styles.legendBox, { backgroundColor: Colors.primary }]} />
            <Text style={styles.legendText}>Ngày có thể chọn</Text>
          </View>
          <View style={styles.legendItem}>
            <View style={[styles.legendBox, { backgroundColor: '#E5E7EB' }]} />
            <Text style={styles.legendText}>Ngày ngoài vùng đăng ký khám</Text>
          </View>
          <View style={styles.legendItem}>
            <View style={[styles.legendBox, { backgroundColor: '#F97316' }]} />
            <Text style={styles.legendText}>Ngày nghỉ, lễ, tết</Text>
          </View>
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.bg },
  header: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', paddingTop: Platform.OS === 'ios' ? 60 : 40, paddingHorizontal: 16, paddingBottom: 16 },
  title: { fontSize: 22, fontWeight: '800', color: Colors.primary },
  content: { flex: 1 },
  calendar: { backgroundColor: '#FFF', borderRadius: 16, margin: 16, padding: 16 },
  monthHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 },
  month: { fontSize: 18, fontWeight: '700', color: Colors.textPrimary },
  weekdays: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 8 },
  weekday: { fontSize: 13, color: Colors.textSecondary, width: 40, textAlign: 'center' },
  daysGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  emptyDay: { width: 40, height: 40 },
  day: { width: 40, height: 40, borderRadius: 20, justifyContent: 'center', alignItems: 'center' },
  today: { backgroundColor: '#E0F2FE' },
  available: { backgroundColor: Colors.primary },
  disabled: { backgroundColor: '#F3F4F6' },
  dayText: { fontSize: 14, color: Colors.textPrimary },
  todayText: { color: Colors.primary, fontWeight: '700' },
  availableText: { color: '#FFF', fontWeight: '700' },
  disabledText: { color: '#9CA3AF' },
  todayLabel: { fontSize: 9, color: Colors.primary, marginTop: 2 },
  legend: { marginHorizontal: 16, gap: 8 },
  legendItem: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  legendBox: { width: 16, height: 16, borderRadius: 8 },
  legendText: { fontSize: 13, color: Colors.textSecondary },
});