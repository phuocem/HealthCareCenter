import React, { useEffect, useState } from 'react';
import { View, Text, FlatList, ActivityIndicator, StyleSheet, TouchableOpacity } from 'react-native';
import { supabase } from '../../api/supabase';
import { MaterialIcons } from '@expo/vector-icons';

export default function AppointmentScreen() {
  const [appointments, setAppointments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [userId, setUserId] = useState(null);

  useEffect(() => {
    getUserAndFetchAppointments();
  }, []);

  const getUserAndFetchAppointments = async () => {
    try {
      setLoading(true);
      const { data: { user }, error: userError } = await supabase.auth.getUser();

      if (userError) throw userError;
      if (!user) throw new Error('Chưa đăng nhập.');

      setUserId(user.id);

      const { data, error } = await supabase
        .from('appointments')
        .select('*')
        .eq('user_id', user.id)
        .not('appointment_date', 'is', null)
        .order('appointment_date', { ascending: true });

      if (error) throw error;

      setAppointments(data || []);
    } catch (err) {
      console.error('Lỗi khi lấy lịch hẹn:', err.message);
    } finally {
      setLoading(false);
    }
  };

  const formatDate = (isoString) => {
    if (!isoString) return 'Chưa đặt lịch';
    const date = new Date(isoString);
    return date.toLocaleString('vi-VN', {
      weekday: 'long',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  if (loading) {
    return (
      <View style={styles.center}>
        <ActivityIndicator size="large" color="#00bcd4" />
      </View>
    );
  }

  if (appointments.length === 0) {
    return (
      <View style={styles.center}>
        <MaterialIcons name="event-busy" size={60} color="#ccc" />
        <Text style={styles.emptyText}>Bạn chưa có lịch hẹn nào</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.header}>📅 Lịch hẹn của bạn</Text>

      <FlatList
        data={appointments}
        keyExtractor={(item) => item.id.toString()}
        renderItem={({ item }) => (
          <View style={styles.card}>
            <View style={styles.row}>
              <MaterialIcons name="event" size={24} color="#00bcd4" />
              <Text style={styles.dateText}>{formatDate(item.appointment_date)}</Text>
            </View>

            <Text style={styles.detailText}>
              Trạng thái: {item.status || 'Đã đặt'}
            </Text>

            {item.doctor_name && (
              <Text style={styles.detailText}>Bác sĩ: {item.doctor_name}</Text>
            )}
          </View>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f9fa', padding: 16 },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  header: { fontSize: 22, fontWeight: 'bold', marginBottom: 16, color: '#333' },
  card: {
    backgroundColor: '#fff',
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    shadowColor: '#000',
    shadowOpacity: 0.1,
    shadowOffset: { width: 0, height: 2 },
    shadowRadius: 4,
    elevation: 2,
  },
  row: { flexDirection: 'row', alignItems: 'center', marginBottom: 8 },
  dateText: { marginLeft: 8, fontSize: 16, fontWeight: '500', color: '#333' },
  detailText: { fontSize: 14, color: '#666', marginTop: 4 },
  emptyText: { fontSize: 16, color: '#aaa', marginTop: 8 },
});
