import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  Alert,
  KeyboardAvoidingView,
  Platform,
  Vibration,
  Dimensions,
  ActivityIndicator,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import Animated, { FadeInUp, withSpring, useAnimatedStyle, useSharedValue } from 'react-native-reanimated';
import { LinearGradient } from 'expo-linear-gradient';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import DateTimePickerModal from 'react-native-modal-datetime-picker';
import { signUp } from '../../controllers/authController';
import { registerStyles as styles } from '../../styles/auth/registerStyles';

// Reusable InputField component with animation
const InputField = ({
  icon,
  placeholder,
  value,
  onChange,
  keyboardType,
  secureTextEntry,
  rightIcon,
  onRightPress,
  error,
  autoCapitalize,
  index,
}) => {
  const scale = useSharedValue(1);

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ scale: scale.value }],
  }));

  const handlePressIn = () => {
    scale.value = withSpring(0.98);
  };

  const handlePressOut = () => {
    scale.value = withSpring(1);
  };

  return (
    <Animated.View
      entering={FadeInUp.delay(index * 100).duration(400).springify()}
      style={[styles.inputContainer, animatedStyle, error && styles.inputError]}
    >
      <MaterialCommunityIcons name={icon} size={22} color="#6B7280" style={styles.icon} />
      <TextInput
        style={[styles.input, error && { color: '#F87171' }]}
        placeholder={placeholder}
        placeholderTextColor="#9CA3AF"
        value={value}
        onChangeText={onChange}
        keyboardType={keyboardType}
        secureTextEntry={secureTextEntry}
        autoCapitalize={autoCapitalize}
        accessibilityLabel={placeholder}
        onPressIn={handlePressIn}
        onPressOut={handlePressOut}
      />
      {rightIcon && (
        <TouchableOpacity
          onPress={onRightPress}
          accessibilityLabel={rightIcon === 'eye-outline' ? 'Show password' : 'Hide password'}
        >
          <MaterialCommunityIcons name={rightIcon} size={22} color="#6B7280" />
        </TouchableOpacity>
      )}
      {error && (
        <Animated.Text entering={FadeInUp.duration(200)} style={styles.errorText}>
          {error}
        </Animated.Text>
      )}
    </Animated.View>
  );
};

// Loading Overlay component
const LoadingOverlay = () => (
  <Animated.View entering={FadeInUp.duration(300)} style={styles.loadingOverlay}>
    <ActivityIndicator size="large" color="#00C6FF" />
    <Text style={styles.loadingText}>Processing...</Text>
  </Animated.View>
);

