// src/screens/patient/Book_appointment/BookByDoctor/BookByDoctor.js
import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  FlatList,
  TextInput,
  ActivityIndicator,
  Image,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import { supabase } from '../../../../api/supabase';

const Colors = {
  primary: '#1D4ED8',
  secondary: '#38BDF8',
  textPrimary: '#1E293B',
  textSecondary: '#4B5563',
  bg: '#F8FAFC',
  success: '#10B981',
  warning: '#F59E0B',
};

export default function BookByDoctor() {
  const navigation = useNavigation();
  const [query, setQuery] = useState('');
  const [doctors, setDoctors] = useState([]);
  const [loading, setLoading] = useState(false);

  // TÌM KIẾM BÁC SĨ - SỬA LỖI ORDER
  const searchDoctors = async (text) => {
    const keyword = text.trim();
    setQuery(keyword);

    if (!keyword) {
      setDoctors([]);
      return;
    }

    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('doctors')
        .select(`
          id,
          specialization,
          room_number,
          experience_years,
          department_id,
          departments!inner(name),
          user_profiles!inner(
            full_name,
            gender,
            avatar_url
          ),
          doctor_schedule_template (
            day_of_week,
            start_time,
            end_time
          )
        `)
        .ilike('user_profiles.full_name', `%${keyword}%`)
        .order('full_name', { foreignTable: 'user_profiles', ascending: true }); // SỬA: DÙNG foreignTable

      if (error) throw error;

      // GỘP BUỔI KHÁM THEO BÁC SĨ
      const grouped = {};
      data.forEach(doc => {
        const id = doc.id;
        if (!grouped[id]) {
          grouped[id] = {
            id: doc.id,
            user_profiles: doc.user_profiles,
            departments: doc.departments,
            specialization: doc.specialization,
            room_number: doc.room_number,
            experience_years: doc.experience_years,
            schedules: [],
          };
        }

        // Xử lý từng lịch (có thể nhiều)
        const templates = Array.isArray(doc.doctor_schedule_template)
          ? doc.doctor_schedule_template
          : [doc.doctor_schedule_template].filter(Boolean);

        templates.forEach(t => {
          if (t && t.start_time && t.end_time && t.end_time > t.start_time) {
            const start = t.start_time.slice(0, 5);
            const session = start < '12:00' ? 'Sáng' : 'Chiều';
            const dayText = `${session} ${t.day_of_week}`;

            if (!grouped[id].schedules.includes(dayText)) {
              grouped[id].schedules.push(dayText);
            }
          }
        });
      });

      setDoctors(Object.values(grouped));
    } catch (err) {
      console.error('Lỗi tìm bác sĩ:', err);
      setDoctors([]);
    } finally {
      setLoading(false);
    }
  };

  // HIỂN THỊ BÁC SĨ
  const renderDoctor = ({ item }) => {
    const profile = item.user_profiles;
    const dept = item.departments;
    const hasAvatar = profile.avatar_url;

    return (
      <View style={styles.doctorCard}>
        {/* AVATAR + TÊN */}
        <View style={styles.header}>
          {hasAvatar ? (
            <Image source={{ uri: profile.avatar_url }} style={styles.avatar} />
          ) : (
            <View style={styles.avatarFallback}>
              <Text style={styles.avatarText}>
                {profile.full_name?.charAt(0).toUpperCase() || 'B'}
              </Text>
            </View>
          )}
          <View style={styles.info}>
            <Text style={styles.name}>{profile.full_name || 'Bác sĩ'}</Text>
            <Text style={styles.gender}>
              Giới tính {profile.gender === 'male' ? 'Nam' : 'Nữ'}
            </Text>
          </View>
        </View>

        <View style={styles.divider} />

        {/* CHI TIẾT */}
        <View style={styles.details}>
          <View style={styles.row}>
            <Text style={styles.label}>Chuyên khoa</Text>
            <Text style={styles.value}>{dept.name || 'Chưa có'}</Text>
            <TouchableOpacity style={styles.infoIcon}>
              <Ionicons name="information-circle" size={18} color={Colors.primary} />
            </TouchableOpacity>
          </View>

          <View style={styles.row}>
            <Text style={styles.label}>Giá khám</Text>
            <Text style={styles.price}>150.000đ</Text>
          </View>

          <View style={styles.row}>
            <Text style={styles.label}>Buổi khám</Text>
            <View style={styles.sessions}>
              {item.schedules.length > 0 ? (
                item.schedules.map((s, i) => (
                  <Text key={i} style={styles.session}>
                    {s}
                  </Text>
                ))
              ) : (
                <Text style={styles.noSession}>Chưa có lịch</Text>
              )}
            </View>
          </View>
        </View>

        {/* NÚT CHỌN */}
        <TouchableOpacity
          style={styles.selectButton}
          onPress={() =>
            navigation.navigate('SelectTimeSlot', {
              doctorId: item.id,
              doctor: {
                id: item.id,
                name: profile.full_name,
                room_number: item.room_number,
                specialization: item.specialization,
                avatar_url: profile.avatar_url,
              },
            })
          }
        >
          <Text style={styles.selectButtonText}>Chọn</Text>
        </TouchableOpacity>
      </View>
    );
  };

  return (
    <View style={styles.container}>
      {/* HEADER */}
      <View style={styles.headerBar}>
        <TouchableOpacity onPress={() => navigation.goBack()} style={styles.backBtn}>
          <Ionicons name="arrow-back" size={24} color={Colors.textPrimary} />
        </TouchableOpacity>
        <Text style={styles.title}>Chọn bác sĩ</Text>
        <TouchableOpacity>
          <Ionicons name="home-outline" size={24} color={Colors.primary} />
        </TouchableOpacity>
      </View>

      {/* SEARCH */}
      <View style={styles.searchContainer}>
        <Ionicons name="search" size={20} color="#9CA3AF" style={styles.searchIcon} />
        <TextInput
          placeholder="Tìm kiếm bác sĩ..."
          value={query}
          onChangeText={searchDoctors}
          style={styles.searchInput}
        />
      </View>

      {/* FILTERS */}
      <View style={styles.filters}>
        <TouchableOpacity style={styles.filterBtn}>
          <Text style={styles.filterText}>Chọn chuyên khoa</Text>
          <Ionicons name="chevron-down" size={16} color="#6B7280" />
        </TouchableOpacity>
        <TouchableOpacity style={styles.filterBtn}>
          <Text style={styles.filterText}>Chọn thứ</Text>
          <Ionicons name="chevron-down" size={16} color="#6B7280" />
        </TouchableOpacity>
        <TouchableOpacity style={styles.filterBtn}>
          <Text style={styles.filterText}>Chọn giờ</Text>
          <Ionicons name="chevron-down" size={16} color="#6B7280" />
        </TouchableOpacity>
      </View>

      {/* HINT */}
      <View style={styles.hint}>
        <Ionicons name="information-circle" size={16} color={Colors.primary} />
        <Text style={styles.hintText}>Nhấn vào để xem chức năng chuyên khoa</Text>
      </View>

      {/* LIST */}
      {loading ? (
        <View style={styles.center}>
          <ActivityIndicator size="large" color={Colors.primary} />
        </View>
      ) : (
        <FlatList
          data={doctors}
          keyExtractor={(item) => item.id}
          renderItem={renderDoctor}
          contentContainerStyle={styles.list}
          showsVerticalScrollIndicator={false}
          ListEmptyComponent={
            <View style={styles.empty}>
              <Ionicons name="search-outline" size={48} color="#9CA3AF" />
              <Text style={styles.emptyText}>
                {query ? 'Không tìm thấy bác sĩ nào.' : 'Nhập tên để tìm kiếm.'}
              </Text>
            </View>
          }
        />
      )}
    </View>
  );
}

