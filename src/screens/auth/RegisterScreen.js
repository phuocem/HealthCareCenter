import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  Alert,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import Animated, { FadeInUp } from 'react-native-reanimated';
import { LinearGradient } from 'expo-linear-gradient';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import DateTimePicker from '@react-native-community/datetimepicker';
import { signUp } from '../../controllers/authController';
import { registerStyles as styles } from '../../styles/auth/registerStyles'; // ⬅ dùng style riêng

export default function RegisterScreen() {
  const navigation = useNavigation();

  const [form, setForm] = useState({
    email: '',
    password: '',
    full_name: '',
    phone: '',
    gender: '',
    dateOfBirth: '',
  });

  const [showPassword, setShowPassword] = useState(false);
  const [showDatePicker, setShowDatePicker] = useState(false);
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [loading, setLoading] = useState(false);

  const handleChange = (key, value) => setForm((prev) => ({ ...prev, [key]: value }));

  const handleRegister = async () => {
    const { email, password, full_name, phone, gender, dateOfBirth } = form;

    try {
      if (!email || !password || !full_name || !phone || !gender || !dateOfBirth) {
        return Alert.alert('Thiếu thông tin', 'Vui lòng điền đầy đủ tất cả các trường.');
      }
      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email))
        return Alert.alert('Email không hợp lệ', 'Vui lòng nhập đúng định dạng email.');
      if (!/^[0-9]{10}$/.test(phone))
        return Alert.alert('Số điện thoại sai', 'Phải có đúng 10 chữ số.');
      if (!['Nam', 'Nữ', 'nam', 'nữ'].includes(gender))
        return Alert.alert('Giới tính không hợp lệ', 'Vui lòng nhập "Nam" hoặc "Nữ".');

      const [day, month, year] = dateOfBirth.split('/');
      const formattedDate = `${year}-${month}-${day}`;

      setLoading(true);
      const user = await signUp(email, password, full_name, phone, formattedDate, gender);

      if (user) {
        Alert.alert('🎉 Thành công', 'Tài khoản của bạn đã được tạo!');
        navigation.replace('RoleRedirect');
      }
    } catch (error) {
      console.error('Registration error:', error);
      if (error.message?.includes('User already registered')) {
        Alert.alert('Email đã tồn tại', 'Hãy đăng nhập hoặc dùng email khác.');
      } else {
        Alert.alert('Lỗi đăng ký', error.message || 'Đã xảy ra lỗi không xác định.');
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      keyboardVerticalOffset={Platform.OS === 'ios' ? 40 : 20}
    >
      <LinearGradient colors={['#007AFF', '#00C6FF']} style={styles.gradientBackground}>
        <Animated.View entering={FadeInUp.duration(600)} style={styles.formContainer}>
          <View style={styles.logoContainer}>
            <MaterialCommunityIcons name="account-plus" size={64} color="#2563EB" />
            <Text style={styles.title}>Tạo tài khoản</Text>
            <Text style={styles.subtitle}>Điền thông tin của bạn để bắt đầu</Text>
          </View>

          {/* Inputs */}
          {[
            { key: 'full_name', icon: 'account-outline', placeholder: 'Họ và tên' },
            { key: 'email', icon: 'email-outline', placeholder: 'Email', keyboardType: 'email-address' },
            {
              key: 'password',
              icon: 'lock-outline',
              placeholder: 'Mật khẩu',
              secureTextEntry: !showPassword,
              rightIcon: showPassword ? 'eye-outline' : 'eye-off-outline',
              onRightPress: () => setShowPassword(!showPassword),
            },
            { key: 'phone', icon: 'phone-outline', placeholder: 'Số điện thoại', keyboardType: 'phone-pad' },
            { key: 'gender', icon: 'account-circle-outline', placeholder: 'Giới tính (Nam/Nữ)' },
          ].map((item) => (
            <View key={item.key} style={styles.inputContainer}>
              <MaterialCommunityIcons name={item.icon} size={20} color="#6B7280" style={styles.icon} />
              <TextInput
                style={styles.input}
                placeholder={item.placeholder}
                placeholderTextColor="#9CA3AF"
                value={form[item.key]}
                onChangeText={(v) => handleChange(item.key, v)}
                keyboardType={item.keyboardType}
                secureTextEntry={item.secureTextEntry}
              />
              {item.rightIcon && (
                <TouchableOpacity onPress={item.onRightPress}>
                  <MaterialCommunityIcons name={item.rightIcon} size={20} color="#6B7280" />
                </TouchableOpacity>
              )}
            </View>
          ))}

          {/* Ngày sinh */}
          <View style={styles.inputContainer}>
            <MaterialCommunityIcons name="calendar-outline" size={20} color="#6B7280" style={styles.icon} />
            <TouchableOpacity style={{ flex: 1 }} onPress={() => setShowDatePicker(true)}>
              <Text style={[styles.input, { color: form.dateOfBirth ? '#111827' : '#9CA3AF' }]}>
                {form.dateOfBirth || 'Chọn ngày sinh'}
              </Text>
            </TouchableOpacity>
            {showDatePicker && (
              <DateTimePicker
                value={selectedDate}
                mode="date"
                display={Platform.OS === 'ios' ? 'spinner' : 'default'}
                onChange={(event, selected) => {
                  if (Platform.OS !== 'ios') setShowDatePicker(false);
                  if (selected) {
                    setSelectedDate(selected);
                    const d = new Date(selected);
                    const formatted = `${d.getDate().toString().padStart(2, '0')}/${(
                      d.getMonth() + 1
                    )
                      .toString()
                      .padStart(2, '0')}/${d.getFullYear()}`;
                    handleChange('dateOfBirth', formatted);
                  }
                }}
              />
            )}
          </View>

          {/* Button */}
          <TouchableOpacity
            style={[styles.button, loading && styles.buttonDisabled]}
            onPress={handleRegister}
            disabled={loading}
          >
            <LinearGradient
              colors={loading ? ['#9CA3AF', '#9CA3AF'] : ['#2563EB', '#3B82F6']}
              style={styles.buttonGradient}
            >
              <Text style={styles.buttonText}>{loading ? 'Đang xử lý...' : 'Đăng ký'}</Text>
            </LinearGradient>
          </TouchableOpacity>

          {/* Footer */}
          <View style={styles.footer}>
            <TouchableOpacity onPress={() => navigation.navigate('Login')}>
              <Text style={styles.link}>
                Đã có tài khoản? <Text style={styles.linkBold}>Đăng nhập</Text>
              </Text>
            </TouchableOpacity>
          </View>
        </Animated.View>
      </LinearGradient>
    </KeyboardAvoidingView>
  );
}
