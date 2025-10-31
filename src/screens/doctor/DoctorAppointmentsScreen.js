import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  FlatList,
  ActivityIndicator,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { styles } from '../../styles/doctor/DoctorAppointmentsStyles';
import { DoctorAppointmentController } from '../../controllers/doctor/doctor_appointment_controller';

export default function DoctorAppointmentsScreen() {
  const [appointments, setAppointments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [doctorId, setDoctorId] = useState(null);

  useEffect(() => {
    DoctorAppointmentController.loadAppointments(
      setDoctorId,
      setAppointments,
      setLoading,
      (msg) => Alert.alert('Lỗi', msg)
    );
  }, []);

  const getStatusColor = (status) => {
    switch (status) {
      case 'confirmed':
        return '#2ecc71';
      case 'pending':
        return '#f1c40f';
      case 'completed':
        return '#3498db';
      case 'cancelled':
        return '#e74c3c';
      default:
        return '#333';
    }
  };

  const renderItem = ({ item }) => {
    const patientName = item.patient?.full_name || 'Bệnh nhân';
    const serviceName = item.service?.name || 'Dịch vụ không xác định';
    const slot = item.slot;

    // 🕓 Lấy thời gian khám từ appointment_date hoặc từ slot
    let timeDisplay = 'Chưa có thời gian';

    if (item.appointment_date) {
      const dateObj = new Date(item.appointment_date);
      if (!isNaN(dateObj)) {
        timeDisplay = dateObj.toLocaleString('vi-VN', {
          hour: '2-digit',
          minute: '2-digit',
          day: '2-digit',
          month: '2-digit',
          year: 'numeric',
        });
      }
    } else if (slot?.start_time && slot?.end_time) {
      const start = new Date(slot.start_time);
      const end = new Date(slot.end_time);
      if (!isNaN(start) && !isNaN(end)) {
        timeDisplay = `${start.toLocaleTimeString('vi-VN', {
          hour: '2-digit',
          minute: '2-digit',
        })} - ${end.toLocaleTimeString('vi-VN', {
          hour: '2-digit',
          minute: '2-digit',
        })}`;
      }
    }

    return (
      <TouchableOpacity style={styles.card}>
        <Text style={styles.name}>{patientName}</Text>
        <Text style={styles.service}>🩺 {serviceName}</Text>
        <Text style={styles.time}>🕓 {timeDisplay}</Text>
        {item.symptoms ? (
          <Text style={styles.symptoms}>🤒 {item.symptoms}</Text>
        ) : null}
        <Text style={[styles.status, { color: getStatusColor(item.status) }]}>
          Trạng thái: {item.status}
        </Text>
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>📅 Lịch hẹn của tôi</Text>

      {loading ? (
        <ActivityIndicator size="large" color="#007AFF" style={{ marginTop: 20 }} />
      ) : appointments.length === 0 ? (
        <Text style={styles.emptyText}>Không có lịch hẹn nào.</Text>
      ) : (
        <FlatList
          data={appointments}
          keyExtractor={(item) => item.id}
          renderItem={renderItem}
          contentContainerStyle={{ paddingBottom: 20 }}
        />
      )}
    </View>
  );
}
