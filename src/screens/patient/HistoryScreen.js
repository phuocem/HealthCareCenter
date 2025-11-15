import React, { useState, useEffect, useCallback, useRef } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, Alert, RefreshControl, ActivityIndicator, Platform } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import { LinearGradient } from 'expo-linear-gradient';
import Animated, { FadeInDown, ZoomIn } from 'react-native-reanimated';
import AppointmentCard from '../../components/AppointmentCard';
import { AppointmentController } from '../../controllers/patient/AppointmentController';
import { supabase } from '../../api/supabase';

const Colors = {
  primary: '#1D4ED8',
  secondary: '#38BDF8',
  iconBgStart: '#E0F2FE',
  iconBgEnd: '#BFDBFE',
  textPrimary: '#1E293B',
  textSecondary: '#6B7280',
  border: '#F1F5F9',
  cardBg: '#FFFFFF',
  shadow: '#000',
  bg: '#F4F7FC',
  danger: '#DC2626',
  muted: '#9CA3AF',
  success: '#059669',
};

export default function HistoryScreen() {
  const navigation = useNavigation();
  const [appointments, setAppointments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState(null);
  const previousAppointmentsRef = useRef([]); // Lưu danh sách trước đó
  const notifiedAppointmentsRef = useRef(new Set()); // Theo dõi các cuộc hẹn đã thông báo

  const fetchAppointments = useCallback(async () => {
    await AppointmentController.loadAppointments(setAppointments, setLoading, setError);
  }, []);

  useEffect(() => {
    fetchAppointments();
  }, [fetchAppointments]);

  const onRefresh = () => {
    setRefreshing(true);
    fetchAppointments();
  };

  const handleCancel = useCallback(async (id) => {
    Alert.alert(
      'Hủy lịch khám',
      'Bạn có chắc chắn muốn hủy lịch này?',
      [
        { text: 'Không', style: 'cancel' },
        {
          text: 'Hủy lịch',
          style: 'destructive',
          onPress: async () => {
            const { success, message } = await AppointmentController.cancelAppointment(id, setAppointments, setError);
            if (success) {
              Alert.alert('Thành công', message);
            } else {
              Alert.alert('Lỗi', message);
            }
          },
        },
      ],
      { cancelable: true }
    );
  }, []);

  const handleDoctorCancelNotification = useCallback((appointment) => {
    if (appointment.status === 'doctor_cancelled' && !notifiedAppointmentsRef.current.has(appointment.id)) {
      Alert.alert(
        'Lịch hẹn bị hủy',
        `Lịch hẹn của bạn với ${appointment.doctor.name || 'bác sĩ'} đã bị hủy bởi bác sĩ.\nLý do: ${appointment.cancelled_by?.reason || 'Không có lý do'}`,
        [
          { text: 'Đóng', style: 'cancel' },
          {
            text: 'Đặt lại',
            onPress: () => navigation.navigate('BookingOptionsScreen', { doctorId: appointment.doctor_id }),
          },
        ],
        { cancelable: true }
      );
      notifiedAppointmentsRef.current.add(appointment.id); // Đánh dấu đã thông báo
      // Cập nhật notified trong database (nếu cột tồn tại)
      if (appointment.id && 'notified' in appointment) {
        supabase
          .from('appointments')
          .update({ notified: true })
          .eq('id', appointment.id)
          .then(() => console.log('Đánh dấu thông báo thành công'))
          .catch(err => console.error('Lỗi đánh dấu thông báo:', err));
      }
    }
  }, [navigation]);

  // Kiểm tra các cuộc hẹn mới bị hủy khi danh sách thay đổi
  useEffect(() => {
    if (!loading && !refreshing) {
      const newAppointments = appointments.filter(
        app => !previousAppointmentsRef.current.some(prev => prev.id === app.id) || 
               (app.status === 'doctor_cancelled' && !previousAppointmentsRef.current.find(prev => prev.id === app.id)?.notified)
      );
      newAppointments.forEach(appointment => {
        handleDoctorCancelNotification(appointment);
      });
      previousAppointmentsRef.current = appointments; // Cập nhật danh sách trước đó
    }
  }, [appointments, loading, refreshing, handleDoctorCancelNotification]);

  if (loading && !refreshing) {
    return (
      <View style={styles.center}>
        <ActivityIndicator size="large" color={Colors.primary} />
        <Text style={styles.loadingText}>Đang tải lịch sử...</Text>
      </View>
    );
  }

  return (
    <View style={styles.background}>
      <Animated.View entering={FadeInDown.duration(500)} style={styles.headerContainer}>
        <LinearGradient
          colors={[Colors.primary, Colors.secondary]}
          style={styles.header}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 0 }}
        >
          <TouchableOpacity
            style={styles.iconButton}
            onPress={() => navigation.navigate('HomeScreen')}
            activeOpacity={0.7}
          >
            <Ionicons name="arrow-back" size={24} color="#FFF" />
          </TouchableOpacity>
          <Text style={styles.title}>Lịch sử đặt lịch</Text>
          <TouchableOpacity onPress={onRefresh} style={styles.iconButton}>
            <Ionicons name="refresh" size={24} color="#FFF" />
          </TouchableOpacity>
        </LinearGradient>
      </Animated.View>

      <View style={styles.container}>
        {error ? (
          <Text style={styles.errorText}>{error}</Text>
        ) : appointments.length === 0 ? (
          <Animated.View entering={ZoomIn.duration(500)} style={styles.empty}>
            <View style={styles.emptyIconContainer}>
              <LinearGradient
                colors={['#BFDBFE', '#E0F2FE']}
                style={styles.emptyIcon}
                start={{ x: 0, y: 0 }}
                end={{ x: 1, y: 1 }}
              >
                <Ionicons name="calendar-outline" size={60} color={Colors.primary} />
              </LinearGradient>
            </View>
            <Text style={styles.emptyTitle}>Chưa có lịch hẹn nào</Text>
            <Text style={styles.emptySubtitle}>Hãy đặt lịch khám đầu tiên của bạn ngay!</Text>
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
                <Ionicons name="calendar-add-outline" size={20} color="#FFF" />
                <Text style={styles.bookText}>Đặt lịch ngay</Text>
              </LinearGradient>
            </TouchableOpacity>
          </Animated.View>
        ) : (
          <FlatList
            data={appointments}
            keyExtractor={item => item.id.toString()}
            renderItem={({ item, index }) => <AppointmentCard item={item} index={index} onCancel={handleCancel} />}
            refreshControl={
              <RefreshControl
                refreshing={refreshing}
                onRefresh={onRefresh}
                colors={[Colors.primary]}
                tintColor={Colors.primary}
              />
            }
            showsVerticalScrollIndicator={false}
            contentContainerStyle={styles.list}
            ListEmptyComponent={<Text style={styles.emptyText}>Không có lịch hẹn nào.</Text>}
          />
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  background: { flex: 1, backgroundColor: Colors.bg },
  headerContainer: { paddingTop: Platform.OS === 'ios' ? 50 : 30, backgroundColor: Colors.primary },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingVertical: 18,
    borderBottomLeftRadius: 30,
    borderBottomRightRadius: 30,
    backgroundColor: 'transparent',
  },
  iconButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: { fontSize: 24, fontWeight: '800', color: '#FFF' },
  container: { flex: 1 },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: Colors.bg },
  loadingText: { marginTop: 12, fontSize: 16, color: Colors.textPrimary, fontWeight: '600' },
  list: { padding: 16, paddingBottom: 30 },
  errorText: { textAlign: 'center', color: Colors.danger, padding: 16 },
  empty: { flex: 1, justifyContent: 'center', alignItems: 'center', padding: 32 },
  emptyIconContainer: {
    width: 110,
    height: 110,
    borderRadius: 55,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 20,
    overflow: 'hidden',
    borderWidth: 4,
    borderColor: '#E0F2FE',
  },
  emptyIcon: {
    width: '100%',
    height: '100%',
    justifyContent: 'center',
    alignItems: 'center',
    opacity: 0.9,
  },
  emptyTitle: { fontSize: 20, fontWeight: '800', color: Colors.textPrimary, marginBottom: 8 },
  emptySubtitle: { fontSize: 14, color: Colors.textSecondary, marginBottom: 30, textAlign: 'center' },
  emptyText: { textAlign: 'center', color: Colors.muted, padding: 16 },
  bookButton: { borderRadius: 18, overflow: 'hidden' },
  bookGradient: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingHorizontal: 32, paddingVertical: 14, gap: 8 },
  bookText: { color: '#FFF', fontWeight: '700', fontSize: 16 },
});