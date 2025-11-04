// src/screens/patient/BookByDoctor/ConfirmBookingDoctor.js
import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { useNavigation, useRoute } from '@react-navigation/native';

const Colors = { primary: '#1D4ED8', secondary: '#38BDF8', success: '#10B981', textPrimary: '#1E293B', bg: '#F8FAFC' };

export default function ConfirmBookingDoctor() {
  const navigation = useNavigation();
  const route = useRoute();
  const { doctor, selectedDate, timeSlot } = route.params;
  const [bhyt, setBhyt] = useState(null);
  const [isLeader, setIsLeader] = useState(false);

  const handleConfirm = () => {
    navigation.navigate('BookSuccessDoctor');
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Ionicons name="arrow-back" size={26} color={Colors.primary} />
        </TouchableOpacity>
        <Text style={styles.title}>Chọn thông tin khám</Text>
      </View>

      <ScrollView style={styles.content}>
        <View style={styles.summary}>
          <View style={styles.item}><Ionicons name="person" size={20} color={Colors.primary} /><Text style={styles.text}>{doctor.name}</Text><Ionicons name="checkmark-circle" size={20} color={Colors.success} /></View>
          <View style={styles.item}><Ionicons name="medkit" size={20} color={Colors.primary} /><Text style={styles.text}>{doctor.dept}</Text><Ionicons name="checkmark-circle" size={20} color={Colors.success} /></View>
          <View style={styles.item}><Ionicons name="calendar" size={20} color={Colors.primary} /><Text style={styles.text}>{selectedDate}</Text><Ionicons name="checkmark-circle" size={20} color={Colors.success} /></View>
          <View style={styles.item}><Ionicons name="time" size={20} color={Colors.primary} /><Text style={styles.text}>{timeSlot}, Ghế khám số 2 - Lầu 6 Khu A</Text><Ionicons name="checkmark-circle" size={20} color={Colors.success} /></View>
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Bảo hiểm Y tế *</Text>
          {['Đăng ký KCB BHYT ban đầu tại BV ĐHYD', 'Có giấy chuyển BHYT đúng tuyến', 'Tái khám theo hẹn', 'Không phải 3 trường hợp trên'].map((opt, i) => (
            <TouchableOpacity key={i} style={styles.radio} onPress={() => setBhyt(i)}>
              <View style={[styles.radioBtn, bhyt === i && styles.selected]} />
              <Text style={styles.radioLabel}>{opt}</Text>
            </TouchableOpacity>
          ))}
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Bảo lãnh viện phí *</Text>
          <View style={styles.row}>
            <TouchableOpacity style={styles.checkbox} onPress={() => setIsLeader(true)}>
              {isLeader && <Text style={styles.check}>Check</Text>}
            </TouchableOpacity>
            <Text>Có</Text>
            <TouchableOpacity style={styles.checkbox} onPress={() => setIsLeader(false)}>
              {!isLeader && <Text style={styles.check}>Check</Text>}
            </TouchableOpacity>
            <Text>Không</Text>
          </View>
        </View>

        <View style={styles.total}>
          <Text style={styles.totalLabel}>Tổng tiền khám</Text>
          <Text style={styles.totalAmount}>150.000đ</Text>
        </View>

        <TouchableOpacity style={styles.continue} onPress={handleConfirm}>
          <LinearGradient colors={[Colors.primary, Colors.secondary]} style={styles.gradient}>
            <Text style={styles.continueText}>Tiếp tục</Text>
          </LinearGradient>
        </TouchableOpacity>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.bg },
  header: { flexDirection: 'row', alignItems: 'center', padding: 16, gap: 12 },
  title: { fontSize: 22, fontWeight: '800', color: Colors.primary },
  content: { flex: 1 },
  summary: { backgroundColor: '#FFF', margin: 16, padding: 16, borderRadius: 16, gap: 12 },
  item: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  text: { flex: 1, marginLeft: 12, fontSize: 15 },
  section: { marginHorizontal: 16, marginBottom: 16 },
  sectionTitle: { fontSize: 16, fontWeight: '700', marginBottom: 12 },
  radio: { flexDirection: 'row', alignItems: 'center', marginBottom: 12 },
  radioBtn: { width: 20, height: 20, borderRadius: 10, borderWidth: 2, borderColor: '#E5E7EB', marginRight: 12 },
  selected: { backgroundColor: Colors.primary, borderColor: Colors.primary },
  radioLabel: { flex: 1, fontSize: 14 },
  row: { flexDirection: 'row', alignItems: 'center', gap: 20 },
  checkbox: { width: 20, height: 20, borderRadius: 4, borderWidth: 2, borderColor: '#E5E7EB', justifyContent: 'center', alignItems: 'center' },
  check: { color: Colors.primary, fontWeight: 'bold' },
  total: { flexDirection: 'row', justifyContent: 'space-between', padding: 16, backgroundColor: '#FFF', margin: 16, borderRadius: 12 },
  totalLabel: { fontSize: 16, fontWeight: '600' },
  totalAmount: { fontSize: 18, fontWeight: '800', color: Colors.primary },
  continue: { margin: 16, borderRadius: 12, overflow: 'hidden' },
  gradient: { padding: 16, alignItems: 'center' },
  continueText: { color: '#FFF', fontSize: 17, fontWeight: '700' },
});