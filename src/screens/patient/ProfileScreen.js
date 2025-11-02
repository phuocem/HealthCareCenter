// src/screens/patient/ProfileScreen.js
import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  ActivityIndicator,
  TouchableOpacity,
  Alert,
  StyleSheet,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import Animated, { FadeInUp } from 'react-native-reanimated';
import { useNavigation } from '@react-navigation/native';

// API
import { supabase } from '../../api/supabase';
import { getUserProfile } from '../../controllers/patient/userController';

// Utils
import { formatDate, formatGender, formatRole } from '../../utils/formatters';
import { Colors } from '../../shared/colors';

// === CHỮ CÁI ĐẦU TÊN CHO AVATAR ===
const getInitials = (name) => {
  if (!name) return '?';
  return name
    .split(' ')
    .map(word => word[0])
    .join('')
    .toUpperCase()
    .slice(0, 2);
};

export default function ProfileScreen() {
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const navigation = useNavigation();

  const fetchProfile = async () => {
    try {
      setLoading(true);
      const { data: { user }, error: authError } = await supabase.auth.getUser();
      if (authError) throw authError;
      if (!user) throw new Error('Không tìm thấy người dùng.');

      const profileData = await getUserProfile(user.id);
      setProfile({ ...profileData, email: user.email });
    } catch (error) {
      console.error('Lỗi khi tải hồ sơ:', error);
      Alert.alert('Lỗi', error.message || 'Không thể tải hồ sơ.', [
        { text: 'Thử lại', onPress: fetchProfile },
        { text: 'OK', style: 'cancel' },
      ]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProfile();
  }, []);

  if (loading) {
    return (
      <View style={styles.center}>
        <ActivityIndicator size="large" color={Colors.primary} />
        <Text style={styles.loadingText}>Đang tải hồ sơ...</Text>
      </View>
    );
  }

  if (!profile) {
    return (
      <View style={styles.center}>
        <Text style={styles.errorText}>Không tìm thấy hồ sơ.</Text>
        <TouchableOpacity style={styles.retryButton} onPress={fetchProfile}>
          <Text style={styles.retryButtonText}>Thử lại</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <LinearGradient colors={[Colors.primary, Colors.secondary]} style={styles.container}>
      <Animated.View entering={FadeInUp.duration(600)} style={styles.card}>
        {/* AVATAR + TÊN */}
        <View style={styles.header}>
          <View style={styles.avatar}>
            <Text style={styles.avatarText}>{getInitials(profile.name)}</Text>
          </View>
          <Text style={styles.title}>{profile.name}</Text>
          <Text style={styles.subtitle}>{formatRole(profile.role)}</Text>
        </View>

        {/* THÔNG TIN */}
        <View style={styles.infoContainer}>
          <InfoItem icon="email-outline" label="Email" value={profile.email} />
          {profile.phone && (
            <InfoItem icon="phone-outline" label="Số điện thoại" value={profile.phone} />
          )}
          <InfoItem icon="gender-male-female" label="Giới tính" value={formatGender(profile.gender)} />
          <InfoItem icon="calendar-outline" label="Ngày sinh" value={formatDate(profile.date_of_birth)} />
          <InfoItem icon="shield-account" label="Vai trò" value={formatRole(profile.role)} />
        </View>

        {/* NÚT CHỈNH SỬA */}
        <TouchableOpacity
          style={styles.editButton}
          onPress={() => navigation.navigate('EditProfile')}
        >
          <LinearGradient
            colors={[Colors.primary, Colors.secondary]}
            start={{ x: 0, y: 0 }}
            end={{ x: 1, y: 1 }}
            style={styles.editButtonGradient}
          >
            <MaterialCommunityIcons name="pencil" size={20} color="#FFF" />
            <Text style={styles.editButtonText}>Chỉnh sửa hồ sơ</Text>
          </LinearGradient>
        </TouchableOpacity>
      </Animated.View>
    </LinearGradient>
  );
}

// === COMPONENT INFO ITEM ===
const InfoItem = ({ icon, label, value }) => (
  <Animated.View entering={FadeInUp.delay(100).duration(400)} style={styles.infoItem}>
    <MaterialCommunityIcons name={icon} size={24} color={Colors.grayDark} style={styles.infoIcon} />
    <View>
      <Text style={styles.label}>{label}:</Text>
      <Text style={styles.value}>{value || '—'}</Text>
    </View>
  </Animated.View>
);

// === STYLES CAO CẤP ===
const styles = StyleSheet.create({
  container: { flex: 1 },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: '#fff' },
  loadingText: { marginTop: 16, fontSize: 16, color: Colors.textSecondary },
  errorText: { fontSize: 16, color: '#DC2626', textAlign: 'center', marginBottom: 16 },
  retryButton: {
    backgroundColor: Colors.primary,
    paddingHorizontal: 24,
    paddingVertical: 12,
    borderRadius: 12,
  },
  retryButtonText: { color: '#FFF', fontWeight: '600' },

  card: {
    margin: 24,
    backgroundColor: '#FFF',
    borderRadius: 24,
    padding: 28,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 12 },
    shadowOpacity: 0.18,
    shadowRadius: 24,
    elevation: 20,
  },

  // Header
  header: { alignItems: 'center', marginBottom: 32 },
  avatar: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: Colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 16,
    borderWidth: 4,
    borderColor: '#FFF',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 8,
  },
  avatarText: { fontSize: 36, fontWeight: '900', color: '#FFF' },
  title: { fontSize: 26, fontWeight: '800', color: '#1F2937' },
  subtitle: { fontSize: 16, color: Colors.textSecondary, marginTop: 4, fontWeight: '600' },

  // Info
  infoContainer: { marginBottom: 28 },
  infoItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 14,
    borderBottomWidth: 1,
    borderBottomColor: '#F3F4F6',
  },
  infoIcon: { marginRight: 16, width: 28 },
  label: { fontSize: 14, color: Colors.textSecondary, fontWeight: '600' },
  value: { fontSize: 16, color: '#1F2937', fontWeight: '600', marginTop: 2 },

  // Button
  editButton: { borderRadius: 16, overflow: 'hidden' },
  editButtonGradient: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 16,
    paddingHorizontal: 24,
  },
  editButtonText: { color: '#FFF', fontSize: 16, fontWeight: '700', marginLeft: 8 },
});