import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Colors } from '../../shared/colors';

export default function CreateUserScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Tạo tài khoản mới</Text>
      <Text style={styles.subtitle}>Dành cho admin tạo tài khoản bác sĩ hoặc người dùng.</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  title: {
    fontSize: 22,
    color: Colors.text,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  subtitle: {
    color: Colors.textSecondary,
    textAlign: 'center',
  },
});
