import React, { useState, useEffect } from 'react';
import { View, Text, FlatList, TouchableOpacity, ActivityIndicator, Alert } from 'react-native';
import { fetchAppointments, cancelAppointment } from '../../controllers/appointmentController';
import styles from './appointmentStyles';

export default function AppointmentScreen() {
  const [appointments, setAppointments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [errorMsg, setErrorMsg] = useState('');

  useEffect(() => {
    const load = async () => {
      try {
        const data = await fetchAppointments();
        setAppointments(data);
      } catch (err) {
        setErrorMsg(err.message);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, []);

  const handleCancel = (id) => {
    Alert.alert('Xác nhận', 'Bạn có muốn hủy lịch khám này?', [
      { text: 'Không', style: 'cancel' },
      {
        text: 'Có',
        onPress: async () => {
          try {
            await cancelAppointment(id);
            setAppointments((prev) =>
              prev.map((a) => (a.id === id ? { ...a, status: 'cancelled' } : a))
            );
          } catch (err) {
            Alert.alert('Lỗi', err.message);
          }
        },
      },
    ]);
  };

  if (loading)
    return (
      <View style={styles.center}>
        <ActivityIndicator size="large" color="#007BFF" />
        <Text>Đang tải dữ liệu...</Text>
      </View>
    );

  if (errorMsg)
    return (
      <View style={styles.center}>
        <Text style={{ color: 'red' }}>{errorMsg}</Text>
      </View>
    );

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Lịch khám của tôi</Text>
      <FlatList
        data={appointments}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <View style={styles.card}>
            <Text style={styles.doctor}>{item.doctor?.name || 'Không rõ bác sĩ'}</Text>
            <Text style={styles.specialty}>{item.doctor?.specialization || 'Chưa rõ chuyên khoa'}</Text>
            <Text style={styles.date}>
              {item.slot?.work_date || 'Chưa có ngày'} • {item.slot?.start_time || ''}
            </Text>
            {item.symptoms && (
              <Text style={styles.symptoms}>Triệu chứng: {item.symptoms}</Text>
            )}
            <Text
              style={[
                styles.status,
                styles[item.status] || {},
              ]}
            >
              {item.status}
            </Text>

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
