// src/screens/ProfileScreen.jsx
import React, { useEffect, useState } from 'react';
import { View, Text, ActivityIndicator, TouchableOpacity, Alert } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import Animated, { FadeInUp } from 'react-native-reanimated';
import { useNavigation } from '@react-navigation/native';

import { getUserProfile } from '../../controllers/userController';
import { supabase } from '../../api/supabase';
import { formatDate, formatGender, formatRole } from '../../utils/formatters';
import { profileStyles as styles } from '../../styles/patient/profileStyles';

export default function ProfileScreen() {
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const navigation = useNavigation();

  const fetchProfile = async () => {
    try {
      setLoading(true);

      // 🔹 Lấy user hiện tại từ Supabase Auth
      const { data: { user }, error: authError } = await supabase.auth.getUser();
      if (authError) throw new Error(authError.message);
      if (!user) throw new Error('Không tìm thấy người dùng.');

      // 🔹 Gọi controller
      const profileData = await getUserProfile(user.id);
      setProfile(profileData);

    } catch (error) {
      console.error('❌ Lỗi khi tải hồ sơ người dùng:', error);
      Alert.alert('Lỗi', error.message || 'Không thể tải hồ sơ. Vui lòng thử lại.', [
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
        <ActivityIndicator size="large" color="#007AFF" />
        <Text style={styles.loadingText}>Đang tải hồ sơ...</Text>
      </View>
    );
  }

  if (!profile) {
    return (
      <View style={styles.center}>
        <Text style={styles.errorText}>Không tìm thấy hồ sơ người dùng.</Text>
        <TouchableOpacity style={styles.retryButton} onPress={fetchProfile}>
          <Text style={styles.retryButtonText}>Thử lại</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <LinearGradient colors={['#007AFF', '#00C6FF']} style={styles.container}>
      <Animated.View entering={FadeInUp.duration(600)} style={styles.card}>
        <View style={styles.header}>
          <MaterialCommunityIcons name="account-circle" size={80} color="#007AFF" />
          <Text style={styles.title}>{profile.name}</Text>
          <Text style={styles.subtitle}>{formatRole(profile.role)}</Text>
        </View>

        <View style={styles.infoContainer}>
          <InfoItem icon="email-outline" label="Email" value={profile.email} />
          <InfoItem icon="gender-male-female" label="Giới tính" value={formatGender(profile.gender)} />
          <InfoItem icon="calendar-outline" label="Ngày sinh" value={formatDate(profile.date_of_birth)} />
          <InfoItem icon="account-outline" label="Vai trò" value={formatRole(profile.role)} />
        </View>

        <TouchableOpacity
          style={styles.editButton}
          onPress={() => navigation.navigate('EditProfile')}
        >
          <LinearGradient colors={['#2563EB', '#3B82F6']} style={styles.editButtonGradient}>
            <Text style={styles.editButtonText}>Chỉnh sửa hồ sơ</Text>
          </LinearGradient>
        </TouchableOpacity>
      </Animated.View>
    </LinearGradient>
  );
}

const InfoItem = ({ icon, label, value }) => (
  <Animated.View entering={FadeInUp.delay(100).duration(400)} style={styles.infoItem}>
    <MaterialCommunityIcons name={icon} size={24} color="#6B7280" style={styles.infoIcon} />
    <View>
      <Text style={styles.label}>{label}:</Text>
      <Text style={styles.value}>{value}</Text>
    </View>
  </Animated.View>
);
