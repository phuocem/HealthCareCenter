import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export default function AppointmentScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Lịch khám</Text>
      <Text style={styles.subtitle}>Danh sách lịch khám của bạn sẽ hiển thị tại đây.</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: '#fff' },
  title: { fontSize: 20, fontWeight: 'bold', marginBottom: 10 },
  subtitle: { fontSize: 16, color: '#555' },
});
