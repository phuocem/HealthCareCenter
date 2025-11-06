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
  Platform,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import { supabase } from '../../api/supabase';
import QRCode from 'react-native-qrcode-svg';
import { LinearGradient } from 'expo-linear-gradient';
import Animated, { FadeInUp, ZoomIn, FadeInDown } from 'react-native-reanimated';

const Colors = {
  primary: '#1D4ED8',
  secondary: '#38BDF8',
  iconBgStart: '#E0F2FE',
  iconBgEnd: '#BFDBFE',
  textPrimary: '#1E293B',
  textSecondary: '#4B5563',
  border: '#F1F5F9',
  cardBg: '#FFFFFF',
  shadow: '#000',
  bg: '#F8FAFC',
};

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
          slot_id,
          doctor_id,
          department_id,
          doctor_schedule_template!inner (
            start_time,
            end_time,
            doctor_id,
            doctors (
              name,
              room_number,
              department_id,
              departments (
                name
              )
            )
          )
        `)
        .eq('user_id', user.id)
        .order('created_at', { ascending: false });
      if (error) throw error;
      console.log('Dữ liệu appointments:', data); // Log để kiểm tra
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

  const renderAppointment = ({ item, index }) => {
    const slot = item.doctor_schedule_template || {};
    const doctor = slot.doctors?.[0] || {};
    const dept = doctor.departments?.[0] || {};
    const timeStr = slot.start_time && slot.end_time
      ? `${slot.start_time.slice(0, 5)} - ${slot.end_time.slice(0, 5)}`
      : 'Không xác định';
    const dateStr = item.appointment_date
      ? new Date(item.appointment_date).toLocaleDateString('vi-VN', {
          timeZone: 'Asia/Ho_Chi_Minh',
          weekday: 'short',
          day: '2-digit',
          month: '2-digit',
          year: 'numeric',
        })
      : 'Không xác định';
    const isCancelled = item.status === 'cancelled';
    const isPast = item.appointment_date ? new Date(item.appointment_date) < new Date() : false;
    const statusConfig = {
      confirmed: { colors: [Colors.primary, Colors.secondary], text: 'Đã xác nhận', icon: 'checkmark-circle' },
      cancelled: { colors: ['#EF4444', '#F87171'], text: 'Đã hủy', icon: 'close-circle' },
      past: { colors: ['#6B7280', '#9CA3AF'], text: 'Đã khám', icon: 'checkmark-done' },
    };
    const config = statusConfig[item.status === 'confirmed' ? 'confirmed' : item.status === 'cancelled' ? 'cancelled' : 'past'];

    return (
      <Animated.View entering={FadeInUp.delay(index * 60).duration(400)} style={styles.cardWrapper}>
        <TouchableOpacity activeOpacity={0.92} disabled={isCancelled}>
          <View style={[styles.card, isCancelled && styles.cancelledCard]}>
            <LinearGradient
              colors={[Colors.cardBg, '#FCFDFE']}
              style={styles.gradient}
              start={{ x: 0, y: 0 }}
              end={{ x: 1, y: 1 }}
            >
              <View style={styles.headerRow}>
                <View style={styles.doctorInfo}>
                  <Text style={styles.doctorName}>{doctor.name || 'Không xác định'}</Text>
                  <Text style={styles.deptName}>{dept.name || 'Không xác định'}</Text>
                </View>
                <LinearGradient
                  colors={config.colors}
                  style={styles.statusBadge}
                  start={{ x: 0, y: 0 }}
                  end={{ x: 1, y: 0 }}
                >
                  <Ionicons name={config.icon} size={15} color="#FFF" />
                  <Text style={styles.statusText}>{config.text}</Text>
                </LinearGradient>
              </View>
              {/* THÔNG TIN NGÀY GIỜ */}
              <View style={styles.infoRow}>
                <View style={styles.infoItem}>
                  <Ionicons name="calendar" size={18} color={Colors.primary} />
                  <Text style={styles.infoValue}>{dateStr}</Text>
                </View>
                <View style={styles.infoItem}>
                  <Ionicons name="time" size={18} color={Colors.primary} />
                  <Text style={styles.infoValue}>{timeStr}</Text>
                </View>
                {doctor.room_number && (
                  <View style={styles.infoItem}>
                    <Ionicons name="location" size={18} color={Colors.primary} />
                    <Text style={styles.infoValue}>P.{doctor.room_number}</Text>
                  </View>
                )}
              </View>
              <View style={styles.qrRow}>
                <View style={styles.qrBox}>
                  <QRCode value={`https://your-app.com/booking/${item.id}`} size={48} />
                </View>
                <Text style={styles.qrCode} numberOfLines={1} ellipsizeMode="middle">
                  {item.id}
                </Text>
              </View>
              {/* NÚT HỦY */}
              {!isCancelled && !isPast && (
                <TouchableOpacity
                  style={styles.cancelButton}
                  onPress={() => handleCancel(item.id)}
                  activeOpacity={0.8}
                >
                  <LinearGradient
                    colors={['#EF4444', '#DC2626']}
                    style={styles.cancelGradient}
                    start={{ x: 0, y: 0 }}
                    end={{ x: 1, y: 0 }}
                  >
                    <Ionicons name="close" size={18} color="#FFF" />
                    <Text style={styles.cancelText}>Hủy</Text>
                  </LinearGradient>
                </TouchableOpacity>
              )}
            </LinearGradient>
          </View>
        </TouchableOpacity>
      </Animated.View>
    );
  };

  if (loading) {
    return (
      <View style={styles.center}>
        <ActivityIndicator size="large" color={Colors.primary} />
        <Text style={styles.loadingText}>Đang tải...</Text>
      </View>
    );
  }

  return (
    <View style={styles.background}>
      {/* HEADER + NÚT BACK */}
      <Animated.View entering={FadeInDown.duration(500)} style={styles.headerContainer}>
        <LinearGradient
          colors={[Colors.primary, Colors.secondary]}
          style={styles.header}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 0 }}
        >
          <TouchableOpacity
            style={styles.backButton}
            onPress={() => navigation.navigate('HomeScreen')}
            activeOpacity={0.7}
          >
            <Ionicons name="arrow-back" size={26} color="#FFF" />
          </TouchableOpacity>
          <Text style={styles.title}>Lịch sử đặt lịch</Text>
          <TouchableOpacity onPress={onRefresh} style={styles.refreshButton}>
            <Ionicons name="refresh" size={24} color="#FFF" />
          </TouchableOpacity>
        </LinearGradient>
      </Animated.View>
      <View style={styles.container}>
        {appointments.length === 0 ? (
          <Animated.View entering={ZoomIn.duration(500)} style={styles.empty}>
            <View style={styles.emptyIcon}>
              <Ionicons name="calendar-outline" size={70} color={Colors.textSecondary} />
            </View>
            <Text style={styles.emptyTitle}>Chưa có lịch hẹn</Text>
            <Text style={styles.emptySubtitle}>Đặt ngay để theo dõi!</Text>
            <TouchableOpacity
              style={styles.bookButton}
              onPress={() => navigation.navigate('BookByDate')}
              activeOpacity={0.8}
            >
              <LinearGradient
                colors={[Colors.primary, Colors.secondary]}
                style={styles.bookGradient}
                start={{ x: 0, y: 0 }}
                end={{ x: 1, y: 0 }}
              >
                <Ionicons name="add" size={20} color="#FFF" />
                <Text style={styles.bookText}>Đặt lịch</Text>
              </LinearGradient>
            </TouchableOpacity>
          </Animated.View>
        ) : (
          <FlatList
            data={appointments}
            keyExtractor={item => item.id.toString()}
            renderItem={renderAppointment}
            refreshControl={
              <RefreshControl refreshing={refreshing} onRefresh={onRefresh} colors={[Colors.primary]} />
            }
            showsVerticalScrollIndicator={false}
            contentContainerStyle={styles.list}
          />
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  background: { flex: 1, backgroundColor: Colors.bg },
  headerContainer: {
    paddingTop: Platform.OS === 'ios' ? 60 : 40,
    paddingHorizontal: 16,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 18,
    paddingVertical: 16,
    borderBottomLeftRadius: 28,
    borderBottomRightRadius: 28,
    elevation: 12,
    shadowColor: Colors.shadow,
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.25,
    shadowRadius: 16,
  },
  backButton: {
    width: 46,
    height: 46,
    borderRadius: 23,
    backgroundColor: 'rgba(255, 255, 255, 0.28)',
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 1.2,
    borderColor: 'rgba(255, 255, 255, 0.35)',
    elevation: 6,
  },
  title: { fontSize: 22, fontWeight: '800', color: '#FFF' },
  refreshButton: { padding: 4 },
  container: { flex: 1 },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  loadingText: { marginTop: 12, fontSize: 16, color: Colors.textPrimary, fontWeight: '600' },
  list: { padding: 16, paddingTop: 14 },
  cardWrapper: { marginBottom: 14 },
  card: {
    borderRadius: 22,
    overflow: 'hidden',
    elevation: 8,
    shadowColor: Colors.shadow,
    shadowOffset: { width: 0, height: 6 },
    shadowOpacity: 0.18,
    shadowRadius: 16,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  cancelledCard: { opacity: 0.7 },
  gradient: { padding: 16 },
  headerRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 12,
  },
  doctorInfo: { flex: 1, marginRight: 10 },
  doctorName: { fontSize: 16.5, fontWeight: '800', color: Colors.textPrimary },
  deptName: { fontSize: 13.5, color: Colors.textSecondary, marginTop: 2, fontWeight: '600' },
  statusBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 11,
    paddingVertical: 5,
    borderRadius: 18,
    gap: 5,
  },
  statusText: { color: '#FFF', fontSize: 11.5, fontWeight: '700' },
  infoRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 12,
    paddingHorizontal: 4,
  },
  infoItem: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
    justifyContent: 'center',
  },
  infoValue: { marginLeft: 6, fontSize: 13.5, fontWeight: '700', color: Colors.textPrimary },
  qrRow: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#F8FAFC',
    paddingVertical: 10,
    paddingHorizontal: 12,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: '#E2E8F0',
  },
  qrBox: {
    width: 56,
    height: 56,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#FFF',
    borderRadius: 12,
    padding: 4,
  },
  qrCode: {
    marginLeft: 12,
    fontSize: 12,
    color: Colors.textPrimary,
    fontWeight: '700',
    flex: 1,
  },
  cancelButton: { marginTop: 10, borderRadius: 14, overflow: 'hidden' },
  cancelGradient: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 10,
    paddingHorizontal: 16,
  },
  cancelText: { color: '#FFF', fontWeight: '700', fontSize: 14, marginLeft: 6 },
  empty: { flex: 1, justifyContent: 'center', alignItems: 'center', padding: 32 },
  emptyIcon: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: 'rgba(226, 232, 240, 0.5)',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 20,
  },
  emptyTitle: { fontSize: 19, fontWeight: '800', color: Colors.textPrimary, marginBottom: 8 },
  emptySubtitle: { fontSize: 14, color: Colors.textSecondary, marginBottom: 20, textAlign: 'center' },
  bookButton: { borderRadius: 16, overflow: 'hidden' },
  bookGradient: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingHorizontal: 28, paddingVertical: 12 },
  bookText: { color: '#FFF', fontWeight: '700', fontSize: 16, marginLeft: 8 },
});