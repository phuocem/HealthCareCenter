import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, FlatList, ActivityIndicator } from 'react-native';
import { supabase } from '../../api/supabase';

export default function DoctorListScreen() {
  const [doctors, setDoctors] = useState([]);
  const [loading, setLoading] = useState(true);
  const [errorMsg, setErrorMsg] = useState('');

  useEffect(() => {
    const loadDoctors = async () => {
      try {
        const { data, error } = await supabase
          .from('doctors')
.select('id, name, specialization')
          .order('id', { ascending: true });

        if (error) throw error;

        setDoctors(data || []);
      } catch (error) {
        console.error('Lỗi tải danh sách bác sĩ:', error.message);
        setErrorMsg('Không thể tải danh sách bác sĩ.');
      } finally {
        setLoading(false);
      }
    };

    loadDoctors();
  }, []);

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
      <Text style={styles.title}>Danh sách bác sĩ</Text>
      <FlatList
        data={doctors}
        keyExtractor={(item) => item.id.toString()}
        renderItem={({ item }) => (
          <View style={styles.card}>
            <Text style={styles.name}>{item.name}</Text>
            <Text style={styles.specialty}>{item.specialty}</Text>
          </View>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#fff', padding: 16 },
  title: { fontSize: 20, fontWeight: 'bold', marginBottom: 12 },
  card: {
    backgroundColor: '#f9f9f9',
    padding: 16,
    borderRadius: 10,
    marginBottom: 10,
  },
  name: { fontSize: 16, fontWeight: '600' },
  specialty: { color: '#555' },
  center: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
