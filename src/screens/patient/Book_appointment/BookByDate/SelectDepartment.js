// src/screens/patient/Book_appointment/BookByDate/SelectDepartment.js
import React, { useState, useEffect, useMemo, useCallback } from 'react';
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
import { useNavigation, useRoute, useFocusEffect } from '@react-navigation/native';
import { supabase } from '../../../../api/supabase';

export default function SelectDepartment() {
  const navigation = useNavigation();
  const route = useRoute();
  const { date } = route.params;

  const [departments, setDepartments] = useState([]);
  const [filtered, setFiltered] = useState([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);

  // === CHUYỂN NGÀY → THỨ (TIẾNG VIỆT, ĐÃ TRIM) ===
  const getVietnameseDay = (dateStr) => {
    const date = new Date(dateStr);
    const dayNames = ['Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
    return dayNames[date.getDay()].trim();
  };

  // === LẤY KHOA CÓ BÁC SĨ LÀM VIỆC NGÀY ĐÓ ===
  const fetchDepartments = useCallback(async () => {
    setLoading(true);
    try {
      const targetDay = getVietnameseDay(date);

      const { data, error } = await supabase
        .from('departments')
        .select(`
          id,
          name,
          description,
          services!services_department_id_fkey (price),
          doctors!doctors_department_id_fkey!inner (
            id,
            name,
            room_number,
            specialization,
            experience_years,
            doctor_schedule_template!doctor_schedule_template_doctor_id_fkey!inner (
              day_of_week,
              start_time,
              end_time
            )
          )
        `)
        .order('name', { ascending: true });

      if (error) throw error;

      const validDepts = data
        .map(dept => {
          const validDoctors = (dept.doctors || []).filter(doctor =>
            (doctor.doctor_schedule_template || []).some(t =>
              t.day_of_week?.trim() === targetDay &&
              t.end_time > t.start_time
            )
          );

          const servicePrice = dept.services?.[0]?.price ?? 150000;

          return {
            ...dept,
            doctors: validDoctors,
            price: servicePrice,
          };
        })
        .filter(dept => dept.doctors.length > 0);

      setDepartments(validDepts);
    } catch (err) {
      console.error('Lỗi lấy khoa:', err);
      Alert.alert('Lỗi', 'Không thể tải danh sách chuyên khoa.');
    } finally {
      setLoading(false);
    }
  }, [date]);

  useFocusEffect(
    useCallback(() => {
      fetchDepartments();
    }, [fetchDepartments])
  );

  // === TÌM KIẾM ===
  const filteredDepartments = useMemo(() => {
    if (!search.trim()) return departments;
    const lower = search.toLowerCase();
    return departments.filter(d =>
      d.name.toLowerCase().includes(lower) ||
      (d.description && d.description.toLowerCase().includes(lower))
    );
  }, [search, departments]);

  useEffect(() => {
    setFiltered(filteredDepartments);
  }, [filteredDepartments]);

  // === RENDER ITEM ===
  const renderItem = useCallback(({ item }) => {
    const hasNote = item.description && item.description.includes('Chỉ nhận');
    const price = item.price || 150000;

    return (
      <TouchableOpacity
        style={styles.item}
        onPress={() =>
          navigation.navigate('SelectTimeSlot', {
            date,
            department: item,
            templates: item.doctors.flatMap(d =>
              (d.doctor_schedule_template || []).map(t => ({
                ...t,
                doctor_id: d.id,
                doctors: {
                  id: d.id,
                  name: d.name || 'Bác sĩ', // ← BẢO VỆ
                  room_number: d.room_number,
                  specialization: d.specialization,
                  experience_years: d.experience_years,
                },
                max_patients_per_slot: 5
              }))
            )
          })
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
          <Text style={styles.price}>{price.toLocaleString('vi-VN')}đ</Text>
          <Ionicons name="chevron-forward" size={20} color="#9CA3AF" />
        </View>
      </TouchableOpacity>
    );
  }, [date, navigation]);

  const keyExtractor = useCallback(item => item.id.toString(), []);

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Ionicons name="arrow-back" size={24} color="#1F2937" />
        </TouchableOpacity>
        <Text style={styles.title}>Chọn chuyên khoa</Text>
      </View>

      <View style={styles.searchContainer}>
        <Ionicons name="search" size={20} color="#9CA3AF" />
        <TextInput
          placeholder="Tìm nhanh chuyên khoa"
          style={styles.searchInput}
          value={search}
          onChangeText={setSearch}
          autoCapitalize="none"
        />
      </View>

      <Text style={styles.hint}>Nhấn vào để chọn khung giờ</Text>

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
              : 'Không có chuyên khoa nào làm việc ngày này'}
          </Text>
        </View>
      ) : (
        <FlatList
          data={filtered}
          keyExtractor={keyExtractor}
          renderItem={renderItem}
          showsVerticalScrollIndicator={false}
          initialNumToRender={10}
          maxToRenderPerBatch={10}
          windowSize={10}
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
    marginHorizontal: 16,
    marginTop: 8,
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