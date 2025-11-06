import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Alert,
  ActivityIndicator,
  ScrollView,
  TextInput,
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
  const [servicePrice, setServicePrice] = useState('150.000đ');

  useEffect(() => {
    fetchPatientAndServiceInfo();
  }, []);

  const fetchPatientAndServiceInfo = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;

      const { data: profile } = await supabase
        .from('user_profiles')
        .select('full_name, phone')
        .eq('id', user.id)
        .single();

      if (profile) {
        setPatientName(profile.full_name || '');
        setPatientPhone(profile.phone || '');
      }

      const { data: service } = await supabase
        .from('services')
        .select('price')
        .eq('department_id', department.id)
        .order('id')
        .limit(1)
        .single();

      if (service && service.price) {
        const formatted = Number(service.price).toLocaleString('vi-VN') + 'đ';
        setServicePrice(formatted);
      }
    } catch (err) {
      console.warn('Lỗi khởi tạo:', err);
    }
  };

  const handleBooking = async () => {
    if (!patientName.trim()) {
      Alert.alert('Lỗi', 'Vui lòng nhập họ tên bệnh nhân.');
      return;
    }
    if (!patientPhone.trim()) {
      Alert.alert('Lỗi', 'Vui lòng nhập số điện thoại.');
      return;
    }
    if (!/^\d{10,11}$/.test(patientPhone.replace(/\D/g, ''))) {
      Alert.alert('Lỗi', 'Số điện thoại không hợp lệ (10-11 số).');
      return;
    }

    setLoading(true);
    try {
      console.log('=== BẮT ĐẦU ĐẶT LỊCH ===');
      const { data: { user }, error: userErr } = await supabase.auth.getUser();
      if (userErr) console.error('Lỗi lấy user:', userErr);
      if (!user) throw new Error('Chưa đăng nhập');

      console.log('USER ID:', user.id);
      console.log('Ngày:', date);
      console.log('Slot:', slot);
      console.log('Department:', department);
      console.log('Doctor:', doctor);

      const weekdays = ['Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
      const dayOfWeek = weekdays[new Date(date).getDay()];
      console.log('Thứ:', dayOfWeek);

      const { data: slotExists, error: checkError } = await supabase
        .from('doctor_schedule_template')
        .select('*')
        .eq('doctor_id', doctor.id)
        .eq('day_of_week', dayOfWeek)
        .lte('start_time', slot.start_time)
        .gte('end_time', slot.end_time)
        .maybeSingle();

      console.log('Kết quả kiểm tra slot:', { slotExists, checkError });

      if (checkError) throw new Error('Không thể kiểm tra khung giờ: ' + checkError.message);
      if (!slotExists) {
        Alert.alert('Lỗi', 'Khung giờ đã bị xóa hoặc không tồn tại. Vui lòng chọn lại.');
        navigation.goBack();
        return;
      }

      const { data: existing, error: existErr } = await supabase
        .from('appointments')
        .select('id')
        .eq('slot_id', slotExists.id)
        .eq('appointment_date', date);

      console.log('Kiểm tra lịch trùng:', { existing, existErr });

      if (existErr) console.error('Lỗi khi kiểm tra lịch:', existErr);
      if (existing && existing.length >= slotExists.max_patients_per_slot) {
        Alert.alert('Thông báo', 'Khung giờ này đã hết chỗ. Vui lòng chọn khung giờ khác.');
        setLoading(false);
        return;
      }

      console.log('Gọi RPC book_appointment_rpc với tham số:', {
        p_user_id: user.id,
        p_doctor_id: doctor.id,
        p_slot_id: slotExists.id,
        p_patient_name: patientName.trim(),
        p_patient_phone: patientPhone.trim(),
        p_department_id: department.id,
        p_appointment_date: date,
      });

      const { data, error } = await supabase.rpc('book_appointment_rpc', {
        p_user_id: user.id,
        p_doctor_id: doctor.id,
        p_slot_id: slotExists.id,
        p_patient_name: patientName.trim(),
        p_patient_phone: patientPhone.trim(),
        p_department_id: department.id,
        p_appointment_date: date,
      });

      console.log('Kết quả RPC:', { data, error });

      if (error) throw new Error(`Lỗi từ RPC: ${error.message || 'Không xác định'}`);
      const appointmentId = data.appointment_id;
      if (!appointmentId) throw new Error('Không nhận được mã lịch hẹn. Kiểm tra lại RPC. Data:', JSON.stringify(data));

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
          { text: 'Đóng', style: 'cancel' },
        ]
      );
    } catch (err) {
      console.error('LỖI ĐẶT LỊCH:', err);
      Alert.alert('Lỗi', err.message || 'Không thể đặt lịch. Vui lòng thử lại.');
    } finally {
      console.log('=== KẾT THÚC ĐẶT LỊCH ===');
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
        <View style={styles.header}>
          <TouchableOpacity onPress={() => navigation.goBack()}>
            <Ionicons name="arrow-back" size={24} color="#1F2937" />
          </TouchableOpacity>
          <Text style={styles.title}>Xác nhận đặt lịch</Text>
        </View>

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

        <View style={styles.card}>
          <Text style={styles.cardTitle}>Thông tin bệnh nhân</Text>
          <View style={styles.inputContainer}>
            <Ionicons name="person-outline" size={20} color="#6B7280" style={styles.inputIcon} />
            <TextInput
              style={styles.input}
              placeholder="Họ và tên"
              value={patientName}
              onChangeText={setPatientName}
              autoCapitalize="words"
            />
          </View>
          <View style={styles.inputContainer}>
            <Ionicons name="call-outline" size={20} color="#6B7280" style={styles.inputIcon} />
            <TextInput
              style={styles.input}
              placeholder="Số điện thoại"
              value={patientPhone}
              onChangeText={setPatientPhone}
              keyboardType="phone-pad"
              maxLength={11}
            />
          </View>
        </View>

        <View style={styles.priceCard}>
          <Text style={styles.priceLabel}>Phí khám</Text>
          <Text style={styles.priceValue}>{servicePrice}</Text>
        </View>

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
  infoRow: { flexDirection: 'row', alignItems: 'center', marginBottom: 12 },
  infoLabel: { flex: 1, marginLeft: 12, color: '#6B7280', fontSize: 14 },
  infoValue: { fontWeight: '600', color: '#1F2937', fontSize: 14 },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#E5E7EB',
    borderRadius: 12,
    paddingHorizontal: 12,
    marginBottom: 12,
    backgroundColor: '#F9FAFB',
  },
  inputIcon: { marginRight: 8 },
  input: { flex: 1, fontSize: 15, color: '#1F2937', paddingVertical: 12 },
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