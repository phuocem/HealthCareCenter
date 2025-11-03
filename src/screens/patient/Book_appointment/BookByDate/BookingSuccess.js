// src/screens/patient/Book_appointment/BookByDate/BookingSuccess.js
import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Alert,
  Share,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation, useRoute } from '@react-navigation/native';
import QRCode from 'react-native-qrcode-svg';

export default function BookingSuccess() {
  const navigation = useNavigation();
  const route = useRoute();
  const {
    appointment_id,
    doctor_name,
    time,
    date,
    department,
    room,
    price,
  } = route.params;

  const qrData = `https://your-app.com/booking/${appointment_id}`;

  const handleShare = async () => {
    try {
      await Share.share({
        message: `Đặt lịch thành công!\nMã: ${appointment_id}\nBác sĩ: ${doctor_name}\nThời gian: ${time}, ${date}`,
        url: qrData,
      });
    } catch (err) {
      Alert.alert('Lỗi', 'Không thể chia sẻ');
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Đặt lịch thành công!</Text>
        <Ionicons name="checkmark-circle" size={32} color="#10B981" />
      </View>

      <View style={styles.ticket}>
        {/* QR CODE */}
        <View style={styles.qrContainer}>
          <QRCode value={qrData} size={160} />
          <Text style={styles.qrLabel}>Quét mã để xác nhận</Text>
        </View>

        {/* MÃ LỊCH */}
        <View style={styles.codeRow}>
          <Text style={styles.codeLabel}>Mã lịch</Text>
          <Text style={styles.codeValue}>{appointment_id}</Text>
        </View>

        {/* THÔNG TIN */}
        <View style={styles.infoRow}>
          <Ionicons name="person-outline" size={20} color="#6B7280" />
          <Text style={styles.infoLabel}>Bác sĩ</Text>
          <Text style={styles.infoValue}>{doctor_name}</Text>
        </View>

        <View style={styles.infoRow}>
          <Ionicons name="time-outline" size={20} color="#6B7280" />
          <Text style={styles.infoLabel}>Giờ khám</Text>
          <Text style={styles.infoValue}>{time}</Text>
        </View>

        <View style={styles.infoRow}>
          <Ionicons name="calendar-outline" size={20} color="#6B7280" />
          <Text style={styles.infoLabel}>Ngày</Text>
          <Text style={styles.infoValue}>{date}</Text>
        </View>

        <View style={styles.infoRow}>
          <Ionicons name="business-outline" size={20} color="#6B7280" />
          <Text style={styles.infoLabel}>Chuyên khoa</Text>
          <Text style={styles.infoValue}>{department}</Text>
        </View>

        {room !== '—' && (
          <View style={styles.infoRow}>
            <Ionicons name="location-outline" size={20} color="#6B7280" />
            <Text style={styles.infoLabel}>Phòng</Text>
            <Text style={styles.infoValue}>{room}</Text>
          </View>
        )}

        <View style={styles.infoRow}>
          <Ionicons name="cash-outline" size={20} color="#6B7280" />
          <Text style={styles.infoLabel}>Phí khám</Text>
          <Text style={styles.infoValue}>{price}</Text>
        </View>
      </View>

      {/* NÚT CHIA SẺ & HOÀN TẤT */}
      <View style={styles.buttonContainer}>
        <TouchableOpacity style={styles.shareButton} onPress={handleShare}>
          <Ionicons name="share-outline" size={20} color="#fff" />
          <Text style={styles.shareText}>Chia sẻ</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.doneButton}
          onPress={() => navigation.replace('HomeScreen')} // Quay về trang chủ
        >
          <Text style={styles.doneText}>Hoàn tất</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#F9FAFB', padding: 16 },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 40,
    marginBottom: 24,
  },
  title: { fontSize: 22, fontWeight: '700', color: '#1F2937', marginRight: 8 },
  ticket: {
    backgroundColor: '#fff',
    borderRadius: 16,
    padding: 20,
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 6,
    marginBottom: 24,
  },
  qrContainer: {
    alignItems: 'center',
    marginBottom: 20,
  },
  qrLabel: { marginTop: 8, color: '#6B7280', fontSize: 13 },
  codeRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    backgroundColor: '#F3F4F6',
    padding: 12,
    borderRadius: 12,
    marginBottom: 16,
  },
  codeLabel: { fontSize: 15, color: '#6B7280' },
  codeValue: { fontSize: 16, fontWeight: '700', color: '#1F2937' },
  infoRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  infoLabel: { flex: 1, marginLeft: 12, color: '#6B7280', fontSize: 14 },
  infoValue: { fontWeight: '600', color: '#1F2937', fontSize: 14 },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: 12,
  },
  shareButton: {
    flex: 1,
    flexDirection: 'row',
    backgroundColor: '#6366F1',
    padding: 14,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  shareText: { color: '#fff', fontWeight: '600', marginLeft: 8 },
  doneButton: {
    flex: 1,
    backgroundColor: '#10B981',
    padding: 14,
    borderRadius: 12,
    alignItems: 'center',
  },
  doneText: { color: '#fff', fontWeight: '700', fontSize: 16 },
});