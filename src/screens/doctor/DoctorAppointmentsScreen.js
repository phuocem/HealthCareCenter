// screens/doctor/DoctorAppointmentsScreen.js
import React, { useEffect, useState } from 'react';
import { View, Text, FlatList, ActivityIndicator, TouchableOpacity, Alert } from 'react-native';
import { styles } from '../../styles/doctor/DoctorAppointmentsStyles';
import { DoctorAppointmentController } from '../../controllers/doctor_appointment_controller';

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
      case 'confirmed': return '#2ecc71';
      case 'pending': return '#f1c40f';
      case 'completed': return '#3498db';
      case 'cancelled': return '#e74c3c';
      default: return '#333';
    }
  };

  const renderItem = ({ item }) => {
    const patientName = item.profiles?.full_name || 'Bệnh nhân';
    const serviceName = item.services?.name || 'Dịch vụ không xác định';
    const slot = item.appointment_slots;
    const timeRange =
      slot?.start_time && slot?.end_time
        ? `${new Date(slot.start_time).toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' })} - ${new Date(slot.end_time).toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' })}`
        : 'Chưa có thời gian';

    return (
      <TouchableOpacity style={styles.card}>
        <Text style={styles.name}>{patientName}</Text>
        <Text style={styles.service}>🩺 {serviceName}</Text>
        <Text style={styles.time}>🕓 {timeRange}</Text>
        {item.symptoms ? <Text style={styles.symptoms}>🤒 {item.symptoms}</Text> : null}
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
