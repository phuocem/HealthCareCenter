import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  FlatList,
  TouchableOpacity,
  ActivityIndicator,
  Alert,
} from 'react-native';
import { supabase } from '../../api/supabase';
import { styles } from './AppointmentScreen.styles'; // 👈 import file style riêng

export default function AppointmentScreen() {
  const [appointments, setAppointments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [errorMsg, setErrorMsg] = useState('');

  useEffect(() => {
    const loadAppointments = async () => {
      try {
        const { data, error } = await supabase
          .from('appointments')
          .select(`
            id,
            status,
            symptoms,
            created_at,
            doctor:doctors (
              name,
              specialization
            ),
            slot: appointment_slots (
              work_date,
              start_time,
              end_time
            )
          `)
          .order('created_at', { ascending: false });

        if (error) throw error;
        setAppointments(data || []);
      } catch (error) {
        console.error('Lỗi tải lịch khám:', error.message);
        setErrorMsg('Không thể tải dữ liệu lịch khám.');
      } finally {
        setLoading(false);
      }
    };

    loadAppointments();
  }, []);

  const handleCancel = async (id) => {
    Alert.alert('Xác nhận', 'Bạn có muốn hủy lịch khám này?', [
      { text: 'Không', style: 'cancel' },
      {
        text: 'Có',
        onPress: async () => {
          try {
            const { error } = await supabase
              .from('appointments')
              .update({ status: 'cancelled' })
              .eq('id', id);
            if (error) throw error;

            setAppointments((prev) =>
              prev.map((item) =>
                item.id === id ? { ...item, status: 'cancelled' } : item
              )
            );
          } catch (error) {
            console.error('Lỗi khi hủy lịch:', error.message);
            Alert.alert('Lỗi', 'Không thể hủy lịch. Vui lòng thử lại.');
          }
        },
      },
    ]);
  };

  if (loading) {
    return (
      <View style={styles.center}>
        <ActivityIndicator size="large" color="#007BFF" />
        <Text>Đang tải dữ liệu...</Text>
      </View>
    );
  }

  if (errorMsg) {
    return (
      <View style={styles.center}>
        <Text style={{ color: 'red' }}>{errorMsg}</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Lịch khám của tôi</Text>

      <FlatList
        data={appointments}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <View style={styles.card}>
            <View style={styles.info}>
              <Text style={styles.doctor}>
                {item.doctor?.name || 'Không rõ bác sĩ'}
              </Text>
              <Text style={styles.specialty}>
                {item.doctor?.specialization || 'Chưa rõ chuyên khoa'}
              </Text>
              <Text style={styles.date}>
                {item.slot?.work_date || 'Chưa có ngày'} •{' '}
                {item.slot?.start_time || ''} - {item.slot?.end_time || ''}
              </Text>
              {item.symptoms && (
                <Text style={styles.symptoms}>Triệu chứng: {item.symptoms}</Text>
              )}
              <Text
                style={[
                  styles.status,
                  item.status === 'confirmed'
                    ? styles.confirmed
                    : item.status === 'pending'
                    ? styles.pending
                    : item.status === 'completed'
                    ? styles.completed
                    : styles.cancelled,
                ]}
              >
                {item.status}
              </Text>
            </View>

            {item.status !== 'cancelled' && item.status !== 'completed' && (
              <TouchableOpacity
                style={styles.cancelButton}
                onPress={() => handleCancel(item.id)}
              >
                <Text style={styles.cancelText}>Hủy lịch</Text>
              </TouchableOpacity>
            )}
          </View>
        )}
        ListEmptyComponent={<Text style={styles.empty}>Không có lịch khám nào.</Text>}
      />
    </View>
  );
}
