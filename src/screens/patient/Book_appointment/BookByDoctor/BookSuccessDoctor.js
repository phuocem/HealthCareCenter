// src/screens/patient/BookByDoctor/BookSuccessDoctor.js
import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import Animated, { ZoomIn } from 'react-native-reanimated';

const Colors = { primary: '#1D4ED8', success: '#10B981', bg: '#F8FAFC' };

export default function BookSuccessDoctor() {
  const navigation = useNavigation();

  return (
    <View style={styles.container}>
      <Animated.View entering={ZoomIn.duration(600)} style={styles.icon}>
        <Ionicons name="checkmark-circle" size={100} color={Colors.success} />
      </Animated.View>
      <Text style={styles.title}>Đặt lịch thành công!</Text>
      <Text style={styles.subtitle}>Bạn đã đặt lịch khám với bác sĩ</Text>
      <TouchableOpacity style={styles.btn} onPress={() => navigation.navigate('History')}>
        <Text style={styles.btnText}>Xem lịch sử</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={() => navigation.navigate('Home')}>
        <Text style={styles.home}>Về trang chủ</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.bg, justifyContent: 'center', alignItems: 'center', padding: 32 },
  icon: { marginBottom: 24 },
  title: { fontSize: 24, fontWeight: '800', color: '#1E293B', marginBottom: 8 },
  subtitle: { fontSize: 16, color: '#6B7280', textAlign: 'center', marginBottom: 32 },
  btn: { backgroundColor: Colors.primary, paddingHorizontal: 32, paddingVertical: 14, borderRadius: 12, marginBottom: 16 },
  btnText: { color: '#FFF', fontWeight: '700' },
  home: { color: Colors.primary, fontWeight: '600' },
});