export default function RegisterScreen() {
  const navigation = useNavigation();
  const [form, setForm] = useState({
    email: '',
    password: '',
    full_name: '',
    phone: '',
    gender: '',
    dateOfBirth: null,
  });
  const [errors, setErrors] = useState({});
  const [showPassword, setShowPassword] = useState(false);
  const [isDatePickerVisible, setDatePickerVisible] = useState(false);
  const [loading, setLoading] = useState(false);

  const buttonScale = useSharedValue(1);

  const buttonAnimatedStyle = useAnimatedStyle(() => ({
    transform: [{ scale: buttonScale.value }],
  }));

  const validateField = (key, value) => {
    let error = '';
    switch (key) {
      case 'email':
        if (!value) error = 'Email is required';
        else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) error = 'Invalid email format';
        break;
      case 'password':
        if (!value) error = 'Password is required';
        else if (value.length < 6) error = 'Password must be at least 6 characters';
        break;
      case 'full_name':
        if (!value) error = 'Full name is required';
        break;
      case 'phone':
        if (!value) error = 'Phone number is required';
        else if (!/^[0-9]{10}$/.test(value)) error = 'Phone number must be 10 digits';
        break;
      case 'gender':
        if (!value) error = 'Gender is required';
        else if (!['Male', 'Female', 'male', 'female'].includes(value)) error = 'Gender must be "Male" or "Female"';
        break;
      case 'dateOfBirth':
        if (!value) error = 'Date of birth is required';
        break;
      default:
        break;
    }
    setErrors((prev) => ({ ...prev, [key]: error }));
    return !error;
  };

  const handleChange = (key, value) => {
    setForm((prev) => ({ ...prev, [key]: value }));
    validateField(key, value);
  };

  const validateForm = () => {
    const fields = ['email', 'password', 'full_name', 'phone', 'gender', 'dateOfBirth'];
    let isValid = true;
    fields.forEach((key) => {
      if (!validateField(key, form[key])) isValid = false;
    });
    return isValid;
  };

  const handleRegister = async () => {
    if (!validateForm()) {
      Alert.alert('Error', 'Please check and fill in all required fields correctly.');
      return;
    }

    buttonScale.value = withSpring(0.95);
    Vibration.vibrate(50);

    const { email, password, full_name, phone, gender, dateOfBirth } = form;

    try {
      setLoading(true);
      const formattedDate = dateOfBirth ? dateOfBirth.toISOString().split('T')[0] : new Date().toISOString().split('T')[0];
      const user = await signUp(email, password, full_name, phone, formattedDate, gender);

      if (user) {
        Alert.alert('🎉 Success', 'Your account has been created!', [
          { text: 'OK', onPress: () => navigation.replace('RoleRedirect') },
        ]);
      }
    } catch (error) {
      console.error('Registration error:', error);
      const message = error.message?.includes('User already registered')
        ? 'This email is already registered. Please use another email or log in.'
        : error.message || 'An unknown error occurred.';
      Alert.alert('Registration Error', message);
    } finally {
      setLoading(false);
      buttonScale.value = withSpring(1);
    }
  };

  const showDatePicker = () => {
    setDatePickerVisible(true);
  };

  const hideDatePicker = () => {
    setDatePickerVisible(false);
  };

  const handleConfirm = (date) => {
    handleChange('dateOfBirth', date);
    hideDatePicker();
  };

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      keyboardVerticalOffset={Platform.OS === 'ios' ? 60 : 20}
    >
      <LinearGradient
        colors={['#1E3A8A', '#3B82F6', '#93C5FD']}
        style={styles.gradientBackground}
        start={{ x: 0, y: 0 }}
        end={{ x: 1, y: 1 }}
      >
        <View style={styles.centeredContainer}>
          <Animated.View entering={FadeInUp.duration(600).springify()} style={styles.formContainer}>
            <View style={styles.logoContainer}>
              <MaterialCommunityIcons name="account-plus" size={70} color="#2563EB" />
              <Text style={styles.title}>Create Account</Text>
              <Text style={styles.subtitle}>Join us and start your journey today</Text>
            </View>

            <InputField
              icon="account-outline"
              placeholder="Full Name"
              value={form.full_name}
              onChange={(v) => handleChange('full_name', v)}
              autoCapitalize="words"
              error={errors.full_name}
              index={0}
            />
            <InputField
              icon="email-outline"
              placeholder="Email"
              value={form.email}
              onChange={(v) => handleChange('email', v)}
              keyboardType="email-address"
              autoCapitalize="none"
              error={errors.email}
              index={1}
            />
            <InputField
              icon="lock-outline"
              placeholder="Password"
              value={form.password}
              onChange={(v) => handleChange('password', v)}
              secureTextEntry={!showPassword}
              rightIcon={showPassword ? 'eye-outline' : 'eye-off-outline'}
              onRightPress={() => setShowPassword(!showPassword)}
              error={errors.password}
              index={2}
            />
            <InputField
              icon="phone-outline"
              placeholder="Phone Number"
              value={form.phone}
              onChange={(v) => handleChange('phone', v)}
              keyboardType="phone-pad"
              error={errors.phone}
              index={3}
            />
            <InputField
              icon="account-circle-outline"
              placeholder="Gender (Male/Female)"
              value={form.gender}
              onChange={(v) => handleChange('gender', v)}
              error={errors.gender}
              index={4}
            />

            <Animated.View
              entering={FadeInUp.delay(500).duration(400).springify()}
              style={[styles.inputContainer, errors.dateOfBirth && styles.inputError]}
            >
              <MaterialCommunityIcons name="calendar-outline" size={22} color="#6B7280" style={styles.icon} />
              <TouchableOpacity style={{ flex: 1 }} onPress={showDatePicker} accessibilityLabel="Select date of birth">
                <Text style={[styles.input, { color: form.dateOfBirth ? '#111827' : '#9CA3AF' }]}>
                  {form.dateOfBirth
                    ? `${form.dateOfBirth.getDate().toString().padStart(2, '0')}/${(form.dateOfBirth.getMonth() + 1)
                        .toString()
                        .padStart(2, '0')}/${form.dateOfBirth.getFullYear()}`
                    : 'Select Date of Birth'}
                </Text>
              </TouchableOpacity>
              {errors.dateOfBirth && (
                <Animated.Text entering={FadeInUp.duration(200)} style={styles.errorText}>
                  {errors.dateOfBirth}
                </Animated.Text>
              )}
            </Animated.View>

            <DateTimePickerModal
              isVisible={isDatePickerVisible}
              mode="date"
              onConfirm={handleConfirm}
              onCancel={hideDatePicker}
              maximumDate={new Date()}
              date={form.dateOfBirth || new Date()}
              display={Platform.OS === 'ios' ? 'inline' : 'default'}
              accentColor="#2563EB"
              textColor="#111827"
            />

            <Animated.View entering={FadeInUp.delay(600).duration(400)} style={buttonAnimatedStyle}>
              <TouchableOpacity
                style={[styles.button, loading && styles.buttonDisabled]}
                onPress={handleRegister}
                disabled={loading}
                accessibilityLabel="Register account"
                activeOpacity={0.8}
              >
                <LinearGradient
                  colors={loading ? ['#9CA3AF', '#9CA3AF'] : ['#2563EB', '#60A5FA']}
                  style={styles.buttonGradient}
                >
                  <Text style={styles.buttonText}>{loading ? 'Processing...' : 'Register'}</Text>
                </LinearGradient>
              </TouchableOpacity>
            </Animated.View>

            <Animated.View entering={FadeInUp.delay(700).duration(400)} style={styles.footer}>
              <TouchableOpacity onPress={() => navigation.navigate('Login')} accessibilityLabel="Go to login">
                <Text style={styles.link}>
                  Already have an account? <Text style={styles.linkBold}>Log In</Text>
                </Text>
              </TouchableOpacity>
            </Animated.View>

            {loading && <LoadingOverlay />}
          </Animated.View>
        </View>
      </LinearGradient>
    </KeyboardAvoidingView>
  );
}