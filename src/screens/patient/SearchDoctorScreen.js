import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, FlatList, ActivityIndicator } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import { searchDoctorController } from '../../controllers/patient/searchDoctorController';
import { styles } from '../../styles/patient/SearchDoctorStyles';

export default function SearchDoctorScreen() {
  const [query, setQuery] = useState('');
  const [doctors, setDoctors] = useState([]);
  const [loading, setLoading] = useState(false);
  const navigation = useNavigation();

  const handleSearch = async (text) => {
    setQuery(text);

    if (!text.trim()) {
      setDoctors([]);
      return;
    }

    setLoading(true);
    try {
      const result = await searchDoctorController(text);
      setDoctors(result);
    } catch (error) {
      console.error('❌ Lỗi khi tìm bác sĩ:', error);
      setDoctors([]);
    } finally {
      setLoading(false);
    }
  };

  const renderDoctor = ({ item }) => (
    <View style={styles.doctorCard}>
      <Text style={styles.doctorName}>
        {item.user_profiles?.full_name || 'Không rõ tên'}
      </Text>
      <Text style={styles.doctorDepartment}>
        Khoa: {item.department_id || 'Chưa gán khoa'}
      </Text>

      <TouchableOpacity
        style={styles.bookButton}
        onPress={() => navigation.navigate('BookingScreen', { doctorId: item.id })}
      >
        <Ionicons name="calendar-outline" size={20} color="white" />
        <Text style={styles.bookButtonText}>Đặt lịch</Text>
      </TouchableOpacity>
    </View>
  );

  return (
    <View style={styles.container}>
      <TextInput
        placeholder="🔍 Tìm bác sĩ theo tên..."
        value={query}
        onChangeText={handleSearch}
        style={styles.searchInput}
      />
      {loading ? (
        <ActivityIndicator size="large" color="#007AFF" />
      ) : (
        <FlatList
          data={doctors}
          keyExtractor={(item) => item.id.toString()}
          renderItem={renderDoctor}
          ListEmptyComponent={
            <Text style={styles.emptyText}>
              {query
                ? 'Không tìm thấy bác sĩ phù hợp.'
                : 'Nhập tên bác sĩ để tìm kiếm.'}
            </Text>
          }
        />
      )}
    </View>
  );
}
