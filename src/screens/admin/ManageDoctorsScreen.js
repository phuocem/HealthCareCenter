import React, { useEffect, useState, useCallback } from 'react';
import {
  View,
  Text,
  FlatList,
  TouchableOpacity,
  Alert,
  ActivityIndicator,
  RefreshControl,
  Image,
} from 'react-native';
import { MaterialIcons, Ionicons } from '@expo/vector-icons';
import { getAllDoctorsService, deleteDoctorService } from '../../services/doctorService';
import { styles } from '../../styles/admin/ManageDoctorsStyles';
import { useNavigation, useFocusEffect } from '@react-navigation/native';

export default function ManageDoctorsScreen() {
  const [doctors, setDoctors] = useState([]);
  const [loading, setLoading] = useState(false);
  const [refreshing, setRefreshing] = useState(false);
  const navigation = useNavigation();

  const loadDoctors = async (isRefresh = false) => {
    try {
      if (!isRefresh) setLoading(true);
      const data = await getAllDoctorsService();
      setDoctors(data || []);
    } catch (error) {
      Alert.alert('Lỗi', error.message || 'Không thể tải dữ liệu bác sĩ');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  useFocusEffect(
    useCallback(() => {
      loadDoctors();
    }, [])
  );

  const onRefresh = useCallback(() => {
    setRefreshing(true);
    loadDoctors(true);
  }, []);

  const handleDelete = (id, name) => {
    Alert.alert(
      'Xác nhận xoá',
      `Bạn có chắc chắn muốn xoá bác sĩ:\n${name || 'Không rõ tên'}?`,
      [
        { text: 'Huỷ', style: 'cancel' },
        {
          text: 'Xoá',
          style: 'destructive',
          onPress: async () => {
            try {
              setLoading(true);
              await deleteDoctorService(id);
              Alert.alert('Thành công', 'Đã xoá bác sĩ');
              loadDoctors();
            } catch (error) {
              Alert.alert('Lỗi', error.message);
            } finally {
              setLoading(false);
            }
          },
        },
      ]
    );
  };

  const renderDoctor = ({ item }) => {
    const profile = item.user_profiles;
    const dept = item.departments;

    return (
      <View style={styles.card}>
        <View style={styles.avatarContainer}>
          {profile?.avatar_url ? (
            <Image source={{ uri: profile.avatar_url }} style={styles.avatar} />
          ) : (
            <View style={styles.avatarPlaceholder}>
              <Ionicons name="person" size={28} color="#aaa" />
            </View>
          )}
        </View>

        <View style={styles.infoContainer}>
          <Text style={styles.name} numberOfLines={1}>
            {profile?.full_name || 'Chưa có tên'}
          </Text>
          <Text style={styles.email} numberOfLines={1}>
            {profile?.email || 'Không có email'}
          </Text>

          <View style={styles.row}>
            <Text style={styles.label}>Khoa:</Text>
            <Text style={styles.value}>{dept?.name || 'Chưa gán'}</Text>
          </View>

          <View style={styles.row}>
            <Text style={styles.label}>KN:</Text>
            <Text style={styles.value}>{item.experience_years || 0} năm</Text>
            {item.room_number && (
              <>
                <Text style={styles.separator}>|</Text>
                <Text style={styles.label}>Phòng:</Text>
                <Text style={styles.value}>{item.room_number}</Text>
              </>
            )}
          </View>

          {item.specialization && (
            <Text style={styles.specialization} numberOfLines={1}>
              Chuyên: {item.specialization}
            </Text>
          )}
        </View>

        <TouchableOpacity
          style={styles.deleteBtn}
          onPress={() => handleDelete(item.id, profile?.full_name)}
        >
          <MaterialIcons name="delete-forever" size={22} color="#fff" />
        </TouchableOpacity>
      </View>
    );
  };

  const renderSkeleton = () => (
    <View style={styles.card}>
      <View style={styles.avatarPlaceholder} />
      <View style={styles.infoContainer}>
        <View style={styles.skeletonLine} />
        <View style={[styles.skeletonLine, { width: '70%', marginTop: 6 }]} />
        <View style={[styles.skeletonLine, { width: '50%', marginTop: 12 }]} />
      </View>
    </View>
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Quản Lý Bác Sĩ</Text>
        <TouchableOpacity
          style={styles.addButton}
          onPress={() => navigation.navigate('Tạo bác sĩ')}
        >
          <Ionicons name="add" size={24} color="#fff" />
          <Text style={styles.addButtonText}>Thêm</Text>
        </TouchableOpacity>
      </View>

      {loading && doctors.length === 0 ? (
        <View style={{ paddingHorizontal: 16 }}>
          {[...Array(3)].map((_, i) => (
            <View key={i}>{renderSkeleton()}</View>
          ))}
        </View>
      ) : doctors.length === 0 ? (
        <View style={styles.emptyContainer}>
          <Ionicons name="medkit-outline" size={60} color="#ddd" />
          <Text style={styles.emptyText}>Chưa có bác sĩ nào</Text>
          <TouchableOpacity
            style={styles.emptyButton}
            onPress={() => navigation.navigate('Tạo bác sĩ')}
          >
            <Text style={styles.emptyButtonText}>Tạo bác sĩ đầu tiên</Text>
          </TouchableOpacity>
        </View>
      ) : (
        <FlatList
          data={doctors}
          keyExtractor={(item) => item.id.toString()}
          renderItem={renderDoctor}
          contentContainerStyle={styles.listContent}
          refreshControl={
            <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
          }
          showsVerticalScrollIndicator={false}
        />
      )}
    </View>
  );
}
