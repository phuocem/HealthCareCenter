// src/screens/patient/Book_appointment/BookByDate/ConfirmBooking.js
import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Alert,
  ActivityIndicator,
  ScrollView,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation, useRoute } from '@react-navigation/native';
import { supabase } from '../../../../api/supabase';

export default function ConfirmBooking() {
  const navigation = useNavigation();
  const route = useRoute();
  const { date, department, slot, doctor } = route.params;

  const [loading, setLoading] = useState(false);
  const [patientName, setPatientName] = useState('');
  const [patientPhone, setPatientPhone] = useState('');
  const [servicePrice, setServicePrice] = useState('150.000đ'); // Mặc định

  // LẤY THÔNG TIN BỆNH NHÂN + GIÁ DỊCH VỤ
  useEffect(() => {
    fetchPatientAndServiceInfo();
  }, []);

  const fetchPatientAndServiceInfo = async () => {
    try {
      // 1. LẤY USER
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;

      // 2. LẤY TÊN + SĐT
      const { data: profile, error: profileError } = await supabase
        .from('user_profiles')
        .select('full_name, phone')
        .eq('id', user.id)
        .single();

      if (profileError) throw profileError;

      setPatientName(profile.full_name || '');
      setPatientPhone(profile.phone || '');

      // 3. LẤY DỊCH VỤ MẶC ĐỊNH CỦA KHOA → LẤY GIÁ
      const { data: service, error: serviceError } = await supabase
        .from('services')
        .select('price')
        .eq('department_id', department.id)
        .order('id')
        .limit(1)
        .single();

      if (serviceError) {
        console.warn('Không lấy được giá dịch vụ:', serviceError);
      } else {
        const formattedPrice = Number(service.price).toLocaleString('vi-VN') + 'đ';
        setServicePrice(formattedPrice);
      }
    } catch (err) {
      console.error('Lỗi lấy thông tin:', err);
    }
  };

  // ĐẶT LỊCH
  const handleBooking = async () => {
    if (!patientName.trim() || !patientPhone.trim()) {
      Alert.alert('Thiếu thông tin', 'Vui lòng nhập tên và số điện thoại.');
      return;
    }

    setLoading(true);
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) throw new Error('Chưa đăng nhập');

      // GỌI RPC ĐÚNG THỨ TỰ
      const { data: appointmentId, error } = await supabase
        .rpc('book_appointment_rpc', {
          p_user_id: user.id,
          p_slot_id: slot.id,
          p_patient_name: patientName,
          p_patient_phone: patientPhone,
          p_department_id: department.id,
        });

      if (error) throw error;

      const timeStr = `${slot.start_time.slice(0, 5)} - ${slot.end_time.slice(0, 5)}`;
      const dateStr = new Date(date).toLocaleDateString('vi-VN', {
        weekday: 'long',
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
      });

      Alert.alert(
        'Đặt lịch thành công!',
        `Mã lịch: ${appointmentId}\nBác sĩ: ${doctor.name}\nThời gian: ${timeStr}\nNgày: ${dateStr}\nGiá: ${servicePrice}`,
        [
          {
            text: 'Xem vé',
            onPress: () =>
              navigation.replace('BookingSuccess', {
                appointment_id: appointmentId,
                doctor_name: doctor.name,
                time: timeStr,
                date: dateStr,
                department: department.name,
                room: doctor.room_number || '—',
                price: servicePrice,
              }),
          },
        ]
      );
    } catch (err) {
      console.error('Lỗi đặt lịch:', err);
      Alert.alert('Lỗi', err.message || 'Không thể đặt lịch. Vui lòng thử lại.');
    } finally {
      setLoading(false);
    }
  };

  const timeStr = `${slot.start_time.slice(0, 5)} - ${slot.end_time.slice(0, 5)}`;
  const dateStr = new Date(date).toLocaleDateString('vi-VN', {
    weekday: 'long',
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
  });

  return (
    <View style={styles.container}>
      <ScrollView showsVerticalScrollIndicator={false}>
        {/* HEADER */}
        <View style={styles.header}>
          <TouchableOpacity onPress={() => navigation.goBack()}>
            <Ionicons name="arrow-back" size={24} color="#1F2937" />
          </TouchableOpacity>
          <Text style={styles.title}>Xác nhận đặt lịch</Text>
        </View>

        {/* THÔNG TIN LỊCH */}
        <View style={styles.card}>
          <Text style={styles.cardTitle}>Thông tin lịch khám</Text>

          <View style={styles.infoRow}>
            <Ionicons name="calendar-outline" size={20} color="#6B7280" />
            <Text style={styles.infoLabel}>Ngày khám</Text>
            <Text style={styles.infoValue}>{dateStr}</Text>
          </View>

          <View style={styles.infoRow}>
            <Ionicons name="time-outline" size={20} color="#6B7280" />
            <Text style={styles.infoLabel}>Giờ khám</Text>
            <Text style={styles.infoValue}>{timeStr}</Text>
          </View>

          <View style={styles.infoRow}>
            <Ionicons name="business-outline" size={20} color="#6B7280" />
            <Text style={styles.infoLabel}>Chuyên khoa</Text>
            <Text style={styles.infoValue}>{department.name}</Text>
          </View>

          <View style={styles.infoRow}>
            <Ionicons name="person-outline" size={20} color="#6B7280" />
            <Text style={styles.infoLabel}>Bác sĩ</Text>
            <Text style={styles.infoValue}>{doctor.name}</Text>
          </View>

          {doctor.room_number && (
            <View style={styles.infoRow}>
              <Ionicons name="location-outline" size={20} color="#6B7280" />
              <Text style={styles.infoLabel}>Phòng khám</Text>
              <Text style={styles.infoValue}>{doctor.room_number}</Text>
            </View>
          )}
        </View>

        {/* THÔNG TIN BỆNH NHÂN */}
        <View style={styles.card}>
          <Text style={styles.cardTitle}>Thông tin bệnh nhân</Text>

          <View style={styles.inputContainer}>
            <Ionicons name="person-outline" size={20} color="#6B7280" style={styles.inputIcon} />
            <Text style={styles.input}>{patientName || 'Chưa có tên'}</Text>
          </View>

          <View style={styles.inputContainer}>
            <Ionicons name="call-outline" size={20} color="#6B7280" style={styles.inputIcon} />
            <Text style={styles.input}>{patientPhone || 'Chưa có SĐT'}</Text>
          </View>
        </View>

        {/* GIÁ DỊCH VỤ */}
        <View style={styles.priceCard}>
          <Text style={styles.priceLabel}>Phí khám</Text>
          <Text style={styles.priceValue}>{servicePrice}</Text>
        </View>

        {/* NÚT XÁC NHẬN */}
        <TouchableOpacity
          style={[styles.confirmButton, loading && styles.disabledButton]}
          onPress={handleBooking}
          disabled={loading}
        >
          {loading ? (
            <ActivityIndicator color="#fff" />
          ) : (
            <Text style={styles.confirmText}>Xác nhận đặt lịch</Text>
          )}
        </TouchableOpacity>
      </ScrollView>
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
  card: {
    backgroundColor: '#fff',
    margin: 16,
    padding: 16,
    borderRadius: 16,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 4,
  },
  cardTitle: { fontSize: 16, fontWeight: '700', color: '#1F2937', marginBottom: 12 },
  infoRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  infoLabel: { flex: 1, marginLeft: 12, color: '#6B7280', fontSize: 14 },
  infoValue: { fontWeight: '600', color: '#1F2937', fontSize: 14 },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#E5E7EB',
    borderRadius: 12,
    padding: 12,
    marginBottom: 12,
  },
  inputIcon: { marginRight: 8 },
  input: { flex: 1, fontSize: 15, color: '#1F2937' },
  priceCard: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    backgroundColor: '#ECFDF5',
    marginHorizontal: 16,
    padding: 16,
    borderRadius: 12,
    marginBottom: 20,
  },
  priceLabel: { fontSize: 15, color: '#059669' },
  priceValue: { fontSize: 18, fontWeight: '700', color: '#059669' },
  confirmButton: {
    backgroundColor: '#10B981',
    marginHorizontal: 16,
    padding: 16,
    borderRadius: 12,
    alignItems: 'center',
    marginBottom: 30,
  },
  disabledButton: { backgroundColor: '#9CA3AF' },
  confirmText: { color: '#fff', fontWeight: '700', fontSize: 16 },
});