// === STYLES ===
const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#F9FAFB' },
  headerBar: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingTop: 50,
    paddingHorizontal: 16,
    paddingBottom: 16,
    backgroundColor: '#fff',
  },
  backBtn: { padding: 4 },
  title: { fontSize: 20, fontWeight: '700', color: Colors.textPrimary },
  searchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#fff',
    marginHorizontal: 16,
    marginTop: 8,
    paddingHorizontal: 12,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#E5E7EB',
  },
  searchIcon: { marginRight: 8 },
  searchInput: { flex: 1, paddingVertical: 12, fontSize: 16 },
  filters: {
    flexDirection: 'row',
    marginHorizontal: 16,
    marginTop: 12,
    gap: 8,
  },
  filterBtn: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: '#fff',
    paddingHorizontal: 12,
    paddingVertical: 10,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#E5E7EB',
  },
  filterText: { fontSize: 14, color: '#4B5563' },
  hint: {
    flexDirection: 'row',
    alignItems: 'center',
    marginHorizontal: 16,
    marginTop: 12,
    padding: 8,
    backgroundColor: '#EFF6FF',
    borderRadius: 8,
  },
  hintText: { marginLeft: 6, fontSize: 13, color: Colors.primary },
  list: { padding: 16, paddingTop: 8 },
  doctorCard: {
    backgroundColor: '#fff',
    borderRadius: 16,
    padding: 16,
    marginBottom: 16,
    elevation: 2,
  },
  header: { flexDirection: 'row', alignItems: 'center' },
  avatar: { width: 64, height: 64, borderRadius: 32, marginRight: 12 },
  avatarFallback: {
    width: 64,
    height: 64,
    borderRadius: 32,
    backgroundColor: Colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  avatarText: { color: '#fff', fontSize: 24, fontWeight: 'bold' },
  info: { flex: 1 },
  name: { fontSize: 17, fontWeight: '700', color: Colors.textPrimary },
  gender: { fontSize: 14, color: '#059669', marginTop: 2 },
  divider: { height: 1, backgroundColor: '#E5E7EB', marginVertical: 12 },
  details: { gap: 12 },
  row: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  label: { fontSize: 14, color: Colors.textSecondary },
  value: { fontSize: 15, color: Colors.textPrimary, fontWeight: '600', flex: 1, textAlign: 'right', marginRight: 8 },
  price: { fontSize: 16, color: '#DC2626', fontWeight: '700' },
  infoIcon: { padding: 4 },
  sessions: { flexDirection: 'row', flexWrap: 'wrap', gap: 8, flex: 1, justifyContent: 'flex-end' },
  session: { fontSize: 14, color: '#16A34A', backgroundColor: '#F0FDF4', paddingHorizontal: 8, paddingVertical: 4, borderRadius: 6 },
  noSession: { fontSize: 14, color: '#9CA3AF', fontStyle: 'italic' },
  selectButton: {
    marginTop: 16,
    backgroundColor: Colors.primary,
    paddingVertical: 12,
    borderRadius: 12,
    alignItems: 'center',
  },
  selectButtonText: { color: '#fff', fontSize: 16, fontWeight: '600' },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  empty: { flex: 1, justifyContent: 'center', alignItems: 'center', paddingTop: 60 },
  emptyText: { marginTop: 16, fontSize: 16, color: '#6B7280', textAlign: 'center' },
});