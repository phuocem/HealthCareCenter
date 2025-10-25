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
import Animated, { FadeInUp, FadeOut } from 'react-native-reanimated';
import { LinearGradient } from 'expo-linear-gradient';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { signUp } from '../../controllers/authController';

export default function RegisterScreen() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const navigation = useNavigation();

  const handleRegister = async () => {
    try {
      setLoading(true);
      const user = await signUp(email, password, name);
      if (user) {
        Alert.alert('🎉 Thành công', 'Tài khoản của bạn đã được tạo thành công!');
        navigation.replace('RoleRedirect');
      } else {
        Alert.alert('Lỗi', 'Không thể tạo tài khoản. Vui lòng thử lại.');
      }
    } catch (error) {
      console.error(error);
      Alert.alert('Lỗi đăng ký', error.message);
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
      <LinearGradient
        colors={['#007AFF', '#00C6FF']}
        style={styles.gradientBackground}
      >
        <Animated.View entering={FadeInUp.duration(600)} style={styles.formContainer}>
          {/* Logo and Title */}
          <Animated.View entering={FadeInUp.delay(100).duration(600)} style={styles.logoContainer}>
            <MaterialCommunityIcons name="account-plus" size={64} color="#2563EB" />
            <Text style={styles.title}>Tạo tài khoản mới</Text>
            <Text style={styles.subtitle}>Hoàn tất thông tin để bắt đầu</Text>
          </Animated.View>

          {/* Name Input */}
          <Animated.View entering={FadeInUp.delay(200).duration(600)} style={styles.inputContainer}>
            <MaterialCommunityIcons name="account-outline" size={20} color="#6B7280" style={styles.icon} />
            <TextInput
              style={styles.input}
              placeholder="Họ và tên"
              placeholderTextColor="#9CA3AF"
              value={name}
              onChangeText={setName}
              autoCapitalize="words"
            />
          </Animated.View>

          {/* Email Input */}
          <Animated.View entering={FadeInUp.delay(300).duration(600)} style={styles.inputContainer}>
            <MaterialCommunityIcons name="email-outline" size={20} color="#6B7280" style={styles.icon} />
            <TextInput
              style={styles.input}
              placeholder="Email"
              placeholderTextColor="#9CA3AF"
              keyboardType="email-address"
              value={email}
              onChangeText={setEmail}
              autoCapitalize="none"
            />
          </Animated.View>

          {/* Password Input */}
          <Animated.View entering={FadeInUp.delay(400).duration(600)} style={styles.inputContainer}>
            <MaterialCommunityIcons name="lock-outline" size={20} color="#6B7280" style={styles.icon} />
            <TextInput
              style={styles.input}
              placeholder="Mật khẩu"
              placeholderTextColor="#9CA3AF"
              secureTextEntry={!showPassword}
              value={password}
              onChangeText={setPassword}
            />
            <TouchableOpacity
              style={styles.eyeIcon}
              onPress={() => setShowPassword(!showPassword)}
            >
              <MaterialCommunityIcons
                name={showPassword ? 'eye-outline' : 'eye-off-outline'}
                size={20}
                color="#6B7280"
              />
            </TouchableOpacity>
          </Animated.View>

          {/* Register Button */}
          <Animated.View entering={FadeInUp.delay(500).duration(600)}>
            <TouchableOpacity
              style={[styles.button, loading && styles.buttonDisabled]}
              onPress={handleRegister}
              disabled={loading}
            >
              <LinearGradient
                colors={loading ? ['#6B7280', '#6B7280'] : ['#2563EB', '#3B82F6']}
                style={styles.buttonGradient}
              >
                {loading ? (
                  <Animated.View entering={FadeIn} exiting={FadeOut}>
                    <MaterialCommunityIcons
                      name="refresh"
                      size={24}
                      color="#fff"
                      style={styles.loadingIcon}
                    />
                  </Animated.View>
                ) : (
                  <Text style={styles.buttonText}>Đăng ký</Text>
                )}
              </LinearGradient>
            </TouchableOpacity>
          </Animated.View>

          {/* Login Link */}
          <Animated.View entering={FadeInUp.delay(600).duration(600)} style={styles.footer}>
            <TouchableOpacity onPress={() => navigation.navigate('Login')}>
              <Text style={styles.link}>
                Đã có tài khoản?{' '}
                <Text style={styles.linkBold}>Đăng nhập</Text>
              </Text>
            </TouchableOpacity>
          </Animated.View>
        </Animated.View>
      </LinearGradient>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  gradientBackground: {
    flex: 1,
    justifyContent: 'center',
    paddingHorizontal: 24,
  },
  formContainer: {
    backgroundColor: 'rgba(255, 255, 255, 0.95)',
    borderRadius: 24,
    padding: 24,
    marginHorizontal: 8,
    shadowColor: '#000',
    shadowOpacity: 0.15,
    shadowRadius: 12,
    elevation: 8,
  },
  logoContainer: {
    alignItems: 'center',
    marginBottom: 16,
  },
  title: {
    fontSize: 28,
    fontWeight: '700',
    textAlign: 'center',
    color: '#111827',
    marginTop: 12,
  },
  subtitle: {
    fontSize: 16,
    textAlign: 'center',
    color: '#6B7280',
    marginBottom: 32,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#fff',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#E5E7EB',
    marginBottom: 16,
    paddingHorizontal: 12,
    shadowColor: '#000',
    shadowOpacity: 0.05,
    shadowRadius: 4,
    elevation: 2,
  },
  icon: {
    marginRight: 8,
  },
  input: {
    flex: 1,
    fontSize: 16,
    color: '#111827',
    paddingVertical: 14,
  },
  eyeIcon: {
    padding: 8,
  },
  button: {
    borderRadius: 12,
    overflow: 'hidden',
    marginTop: 8,
  },
  buttonGradient: {
    paddingVertical: 14,
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonDisabled: {
    opacity: 0.7,
  },
  buttonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: '600',
  },
  loadingIcon: {
    transform: [{ rotate: '360deg' }],
  },
  footer: {
    marginTop: 24,
    alignItems: 'center',
  },
  link: {
    color: '#6B7280',
    fontSize: 15,
  },
  linkBold: {
    fontWeight: '700',
    color: '#2563EB',
  },
});