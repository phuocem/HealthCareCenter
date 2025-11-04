// src/screens/patient/BookByDoctor/SelectTimeSlotDoctor.js
import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation, useRoute } from '@react-navigation/native';

const Colors = { primary: '#1D4ED8', textPrimary: '#1E293B', bg: '#F8FAFC' };

export default function SelectTimeSlotDoctor() {
  const navigation = useNavigation();
  const route = useRoute();
  const { doctor, selectedDate } = route.params;

  const timeSlots = [
    '06:30 - 07:30',
    '07:30 - 08:30',
    '08:30 - 09:30',
    '09:30 - 10:30',
    '10:30 - 11:30',
  ];

  const handleSelect = (slot) => {
    navigation.navigate('ConfirmBookingDoctor', { doctor, selectedDate, timeSlot: slot });
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Ionicons name="arrow-back" size={26} color={Colors.primary} />
        </TouchableOpacity>
        <Text style={styles.title}>Chọn khung giờ khám</Text>
      </View>

      <ScrollView style={styles.content}>
        <View style={styles.doctorInfo}>
          <Ionicons name="person-circle" size={36} color={Colors.primary} />
          <Text style={styles.name}>{doctor.name}</Text>
        </View>
        <Text style={styles.location}>Ghế khám số 2 - Lầu 6 Khu A - Buổi sáng</Text>

        <View style={styles.dateTabs}>
          {['05/11', '12/11', '19/11', '26/11'].map(d => (
            <TouchableOpacity key={d} style={[styles.tab, d === '05/11' && styles.selectedTab]}>
              <Text style={[styles.tabText, d === '05/11' && styles.selectedText]}>{d}</Text>
              {d === '05/11' && <Ionicons name="checkmark" size={16} color="#FFF" style={styles.check} />}
            </TouchableOpacity>
          ))}
        </View>

        <Text style={styles.dateLabel}>05/11/2025 - Buổi sáng (Thứ 4)</Text>

        <View style={styles.timeGrid}>
          {timeSlots.map(slot => (
            <TouchableOpacity key={slot} style={styles.timeBtn} onPress={() => handleSelect(slot)}>
              <Text style={styles.timeText}>{slot}</Text>
            </TouchableOpacity>
          ))}
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.bg },
  header: { flexDirection: 'row', alignItems: 'center', padding: 16, gap: 12 },
  title: { fontSize: 22, fontWeight: '800', color: Colors.primary },
  content: { flex: 1 },
  doctorInfo: { flexDirection: 'row', alignItems: 'center', padding: 16, backgroundColor: '#FFF', borderBottomWidth: 1, borderColor: '#E5E7EB' },
  name: { marginLeft: 12, fontSize: 16, fontWeight: '600' },
  location: { padding: 16, fontSize: 14, color: '#6B7280' },
  dateTabs: { flexDirection: 'row', padding: 16, gap: 8 },
  tab: { paddingHorizontal: 12, paddingVertical: 6, borderRadius: 8, backgroundColor: '#F3F4F6' },
  selectedTab: { backgroundColor: Colors.primary },
  tabText: { color: '#6B7280' },
  selectedText: { color: '#FFF', fontWeight: '600' },
  check: { position: 'absolute', top: -6, right: -6 },
  dateLabel: { paddingHorizontal: 16, color: '#10B981', fontWeight: '600' },
  timeGrid: { padding: 16, gap: 12 },
  timeBtn: { backgroundColor: '#FFF', padding: 16, borderRadius: 12, borderWidth: 2, borderColor: '#E5E7EB', alignItems: 'center' },
  timeText: { fontSize: 15, fontWeight: '600' },
});