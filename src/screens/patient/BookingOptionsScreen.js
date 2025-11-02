// src/screens/patient/Book_appointment/BookingOptionsScreen.js
import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  Platform,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import { LinearGradient } from 'expo-linear-gradient';

export default function BookingOptionsScreen() {
  const navigation = useNavigation();

  const options = [
    {
      title: 'Theo Bác sĩ',
      subtitle: 'Chọn bác sĩ bạn tin tưởng',
      icon: 'person-outline',
      screen: 'BookByDoctor',
      gradient: ['#7C3AED', '#A78BFA'],
      badge: 'PHỔ BIẾN',
      badgeBg: '#FEF3C7',
      badgeText: '#92400E',
    },
    {
      title: 'Theo Ngày',
      subtitle: 'Chọn ngày và khung giờ',
      icon: 'calendar-outline',
      screen: 'BookByDate',
      gradient: ['#059669', '#34D399'],
    },
  ];

  const OptionCard = ({ item }) => (
    <TouchableOpacity
      style={styles.card}
      onPress={() => navigation.navigate(item.screen)}
      activeOpacity={0.92}
    >
      <LinearGradient
        colors={item.gradient}
        start={{ x: 0, y: 0 }}
        end={{ x: 1, y: 1 }}
        style={styles.gradient}
      >
        {/* Icon tròn với hiệu ứng kính mờ */}
        <View style={styles.iconWrapper}>
          <View style={styles.iconInner}>
            <Ionicons name={item.icon} size={34} color="#FFF" />
          </View>
        </View>

        {/* Text */}
        <View style={styles.textContainer}>
          <Text style={styles.title}>{item.title}</Text>
          <Text style={styles.subtitle}>{item.subtitle}</Text>
        </View>

        {/* Right: Badge + X */}
        <View style={styles.right}>
          {item.badge && (
            <View style={[styles.badge, { backgroundColor: item.badgeBg }]}>
              <Text style={[styles.badgeText, { color: item.badgeText }]}>
                {item.badge}
              </Text>
            </View>
          )}
          <View style={styles.closeBtn}>
            <Text style={styles.closeText}>×</Text>
          </View>
        </View>
      </LinearGradient>
    </TouchableOpacity>
  );

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Đặt Khám</Text>
        <Text style={styles.headerSubtitle}>Chọn cách bạn muốn đặt lịch</Text>
      </View>

      {/* Cards */}
      {options.map((item, i) => (
        <OptionCard key={i} item={item} />
      ))}

      {/* Note */}
      <View style={styles.note}>
        <View style={styles.shield}>
          <Ionicons name="shield-checkmark" size={22} color="#10B981" />
        </View>
        <Text style={styles.noteText}>Thông tin được bảo mật 100%</Text>
      </View>
    </ScrollView>
  );
}

// === STYLES – ĐẸP HƠN ẢNH 200% ===
const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#FAFAFA' },
  content: { paddingHorizontal: 24, paddingTop: 28, paddingBottom: 60 },

  // Header
  header: { alignItems: 'center', marginBottom: 36 },
  headerTitle: {
    fontSize: 34,
    fontWeight: '900',
    color: '#1F2937',
    letterSpacing: -0.8,
  },
  headerSubtitle: {
    fontSize: 16,
    color: '#6B7280',
    marginTop: 8,
    fontWeight: '500',
  },

  // Card
  card: {
    marginBottom: 22,
    borderRadius: 28,
    overflow: 'hidden',
    elevation: 20,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 12 },
    shadowOpacity: 0.18,
    shadowRadius: 28,
  },
  gradient: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 26,
    minHeight: 120,
  },

  // Icon
  iconWrapper: {
    marginRight: 22,
  },
  iconInner: {
    width: 72,
    height: 72,
    borderRadius: 36,
    backgroundColor: 'rgba(255,255,255,0.35)',
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 1.5,
    borderColor: 'rgba(255,255,255,0.4)',
  },

  // Text
  textContainer: { flex: 1 },
  title: {
    fontSize: 21,
    fontWeight: '900',
    color: '#FFFFFF',
    letterSpacing: -0.3,
  },
  subtitle: {
    fontSize: 14.5,
    color: 'rgba(255,255,255,0.92)',
    marginTop: 5,
    fontWeight: '600',
  },

  // Right Section
  right: { alignItems: 'flex-end' },
  badge: {
    paddingHorizontal: 14,
    paddingVertical: 7,
    borderRadius: 20,
    marginBottom: 10,
    borderWidth: 1.2,
    borderColor: '#F59E0B',
  },
  badgeText: {
    fontSize: 11,
    fontWeight: '900',
    letterSpacing: 0.5,
  },
  closeBtn: {
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: 'rgba(255,255,255,0.28)',
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.3)',
  },
  closeText: {
    fontSize: 24,
    color: '#FFF',
    fontWeight: '300',
    marginTop: -2,
  },

  // Note
  note: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#F0FDF4',
    padding: 18,
    borderRadius: 24,
    marginTop: 20,
    borderWidth: 1.2,
    borderColor: '#D1FAE5',
  },
  shield: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: '#D1FAE5',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 16,
  },
  noteText: {
    fontSize: 15,
    color: '#065F46',
    fontWeight: '700',
  },
});