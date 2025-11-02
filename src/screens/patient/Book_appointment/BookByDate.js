import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, FlatList } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
// Giả định thư viện này đã được cài đặt: npm install react-native-calendars
import { Calendar } from 'react-native-calendars'; 

const TIME_SLOTS = [
  '08:00', '09:00', '10:00', '11:00',
  '13:00', '14:00', '15:00', '16:00',
];

export default function BookByDate() {
  const navigation = useNavigation();
  const [selectedDate, setSelectedDate] = useState('');
  const [selectedTime, setSelectedTime] = useState(null);

  const handleDayPress = (day) => {
    setSelectedDate(day.dateString);
    setSelectedTime(null); // Reset giờ khi chọn ngày mới
  };

  const isTimeSlotAvailable = (time) => {
    // Logic giả lập: Giờ 14:00 luôn bận vào ngày 2025-11-05
    if (selectedDate === '2025-11-05' && time === '14:00') {
      return false;
    }
    return true;
  };

  const handleBooking = () => {
    if (selectedDate && selectedTime) {
      // Logic điều hướng đến màn hình xác nhận/thanh toán
      console.log(`Đặt lịch: ${selectedTime} ngày ${selectedDate}`);
      // navigation.navigate('AppointmentSummaryScreen', { date: selectedDate, time: selectedTime });
    } else {
      // Hiển thị thông báo lỗi
      alert('Vui lòng chọn ngày và giờ khám.');
    }
  };

  const TimeSlot = ({ time }) => {
    const isBusy = !isTimeSlotAvailable(time);
    const isSelected = selectedTime === time;

    const slotStyle = [
      styles.timeSlot,
      isSelected && styles.timeSlotSelected,
      isBusy && styles.timeSlotBusy,
    ];

    const textStyle = [
      styles.timeSlotText,
      isSelected && styles.timeSlotTextSelected,
      isBusy && styles.timeSlotTextBusy,
    ];

    return (
      <TouchableOpacity 
        style={slotStyle} 
        onPress={() => !isBusy && setSelectedTime(time)}
        disabled={isBusy}
      >
        <Text style={textStyle}>{time}</Text>
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#1F2937" />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Chọn Ngày Khám</Text>
      </View>
      
      <ScrollView style={styles.scrollContent}>
        
        {/* Calendar Picker */}
        <View style={styles.calendarContainer}>
          <Text style={styles.sectionTitle}>1. Chọn Ngày</Text>
          <Calendar
            onDayPress={handleDayPress}
            markedDates={{
              [selectedDate]: { selected: true, selectedColor: '#059669', dotColor: '#fff' }
            }}
            theme={{
              todayTextColor: '#10B981',
              selectedDayBackgroundColor: '#059669',
              selectedDayTextColor: '#ffffff',
              arrowColor: '#4B5563',
              textMonthFontWeight: '800',
              textDayHeaderFontWeight: '700',
              textMonthFontSize: 18,
            }}
          />
        </View>

        {/* Time Slot Picker */}
        <View style={styles.timeSlotPicker}>
          <Text style={styles.sectionTitle}>2. Chọn Giờ Khám</Text>
          
          {!selectedDate ? (
            <View style={styles.emptyState}>
              <Ionicons name="calendar-sharp" size={40} color="#9CA3AF" />
              <Text style={styles.emptyText}>Vui lòng chọn một ngày trên lịch để xem giờ trống.</Text>
            </View>
          ) : (
            <>
              <Text style={styles.selectedInfo}>
                Ngày đã chọn: <Text style={{fontWeight: '700', color: '#1F2937'}}>{selectedDate}</Text>
              </Text>
              <View style={styles.slotsGrid}>
                {TIME_SLOTS.map(time => (
                  <TimeSlot key={time} time={time} />
                ))}
              </View>
            </>
          )}
        </View>
      </ScrollView>

      {/* Footer Booking Button */}
      <View style={styles.footer}>
        <TouchableOpacity 
          style={[styles.bookButton, (!selectedDate || !selectedTime) && styles.bookButtonDisabled]} 
          onPress={handleBooking}
          disabled={!selectedDate || !selectedTime}
        >
          <Text style={styles.bookButtonText}>
            Xác Nhận Đặt Lịch
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#F9FAFB' },
  scrollContent: { paddingHorizontal: 20, paddingBottom: 100 },
  
  // Header styles (Giữ nguyên)
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    paddingTop: 50,
    backgroundColor: '#FFFFFF',
    borderBottomWidth: 1,
    borderBottomColor: '#E5E7EB',
  },
  backButton: { marginRight: 10 },
  headerTitle: { fontSize: 20, fontWeight: '700', color: '#1F2937' },
  
  // Calendar Section
  calendarContainer: {
    backgroundColor: '#FFFFFF',
    borderRadius: 16,
    marginTop: 20,
    padding: 10,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.05,
    shadowRadius: 5,
    elevation: 3,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '800',
    color: '#1F2937',
    marginBottom: 10,
    paddingHorizontal: 10,
  },

  // Time Slot Picker
  timeSlotPicker: {
    marginTop: 30,
    backgroundColor: '#FFFFFF',
    padding: 15,
    borderRadius: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.05,
    shadowRadius: 5,
    elevation: 3,
  },
  selectedInfo: {
    fontSize: 14,
    color: '#6B7280',
    marginBottom: 15,
    paddingHorizontal: 5,
  },
  slotsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'flex-start',
  },
  timeSlot: {
    paddingVertical: 10,
    paddingHorizontal: 15,
    borderRadius: 8,
    borderWidth: 1.5,
    borderColor: '#E5E7EB',
    margin: 5,
  },
  timeSlotText: {
    fontWeight: '600',
    color: '#374151',
    fontSize: 15,
  },
  timeSlotSelected: {
    backgroundColor: '#059669',
    borderColor: '#059669',
  },
  timeSlotTextSelected: {
    color: '#FFFFFF',
  },
  timeSlotBusy: {
    backgroundColor: '#F3F4F6',
    borderColor: '#D1D5DB',
    opacity: 0.6,
  },
  timeSlotTextBusy: {
    color: '#9CA3AF',
    textDecorationLine: 'line-through',
  },

  // Empty State
  emptyState: {
    alignItems: 'center',
    paddingVertical: 30,
  },
  emptyText: {
    marginTop: 10,
    fontSize: 14,
    color: '#9CA3AF',
    textAlign: 'center',
    maxWidth: 250,
  },

  // Footer Button
  footer: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    padding: 20,
    backgroundColor: '#FFFFFF',
    borderTopWidth: 1,
    borderTopColor: '#E5E7EB',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: -2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 5,
  },
  bookButton: {
    backgroundColor: '#059669',
    paddingVertical: 16,
    borderRadius: 12,
    alignItems: 'center',
  },
  bookButtonDisabled: {
    backgroundColor: '#9CA3AF',
  },
  bookButtonText: {
    color: '#FFFFFF',
    fontSize: 18,
    fontWeight: '800',
  }
});
