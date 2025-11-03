// src/screens/patient/HistoryScreen.js
import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  Alert,
  RefreshControl,
  ActivityIndicator,
  ImageBackground,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import { supabase } from '../../api/supabase';
import QRCode from 'react-native-qrcode-svg';
import { LinearGradient } from 'expo-linear-gradient';
export default function HistoryScreen() {
  const navigation = useNavigation();
  const [appointments, setAppointments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  const fetchAppointments = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;

      const { data, error } = await supabase
        .from('appointments')
        .select(`
          id,
          status,
          patient_name,
          patient_phone,
          created_at,
          appointment_date,
          appointment_slots!inner (
            start_time,
            end_time,
            doctor_id,
            doctors!inner (
              name,
              room_number,
              department_id,
              departments!inner (
                name
              )
            )
          )
        `)
        .eq('user_id', user.id)
        .order('created_at', { ascending: false });

      if (error) throw error;

      setAppointments(data || []);
    } catch (err) {
      console.error('Lỗi lấy lịch sử:', err);
      Alert.alert('Lỗi', 'Không thể tải lịch sử đặt lịch');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  useEffect(() => {
    fetchAppointments();
  }, []);

  const onRefresh = () => {
    setRefreshing(true);
    fetchAppointments();
  };

  const handleCancel = (id) => {
    Alert.alert(
      'Hủy lịch khám',
      'Bạn có chắc chắn muốn hủy lịch này?',
      [
        { text: 'Không', style: 'cancel' },
        {
          text: 'Hủy lịch',
          style: 'destructive',
          onPress: async () => {
            try {
              const { error } = await supabase
                .from('appointments')
                .update({ status: 'cancelled' })
                .eq('id', id);

              if (error) throw error;

              setAppointments(prev =>
                prev.map(appt =>
                  appt.id === id ? { ...appt, status: 'cancelled' } : appt
                )
              );

              Alert.alert('Thành công', 'Đã hủy lịch khám');
            } catch (err) {
              Alert.alert('Lỗi', 'Không thể hủy lịch');
            }
          },
        },
      ]
    );
  };

  const renderAppointment = ({ item }) => {
    const slot = item.appointment_slots;
    const doctor = slot.doctors;
    const dept = doctor.departments;

    const timeStr = `${slot.start_time.slice(0, 5)} - ${slot.end_time.slice(0, 5)}`;
    const dateStr = new Date(item.appointment_date).toLocaleDateString('vi-VN', {
      weekday: 'long',
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
    });

    const isCancelled = item.status === 'cancelled';
    const isPast = new Date(item.appointment_date) < new Date();

    const statusConfig = {
      confirmed: { colors: ['#10B981', '#34D399'], text: 'Đã xác nhận' },
      cancelled: { colors: ['#EF4444', '#F87171'], text: 'Đã hủy' },
      past: { colors: ['#6B7280', '#9CA3AF'], text: 'Đã khám' },
    };

    const config = statusConfig[item.status === 'confirmed' ? 'confirmed' : item.status === 'cancelled' ? 'cancelled' : 'past'];

    return (
      <View style={[styles.card, isCancelled && styles.cancelledCard]}>
        <LinearGradient
          colors={['#FFFFFF', '#F8FAFC']}
          style={styles.gradient}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 1 }}
        >
          {/* HEADER */}
          <View style={styles.headerRow}>
            <View>
              <Text style={styles.doctorName}>{doctor.name}</Text>
              <Text style={styles.deptName}>{dept.name}</Text>
            </View>
            <LinearGradient
              colors={config.colors}
              style={styles.statusBadge}
            >
              <Text style={styles.statusText}>{config.text}</Text>
            </LinearGradient>
          </View>

          {/* THÔNG TIN */}
          <View style={styles.infoGrid}>
            <View style={styles.infoItem}>
              <Ionicons name="calendar" size={18} color="#10B981" />
              <Text style={styles.infoLabel}>Ngày</Text>
              <Text style={styles.infoValue}>{dateStr}</Text>
            </View>
            <View style={styles.infoItem}>
              <Ionicons name="time" size={18} color="#10B981" />
              <Text style={styles.infoLabel}>Giờ</Text>
              <Text style={styles.infoValue}>{timeStr}</Text>
            </View>
          </View>

          {doctor.room_number && (
            <View style={styles.roomRow}>
              <Ionicons name="location" size={16} color="#6366F1" />
              <Text style={styles.roomText}>Phòng {doctor.room_number}</Text>
            </View>
          )}

          {/* QR + MÃ */}
          <View style={styles.qrContainer}>
            <View style={styles.qrWrapper}>
              <QRCode value={`https://your-app.com/booking/${item.id}`} size={70} />
            </View>
            <Text style={styles.qrCode}>Mã: <Text style={styles.qrCodeBold}>{item.id}</Text></Text>
          </View>

          {/* NÚT HỦY */}
          {!isCancelled && !isPast && (
            <TouchableOpacity
              style={styles.cancelButton}
              onPress={() => handleCancel(item.id)}
            >
              <LinearGradient
                colors={['#EF4444', '#DC2626']}
                style={styles.cancelGradient}
              >
                <Ionicons name="close-circle" size={18} color="#fff" />
                <Text style={styles.cancelText}>Hủy lịch</Text>
              </LinearGradient>
            </TouchableOpacity>
          )}
        </LinearGradient>
      </View>
    );
  };

  if (loading) {
    return (
      <View style={styles.center}>
        <ActivityIndicator size="large" color="#10B981" />
      </View>
    );
  }

  return (
    <ImageBackground
      source={require('../../../assets/images/bg-pattern.png')} // Tùy chọn
      style={styles.background}
      resizeMode="cover"
    >
      <View style={styles.container}>
        <LinearGradient
          colors={['#10B981', '#34D399']}
          style={styles.header}
        >
          <Text style={styles.title}>Lịch sử đặt lịch</Text>
          <TouchableOpacity onPress={onRefresh}>
            <Ionicons name="refresh" size={26} color="#fff" />
          </TouchableOpacity>
        </LinearGradient>

        {appointments.length === 0 ? (
          <View style={styles.empty}>
            <Ionicons name="calendar-outline" size={80} color="#D1D5DB" />
            <Text style={styles.emptyTitle}>Chưa có lịch hẹn</Text>
            <Text style={styles.emptySubtitle}>Đặt lịch ngay để theo dõi!</Text>
            <TouchableOpacity
              style={styles.bookButton}
              onPress={() => navigation.navigate('BookByDate')}
            >
              <LinearGradient
                colors={['#10B981', '#34D399']}
                style={styles.bookGradient}
              >
                <Text style={styles.bookText}>Đặt lịch ngay</Text>
              </LinearGradient>
            </TouchableOpacity>
          </View>
        ) : (
          <FlatList
            data={appointments}
            keyExtractor={item => item.id.toString()}
            renderItem={renderAppointment}
            refreshControl={
              <RefreshControl refreshing={refreshing} onRefresh={onRefresh} colors={['#10B981']} />
            }
            showsVerticalScrollIndicator={false}
            contentContainerStyle={styles.list}
          />
        )}
      </View>
    </ImageBackground>
  );
}

