import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import styles from '../../../../styles/patient/bookbydate/BookbydateStyles';

export default function MyScreen() {
  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity style={styles.backButton}>
          <Text>{"<"}</Text>
        </TouchableOpacity>

        <Text style={styles.title}>Header Title</Text>
      </View>

      <View style={styles.calendarContainer}>
        <Text>Calendar content...</Text>
      </View>

      <Text style={styles.note}>
        Ghi chú ở đây...
      </Text>
    </View>
  );
}
