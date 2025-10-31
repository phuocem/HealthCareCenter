import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  TextInput,
  Alert,
  ActivityIndicator,
  Platform,
  KeyboardAvoidingView,
  ScrollView,
  Modal,
  Pressable,
  Animated,
} from 'react-native';
import DateTimePicker from '@react-native-community/datetimepicker';
import { useRoute, useNavigation } from '@react-navigation/native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { supabase } from '../../api/supabase';
import { confirmBookingController } from '../../controllers/patient/bookingController';
import { styles } from '../../styles/patient/BookingScreenStyles';

const formatDate = (date) => {
  return date.toLocaleDateString('vi-VN', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
};

const formatTime = (date) => {
  return date.toLocaleTimeString('vi-VN', {
    hour: '2-digit',
    minute: '2-digit',
  });
};

export default function BookingScreen() {
  const route = useRoute();
  const navigation = useNavigation();
  const { doctorId } = route.params;

  // States cơ bản
  const [date, setDate] = useState(new Date());
  const [time, setTime] = useState(new Date());
  const [symptoms, setSymptoms] = useState('');
  const [loading, setLoading] = useState(false);

  // States picker
  const [showDatePicker, setShowDatePicker] = useState(false);
  const [showTimePicker, setShowTimePicker] = useState(false);

  // States dịch vụ
  const [services, setServices] = useState([]);
  const [selectedServiceId, setSelectedServiceId] = useState(null);
  const [showServicePicker, setShowServicePicker] = useState(false);

  // Animation button
  const scaleValue = new Animated.Value(1);

  // Lấy danh sách dịch vụ từ Supabase
  useEffect(() => {
    const fetchServices = async () => {
      const { data, error } = await supabase.from('services').select('*');
      if (!error) setServices(data);
    };
    fetchServices();
  }, []);

  // Xử lý đặt lịch
  const handleBooking = async () => {
    if (!symptoms.trim()) {
      Alert.alert('⚠️ Thiếu thông tin', 'Vui lòng mô tả triệu chứng của bạn.');
      return;
    }
    if (!selectedServiceId) {
      Alert.alert('⚠️ Chưa chọn dịch vụ', 'Vui lòng chọn dịch vụ khám.');
      return;
    }

    setLoading(true);
    try {
      await confirmBookingController(
        doctorId,
        selectedServiceId,
        date,
        time,
        symptoms
      );
      Alert.alert('✅ Đặt lịch thành công!', 'Bác sĩ sẽ sớm xác nhận lịch hẹn.', [
        { text: 'OK', onPress: () => navigation.goBack() },
      ]);
    } catch (err) {
      Alert.alert('❌ Lỗi', err.message || 'Đã xảy ra lỗi khi đặt lịch.');
    } finally {
      setLoading(false);
    }
  };

  const onPressIn = () => {
    Animated.spring(scaleValue, { toValue: 0.95, useNativeDriver: true }).start();
  };
  const onPressOut = () => {
    Animated.spring(scaleValue, { toValue: 1, useNativeDriver: true }).start();
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      style={{ flex: 1, backgroundColor: '#f8f9ff' }}
    >
      <ScrollView contentContainerStyle={{ padding: 20, paddingBottom: 40 }}>
        {/* Header */}
        <View style={{ alignItems: 'center', marginBottom: 32 }}>
          <LinearGradient
            colors={['#28A745', '#39D353']}
            style={{
              width: 80,
              height: 80,
              borderRadius: 40,
              justifyContent: 'center',
              alignItems: 'center',
              marginBottom: 16,
              shadowColor: '#28A745',
              shadowOffset: { width: 0, height: 6 },
              shadowOpacity: 0.3,
              shadowRadius: 12,
              elevation: 10,
            }}
          >
            <MaterialCommunityIcons name="calendar-heart" size={40} color="#fff" />
          </LinearGradient>
          <Text style={{ fontSize: 28, fontWeight: '800', color: '#1a1a1a' }}>
            Đặt lịch khám
          </Text>
          <Text
            style={{ fontSize: 16, color: '#666', marginTop: 6, textAlign: 'center' }}
          >
            Chọn dịch vụ, ngày giờ và mô tả triệu chứng
          </Text>
        </View>

        {/* Chọn dịch vụ */}
        <View style={styles.fieldContainer}>
          <View style={styles.labelContainer}>
            <MaterialCommunityIcons name="stethoscope" size={22} color="#28A745" />
            <Text style={styles.label}>Chọn dịch vụ</Text>
          </View>
          <TouchableOpacity
            onPress={() => setShowServicePicker(true)}
            style={styles.customPicker}
          >
            <Text style={styles.pickerText}>
              {services.find(s => s.id === selectedServiceId)?.name || 'Chọn dịch vụ'}
            </Text>
            <MaterialCommunityIcons name="chevron-down" size={20} color="#888" />
          </TouchableOpacity>
        </View>

        {/* Chọn ngày */}
        <View style={styles.fieldContainer}>
          <View style={styles.labelContainer}>
            <MaterialCommunityIcons name="calendar" size={22} color="#28A745" />
            <Text style={styles.label}>Ngày khám</Text>
          </View>
          <TouchableOpacity
            onPress={() => setShowDatePicker(true)}
            style={styles.customPicker}
          >
            <Text style={styles.pickerText}>{formatDate(date)}</Text>
            <MaterialCommunityIcons name="chevron-down" size={20} color="#888" />
          </TouchableOpacity>
        </View>

        {/* Chọn giờ */}
        <View style={styles.fieldContainer}>
          <View style={styles.labelContainer}>
            <MaterialCommunityIcons name="clock-outline" size={22} color="#28A745" />
            <Text style={styles.label}>Giờ khám</Text>
          </View>
          <TouchableOpacity
            onPress={() => setShowTimePicker(true)}
            style={styles.customPicker}
          >
            <Text style={styles.pickerText}>{formatTime(time)}</Text>
            <MaterialCommunityIcons name="chevron-down" size={20} color="#888" />
          </TouchableOpacity>
        </View>

        {/* Triệu chứng */}
        <View style={styles.fieldContainer}>
          <View style={styles.labelContainer}>
            <MaterialCommunityIcons
              name="file-document-outline"
              size={22}
              color="#28A745"
            />
            <Text style={styles.label}>Triệu chứng / Mô tả</Text>
          </View>
          <TextInput
            value={symptoms}
            onChangeText={setSymptoms}
            placeholder="Mô tả chi tiết tình trạng sức khỏe của bạn..."
            multiline
            numberOfLines={5}
            style={styles.textArea}
            textAlignVertical="top"
          />
          <Text
            style={{ fontSize: 12, color: '#aaa', marginTop: 6, alignSelf: 'flex-end' }}
          >
            {symptoms.length}/500
          </Text>
        </View>

        {/* Button xác nhận */}
        <Animated.View style={{ transform: [{ scale: scaleValue }] }}>
          <TouchableOpacity
            onPressIn={onPressIn}
            onPressOut={onPressOut}
            onPress={handleBooking}
            disabled={loading}
          >
            <LinearGradient
              colors={loading ? ['#aaa', '#ccc'] : ['#28A745', '#39D353']}
              style={[
                styles.confirmButton,
                { flexDirection: 'row', alignItems: 'center', justifyContent: 'center' },
              ]}
            >
              {loading ? (
                <ActivityIndicator color="#fff" size="small" />
              ) : (
                <>
                  <MaterialCommunityIcons name="check-circle" size={22} color="#fff" />
                  <Text style={styles.confirmButtonText}>Xác nhận đặt lịch</Text>
                </>
              )}
            </LinearGradient>
          </TouchableOpacity>
        </Animated.View>
      </ScrollView>

      {/* Modal Date Picker */}
      <Modal visible={showDatePicker} transparent animationType="fade">
        <Pressable style={styles.modalOverlay} onPress={() => setShowDatePicker(false)}>
          <View style={styles.pickerModal}>
            <DateTimePicker
              value={date}
              mode="date"
              minimumDate={new Date()}
              onChange={(e, d) => {
                setShowDatePicker(false);
                if (d) setDate(d);
              }}
            />
          </View>
        </Pressable>
      </Modal>

      {/* Modal Time Picker */}
      <Modal visible={showTimePicker} transparent animationType="fade">
        <Pressable style={styles.modalOverlay} onPress={() => setShowTimePicker(false)}>
          <View style={styles.pickerModal}>
            <DateTimePicker
              value={time}
              mode="time"
              is24Hour
              onChange={(e, t) => {
                setShowTimePicker(false);
                if (t) setTime(t);
              }}
            />
          </View>
        </Pressable>
      </Modal>

      {/* Modal Service Picker */}
      <Modal visible={showServicePicker} transparent animationType="fade">
        <Pressable
          style={styles.modalOverlay}
          onPress={() => setShowServicePicker(false)}
        >
          <View style={styles.pickerModal}>
            <ScrollView>
              {services.map(service => (
                <TouchableOpacity
                  key={service.id}
                  style={{ padding: 12 }}
                  onPress={() => {
                    setSelectedServiceId(service.id);
                    setShowServicePicker(false);
                  }}
                >
                  <Text style={{ fontSize: 16 }}>{service.name}</Text>
                </TouchableOpacity>
              ))}
            </ScrollView>
          </View>
        </Pressable>
      </Modal>
    </KeyboardAvoidingView>
  );
}
