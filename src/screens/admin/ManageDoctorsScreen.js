import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  FlatList,
  TouchableOpacity,
  Alert,
  ActivityIndicator,
  StyleSheet,
} from 'react-native';
import { getAllDoctorsService, deleteDoctorService } from '../../services/doctorService';

export default function ManageDoctorsScreen() {
  const [doctors, setDoctors] = useState([]);
  const [loading, setLoading] = useState(false);

  // 🔹 Load danh sách bác sĩ
  const loadDoctors = async () => {
    try {
      setLoading(true);
      const data = await getAllDoctorsService();
      setDoctors(data);
    } catch (error) {
      Alert.alert('Lỗi tải dữ liệu', error.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadDoctors();
  }, []);

  // 🔹 Xử lý xoá bác sĩ
  const handleDelete = (id) => {
    Alert.alert('Xác nhận xoá', 'Bạn có chắc chắn muốn xoá bác sĩ này?', [
      { text: 'Huỷ', style: 'cancel' },
      {
        text: 'Xoá',
        style: 'destructive',
        onPress: async () => {
          try {
            setLoading(true);
            await deleteDoctorService(id);
            Alert.alert('✅ Thành công', 'Đã xoá bác sĩ');
            loadDoctors();
          } catch (error) {
            Alert.alert('Lỗi', error.message);
          } finally {
            setLoading(false);
          }
        },
      },
    ]);
  };

  // 🔹 Render từng bác sĩ
  const renderDoctor = ({ item }) => (
    <View style={styles.card}>
      <View style={{ flex: 1 }}>
        <Text style={styles.name}>{item.user_profiles?.full_name || 'Chưa có tên'}</Text>
        <Text style={styles.email}>{item.user_profiles?.email || 'Không có email'}</Text>
        <Text style={styles.info}>
          🏥 Khoa: {item.department_id || 'Chưa gán'} | 💼 KN: {item.experience_years || 0} năm
        </Text>
      </View>

      <TouchableOpacity style={styles.deleteBtn} onPress={() => handleDelete(item.id)}>
        <Text style={styles.deleteText}>Xoá</Text>
      </TouchableOpacity>
    </View>
  );

  return (
    <View style={styles.container}>
      <Text style={styles.title}>👨‍⚕️ Danh sách Bác sĩ</Text>

      {loading ? (
        <ActivityIndicator size="large" color="#007bff" style={{ marginTop: 30 }} />
      ) : doctors.length === 0 ? (
        <Text style={{ textAlign: 'center', marginTop: 30, color: '#777' }}>
          Không có bác sĩ nào.
        </Text>
      ) : (
        <FlatList
          data={doctors}
          keyExtractor={(item) => item.id}
          renderItem={renderDoctor}
          contentContainerStyle={{ paddingBottom: 50 }}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f9fa', padding: 16 },
  title: { fontSize: 22, fontWeight: 'bold', marginBottom: 16, textAlign: 'center' },
  card: {
    backgroundColor: '#fff',
    borderRadius: 10,
    padding: 16,
    marginBottom: 10,
    flexDirection: 'row',
    alignItems: 'center',
    elevation: 2,
  },
  name: { fontSize: 16, fontWeight: '600' },
  email: { color: '#555', marginVertical: 4 },
  info: { color: '#777', fontSize: 13 },
  deleteBtn: {
    backgroundColor: '#ff4444',
    paddingVertical: 8,
    paddingHorizontal: 12,
    borderRadius: 8,
    marginLeft: 10,
  },
  deleteText: { color: '#fff', fontWeight: 'bold' },
});
