import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  Alert,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import Animated, { FadeInUp } from 'react-native-reanimated';
import { LinearGradient } from 'expo-linear-gradient';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { signUp } from '../../controllers/authController';
import DateTimePicker from '@react-native-community/datetimepicker';

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

  const handleChange = (key, value) => {
    setForm((prev) => ({ ...prev, [key]: value }));
  };

  const handleRegister = async () => {
    const { email, password, full_name, phone, gender, dateOfBirth } = form;

    try {
      // 🧩 Validate cơ bản
      if (!email || !password || !full_name || !phone || !gender || !dateOfBirth) {
        return Alert.alert('Thiếu thông tin', 'Vui lòng điền đầy đủ tất cả các trường.');
      }

      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email))
        return Alert.alert('Email không hợp lệ', 'Vui lòng nhập đúng định dạng email.');

      if (!/^[0-9]{10}$/.test(phone))
        return Alert.alert('Số điện thoại sai', 'Phải có đúng 10 chữ số.');

      if (!['Nam', 'Nữ', 'nam', 'nữ'].includes(gender))
        return Alert.alert('Giới tính không hợp lệ', 'Vui lòng nhập "Nam" hoặc "Nữ".');

      // ✅ Format ngày sinh từ dd/mm/yyyy -> yyyy-mm-dd
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
          {/* Header */}
          <View style={styles.logoContainer}>
            <MaterialCommunityIcons name="account-plus" size={64} color="#2563EB" />
            <Text style={styles.title}>Tạo tài khoản</Text>
            <Text style={styles.subtitle}>Điền thông tin của bạn để bắt đầu</Text>
          </View>

          {/* Các ô nhập */}
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

          {/* Nút đăng ký */}
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

          {/* Chuyển sang đăng nhập */}
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

const styles = StyleSheet.create({
  container: { flex: 1 },
  gradientBackground: { flex: 1, justifyContent: 'center', paddingHorizontal: 24 },
  formContainer: {
    backgroundColor: 'rgba(255,255,255,0.95)',
    borderRadius: 24,
    padding: 24,
    shadowColor: '#000',
    shadowOpacity: 0.15,
    shadowRadius: 12,
    elevation: 8,
  },
  logoContainer: { alignItems: 'center', marginBottom: 16 },
  title: { fontSize: 26, fontWeight: '700', color: '#111827', marginTop: 12 },
  subtitle: { fontSize: 15, color: '#6B7280', marginBottom: 28 },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#E5E7EB',
    marginBottom: 16,
    paddingHorizontal: 12,
    backgroundColor: '#fff',
  },
  icon: { marginRight: 8 },
  input: { flex: 1, fontSize: 16, color: '#111827', paddingVertical: 14 },
  button: { borderRadius: 12, overflow: 'hidden', marginTop: 8 },
  buttonGradient: { paddingVertical: 14, alignItems: 'center', justifyContent: 'center' },
  buttonDisabled: { opacity: 0.7 },
  buttonText: { color: '#fff', fontSize: 18, fontWeight: '600' },
  footer: { marginTop: 24, alignItems: 'center' },
  link: { color: '#6B7280', fontSize: 15 },
  linkBold: { fontWeight: '700', color: '#2563EB' },
});