const styles = StyleSheet.create({
  background: { flex: 1 },
  container: { flex: 1 },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 20,
    paddingTop: 50,
    borderBottomLeftRadius: 24,
    borderBottomRightRadius: 24,
    elevation: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
  },
  title: { fontSize: 22, fontWeight: '800', color: '#fff' },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: '#F9FAFB' },
  list: { padding: 16 },
  card: {
    marginBottom: 16,
    borderRadius: 20,
    overflow: 'hidden',
    elevation: 6,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.15,
    shadowRadius: 10,
  },
  cancelledCard: { opacity: 0.7 },
  gradient: { padding: 18 },
  headerRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 16,
  },
  doctorName: { fontSize: 17, fontWeight: '700', color: '#1F2937' },
  deptName: { fontSize: 14, color: '#6B7280', marginTop: 2 },
  statusBadge: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 20,
  },
  statusText: { color: '#fff', fontSize: 12, fontWeight: '600' },
  infoGrid: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 12,
  },
  infoItem: { alignItems: 'center', flex: 1 },
  infoLabel: { fontSize: 12, color: '#9CA3AF', marginTop: 4 },
  infoValue: { fontSize: 13, fontWeight: '600', color: '#1F2937', marginTop: 2 },
  roomRow: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#EEF2FF',
    alignSelf: 'flex-start',
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 12,
    marginBottom: 12,
  },
  roomText: { marginLeft: 6, fontSize: 13, color: '#6366F1', fontWeight: '600' },
  qrContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#F8FAFC',
    padding: 12,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: '#E2E8F0',
  },
  qrWrapper: {
    backgroundColor: '#fff',
    padding: 8,
    borderRadius: 12,
    elevation: 2,
  },
  qrCode: { marginLeft: 12, fontSize: 13, color: '#4B5563' },
  qrCodeBold: { fontWeight: '700', color: '#1F2937' },
  cancelButton: { marginTop: 12, borderRadius: 14, overflow: 'hidden' },
  cancelGradient: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 12,
  },
  cancelText: { color: '#fff', fontWeight: '700', marginLeft: 6 },
  empty: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 32,
  },
  emptyTitle: { fontSize: 18, fontWeight: '700', color: '#4B5563', marginTop: 16 },
  emptySubtitle: { fontSize: 14, color: '#9CA3AF', marginTop: 4 },
  bookButton: { marginTop: 24, borderRadius: 16, overflow: 'hidden' },
  bookGradient: { paddingHorizontal: 32, paddingVertical: 14 },
  bookText: { color: '#fff', fontWeight: '700', fontSize: 16 },
});