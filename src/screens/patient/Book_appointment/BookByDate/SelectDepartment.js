// src/screens/patient/Book_appointment/BookByDate/SelectDepartment.js
import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  TextInput,
  ActivityIndicator,
  FlatList,
  Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation, useRoute } from '@react-navigation/native';
import { supabase } from '../../../../api/supabase';

export default function SelectDepartment() {
  const navigation = useNavigation();
  const route = useRoute();
  const { date } = route.params;

  const [departments, setDepartments] = useState([]);
  const [filtered, setFiltered] = useState([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDepartments();
  }, [date]);

  const fetchDepartments = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('departments')
        .select(`
          id,
          name,
          description,
          doctors!doctors_department_id_fkey (
            id,
            name,
            room_number,
            appointment_slots!appointment_slots_doctor_id_fkey (
              id,
              work_date,
              start_time,
              end_time,
              max_patients,
              booked_count
            )
          )
        `)
        .order('name');

      if (error) throw error;

      // LỌC CHỈ DỮ LIỆU CÓ work_date + TRỐNG
      const validDepts = data
        .map(dept => {
          const validDoctors = dept.doctors.filter(doctor =>
            doctor.appointment_slots.some(slot =>
              slot.work_date === date &&
              slot.booked_count < slot.max_patients
            )
          );
          return { ...dept, doctors: validDoctors };
        })
        .filter(dept => dept.doctors.length > 0);

      setDepartments(validDepts);
      setFiltered(validDepts);
    } catch (err) {
      console.error('Lỗi lấy khoa:', err);
      Alert.alert('Lỗi', 'Không thể tải danh sách chuyên khoa.');
    } finally {
      setLoading(false);
    }
  };

  // TÌM KIẾM
  useEffect(() => {
    if (!search.trim()) {
      setFiltered(departments);
    } else {
      const lower = search.toLowerCase();
      setFiltered(
        departments.filter(d =>
          d.name.toLowerCase().includes(lower) ||
          d.description?.toLowerCase().includes(lower)
        )
      );
    }
  }, [search, departments]);

  const renderItem = ({ item }) => {
    const hasNote = item.description && item.description.includes('Chỉ nhận');
    const price = 150000;

    return (
      <TouchableOpacity
        style={styles.item}
        onPress={() =>
          navigation.navigate('SelectTimeSlot', { date, department: item })
        }
      >
        <View style={styles.itemLeft}>
          <View style={styles.iconCircle}>
            <Text style={styles.iconNumber}>1</Text>
          </View>
          <View style={{ flex: 1 }}>
            <Text style={styles.deptName}>{item.name}</Text>
            {hasNote && <Text style={styles.note}>{item.description}</Text>}
          </View>
        </View>
        <View style={styles.itemRight}>
          <Text style={styles.price}>{price.toLocaleString()}đ</Text>
          <Ionicons name="chevron-forward" size={20} color="#9CA3AF" />
        </View>
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      {/* HEADER */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Ionicons name="arrow-back" size={24} color="#1F2937" />
        </TouchableOpacity>
        <Text style={styles.title}>Chọn chuyên khoa</Text>
      </View>

      {/* TÌM KIẾM */}
      <View style={styles.searchContainer}>
        <Ionicons name="search" size={20} color="#9CA3AF" />
        <TextInput
          placeholder="Tìm nhanh chuyên khoa"
          style={styles.searchInput}
          value={search}
          onChangeText={setSearch}
        />
      </View>

      <Text style={styles.hint}>Nhấn vào để xem chức năng chuyên khoa</Text>

      {/* DANH SÁCH */}
      {loading ? (
        <View style={styles.center}>
          <ActivityIndicator size="large" color="#3B82F6" />
          <Text style={styles.loadingText}>Đang tải chuyên khoa...</Text>
        </View>
      ) : filtered.length === 0 ? (
        <View style={styles.center}>
          <Ionicons name="alert-circle-outline" size={48} color="#9CA3AF" />
          <Text style={styles.emptyText}>
            {search 
              ? 'Không tìm thấy chuyên khoa phù hợp' 
              : 'Không có chuyên khoa nào khả dụng ngày này'}
          </Text>
        </View>
      ) : (
        <FlatList
          data={filtered}
          keyExtractor={item => item.id.toString()}
          renderItem={renderItem}
          showsVerticalScrollIndicator={false}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#fff' },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingTop: 50,
    paddingHorizontal: 16,
    paddingBottom: 16,
    backgroundColor: '#fff',
    borderBottomWidth: 1,
    borderBottomColor: '#E5E7EB',
  },
  title: { fontSize: 20, fontWeight: '700', marginLeft: 12, color: '#1F2937' },
  searchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    margin: 16,
    padding: 12,
    backgroundColor: '#F9FAFB',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#E5E7EB',
  },
  searchInput: { flex: 1, marginLeft: 8, fontSize: 16, color: '#1F2937' },
  hint: { marginHorizontal: 16, color: '#FB923C', fontSize: 13, marginBottom: 8 },
  item: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#E5E7EB',
  },
  itemLeft: { flexDirection: 'row', alignItems: 'center', flex: 1 },
  iconCircle: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: '#3B82F6',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  iconNumber: { color: '#fff', fontWeight: '800', fontSize: 14 },
  deptName: { fontWeight: '700', color: '#1F2937', fontSize: 16 },
  note: { fontSize: 12, color: '#6B7280', marginTop: 2 },
  itemRight: { alignItems: 'flex-end' },
  price: { fontWeight: '700', color: '#1F2937', fontSize: 15 },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20 },
  loadingText: { marginTop: 12, color: '#6B7280' },
  emptyText: { marginTop: 12, color: '#6B7280', textAlign: 'center', fontSize: 15 },
});