import React, { useEffect, useState, useRef } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  Alert,
  ScrollView,
  Modal,
  TouchableWithoutFeedback,
  ActivityIndicator,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { supabase } from '../../api/supabase';
import { createDoctorWithRoleService } from '../../services/doctor/doctorService'; // ĐÃ SỬA
import { styles } from '../../styles/admin/CreateDoctorAccountStyles';
import Icon from 'react-native-vector-icons/Ionicons';
import { useNavigation } from '@react-navigation/native';

export default function CreateDoctorAccountScreen() {
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [specialization, setSpecialization] = useState('');
  const [experienceYears, setExperienceYears] = useState('');
  const [roomNumber, setRoomNumber] = useState('');
  const [maxPatients, setMaxPatients] = useState('5');
  const [bio, setBio] = useState('');
  const [departmentId, setDepartmentId] = useState('');
  const [departments, setDepartments] = useState([]);
  const [loading, setLoading] = useState(false);
  const [deptModalVisible, setDeptModalVisible] = useState(false);
  const [searchDept, setSearchDept] = useState('');
  const [filteredDepts, setFilteredDepts] = useState([]);
  const [scheduleModalVisible, setScheduleModalVisible] = useState(false);

  // Lịch làm việc
  const [selectedDays, setSelectedDays] = useState([]);
  const [startTime, setStartTime] = useState('');
  const [endTime, setEndTime] = useState('');

  const weekDays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'];
  const navigation = useNavigation();

  // Refs
  const emailRef = useRef(null);
  const passwordRef = useRef(null);
  const specRef = useRef(null);
  const expRef = useRef(null);
  const roomRef = useRef(null);
  const maxRef = useRef(null);
  const bioRef = useRef(null);

  // Tải khoa
  useEffect(() => {
    const fetchDepartments = async () => {
      const { data, error } = await supabase
        .from('departments')
        .select('*')
        .order('name', { ascending: true });
      if (error) {
        Alert.alert('Lỗi', 'Không thể tải danh sách khoa.');
      } else {
        setDepartments(data || []);
        setFilteredDepts(data || []);
      }
    };
    fetchDepartments();
  }, []);

  // Lọc khoa
  useEffect(() => {
    const filtered = departments.filter((dep) =>
      dep.name.toLowerCase().includes(searchDept.toLowerCase())
    );
    setFilteredDepts(filtered);
  }, [searchDept, departments]);

  // Validate
  const isValidEmail = (email) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  const isValidPassword = (pwd) => pwd.length >= 6;
  const isValidTime = (time) => /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/.test(time);

  const selectedDepartmentName = () => {
    const dep = departments.find((d) => String(d.id) === String(departmentId));
    return dep ? dep.name : 'Chọn khoa';
  };

  const toggleDay = (day) => {
    setSelectedDays((prev) =>
      prev.includes(day) ? prev.filter((d) => d !== day) : [...prev, day]
    );
  };

  // Format giờ
  const formatTimeInput = (text) => {
    const cleaned = text.replace(/[^0-9]/g, '');
    if (cleaned.length === 0) return '';
    if (cleaned.length <= 2) return cleaned;
    return `${cleaned.slice(0, 2)}:${cleaned.slice(2, 4)}`.slice(0, 5);
  };

  // TẠO BÁC SĨ
  const handleCreateDoctor = async () => {
    // Validate
    if (!fullName.trim() || !email.trim() || !password || !departmentId) {
      Alert.alert('Thiếu thông tin', 'Vui lòng nhập đầy đủ các trường bắt buộc.');
      return;
    }
    if (!isValidEmail(email)) {
      Alert.alert('Email không hợp lệ', 'Vui lòng nhập đúng định dạng email.');
      return;
    }
    if (!isValidPassword(password)) {
      Alert.alert('Mật khẩu yếu', 'Mật khẩu phải có ít nhất 6 ký tự.');
      return;
    }
    if (selectedDays.length === 0 || !startTime || !endTime) {
      Alert.alert('Thiếu lịch', 'Vui lòng chọn ngày và giờ làm việc.');
      return;
    }
    if (!isValidTime(startTime) || !isValidTime(endTime)) {
      Alert.alert('Giờ sai', 'Vui lòng nhập giờ theo định dạng HH:MM');
      return;
    }

    setLoading(true);
    try {
      // GỌI SERVICE ĐÃ SỬA: TỰ ĐỘNG LƯU LỊCH MẪU + SINH SLOT
      const result = await createDoctorWithRoleService(
        email,
        password,
        fullName,
        departmentId,
        selectedDays,
        startTime,
        endTime
      );

      if (!result.success) {
        Alert.alert('Lỗi', result.message);
        return;
      }

      // CẬP NHẬT THÔNG TIN BÁC SĨ (nếu cần)
      await supabase
        .from('doctors')
        .update({
          specialization: specialization.trim(),
          experience_years: experienceYears ? parseInt(experienceYears, 10) : 0,
          room_number: roomNumber.trim(),
          max_patients_per_slot: maxPatients ? parseInt(maxPatients, 10) : 5,
          bio: bio.trim(),
        })
        .eq('id', result.userId);

      Alert.alert('Thành công!', `Đã tạo bác sĩ: ${fullName}`, [
        { text: 'OK', onPress: () => navigation.navigate('Bác sĩ') },
      ]);
    } catch (error) {
      Alert.alert('Lỗi', error.message || 'Tạo thất bại.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <KeyboardAvoidingView
      style={{ flex: 1 }}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <ScrollView
        style={styles.container}
        contentContainerStyle={styles.scrollContent}
        keyboardShouldPersistTaps="handled"
      >
        <Text style={styles.title}>Tạo tài khoản bác sĩ</Text>

        {/* Full Name */}
        <View style={styles.inputGroup}>
          <Text style={styles.label}>Họ và tên *</Text>
          <View style={styles.inputWrapper}>
            <Icon name="person-outline" size={20} color="#666" style={styles.inputIcon} />
            <TextInput
              style={styles.input}
              placeholder="Nguyễn Văn A"
              value={fullName}
              onChangeText={setFullName}
              returnKeyType="next"
              onSubmitEditing={() => emailRef.current?.focus()}
            />
          </View>
        </View>

        {/* Email */}
        <View style={styles.inputGroup}>
          <Text style={styles.label}>Email *</Text>
          <View style={styles.inputWrapper}>
            <Icon name="mail-outline" size={20} color="#666" style={styles.inputIcon} />
            <TextInput
              ref={emailRef}
              style={styles.input}
              placeholder="doctor@example.com"
              value={email}
              onChangeText={setEmail}
              keyboardType="email-address"
              autoCapitalize="none"
              returnKeyType="next"
              onSubmitEditing={() => passwordRef.current?.focus()}
            />
          </View>
        </View>

        {/* Password */}
        <View style={styles.inputGroup}>
          <Text style={styles.label}>Mật khẩu *</Text>
          <View style={styles.inputWrapper}>
            <Icon name="lock-closed-outline" size={20} color="#666" style={styles.inputIcon} />
            <TextInput
              ref={passwordRef}
              style={styles.input}
              placeholder="••••••••"
              value={password}
              onChangeText={setPassword}
              secureTextEntry
              returnKeyType="next"
            />
          </View>
        </View>

        {/* Khoa */}
        <View style={styles.inputGroup}>
          <Text style={styles.label}>Khoa *</Text>
          <TouchableOpacity
            style={styles.dropdownButton}
            onPress={() => setDeptModalVisible(true)}
          >
            <Icon name="business-outline" size={20} color="#007AFF" style={styles.inputIcon} />
            <Text style={styles.dropdownText}>{selectedDepartmentName()}</Text>
            <Icon name="chevron-down" size={20} color="#007AFF" />
          </TouchableOpacity>
        </View>

        {/* Chuyên môn */}
        <View style={styles.inputGroup}>
          <Text style={styles.label}>Chuyên môn</Text>
          <View style={styles.inputWrapper}>
            <Icon name="medkit-outline" size={20} color="#666" style={styles.inputIcon} />
            <TextInput
              ref={specRef}
              style={styles.input}
              placeholder="Tim mạch, Nội khoa..."
              value={specialization}
              onChangeText={setSpecialization}
            />
          </View>
        </View>

        {/* Kinh nghiệm */}
        <View style={styles.inputGroup}>
          <Text style={styles.label}>Số năm kinh nghiệm</Text>
          <View style={styles.inputWrapper}>
            <Icon name="time-outline" size={20} color="#666" style={styles.inputIcon} />
            <TextInput
              ref={expRef}
              style={styles.input}
              placeholder="5"
              value={experienceYears}
              onChangeText={setExperienceYears}
              keyboardType="numeric"
            />
          </View>
        </View>

        {/* Phòng */}
        <View style={styles.inputGroup}>
          <Text style={styles.label}>Số phòng</Text>
          <View style={styles.inputWrapper}>
            <Icon name="home-outline" size={20} color="#666" style={styles.inputIcon} />
            <TextInput
              ref={roomRef}
              style={styles.input}
              placeholder="101"
              value={roomNumber}
              onChangeText={setRoomNumber}
            />
          </View>
        </View>

        {/* Số bệnh nhân */}
        <View style={styles.inputGroup}>
          <Text style={styles.label}>Số bệnh nhân/ca</Text>
          <View style={styles.inputWrapper}>
            <Icon name="people-outline" size={20} color="#666" style={styles.inputIcon} />
            <TextInput
              ref={maxRef}
              style={styles.input}
              placeholder="5"
              value={maxPatients}
              onChangeText={setMaxPatients}
              keyboardType="numeric"
            />
          </View>
        </View>

        {/* Tiểu sử */}
        <View style={styles.inputGroup}>
          <Text style={styles.label}>Tiểu sử</Text>
          <View style={[styles.inputWrapper, { height: 100, alignItems: 'flex-start' }]}>
            <Icon name="document-text-outline" size={20} color="#666" style={styles.inputIcon} />
            <TextInput
              ref={bioRef}
              style={[styles.input, { height: 80, textAlignVertical: 'top' }]}
              placeholder="Giới thiệu ngắn về bác sĩ..."
              value={bio}
              onChangeText={setBio}
              multiline
            />
          </View>
        </View>

        {/* Lịch làm việc */}
        <View style={styles.inputGroup}>
          <Text style={styles.label}>Lịch làm việc *</Text>
          <TouchableOpacity
            style={styles.dropdownButton}
            onPress={() => setScheduleModalVisible(true)}
          >
            <Icon name="calendar-outline" size={20} color="#007AFF" style={styles.inputIcon} />
            <Text style={styles.dropdownText}>
              {selectedDays.length > 0
                ? `${selectedDays.join(', ')} (${startTime || '--:--'} - ${endTime || '--:--'})`
                : 'Chọn ngày và giờ làm việc'}
            </Text>
            <Icon name="chevron-down" size={20} color="#007AFF" />
          </TouchableOpacity>
        </View>

        {/* Nút tạo */}
        <TouchableOpacity
          style={[styles.primaryButton, loading && styles.buttonDisabled]}
          onPress={handleCreateDoctor}
          disabled={loading}
        >
          {loading ? (
            <ActivityIndicator color="#fff" size="small" />
          ) : (
            <>
              <Icon name="person-add" size={20} color="#fff" />
              <Text style={styles.primaryButtonText}>Tạo tài khoản bác sĩ</Text>
            </>
          )}
        </TouchableOpacity>
      </ScrollView>

      {/* Modal Khoa */}
      <Modal visible={deptModalVisible} animationType="slide" transparent>
        <TouchableWithoutFeedback onPress={() => setDeptModalVisible(false)}>
          <View style={styles.modalOverlay} />
        </TouchableWithoutFeedback>
        <View style={styles.modalContainer}>
          <View style={styles.modalHeader}>
            <Text style={styles.modalTitle}>Chọn khoa</Text>
            <TouchableOpacity onPress={() => setDeptModalVisible(false)}>
              <Icon name="close" size={24} color="#666" />
            </TouchableOpacity>
          </View>
          <TextInput
            style={styles.searchInput}
            placeholder="Tìm khoa..."
            value={searchDept}
            onChangeText={setSearchDept}
          />
          <ScrollView style={{ maxHeight: 400 }}>
            {filteredDepts.map((dept) => (
              <TouchableOpacity
                key={dept.id}
                style={styles.modalItem}
                onPress={() => {
                  setDepartmentId(String(dept.id));
                  setDeptModalVisible(false);
                  setSearchDept('');
                }}
              >
                <Text style={styles.modalItemText}>{dept.name}</Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>
      </Modal>

      {/* Modal Lịch */}
      <Modal visible={scheduleModalVisible} animationType="slide" transparent>
        <TouchableWithoutFeedback onPress={() => setScheduleModalVisible(false)}>
          <View style={styles.modalOverlay} />
        </TouchableWithoutFeedback>
        <View style={styles.modalContainer}>
          <View style={styles.modalHeader}>
            <Text style={styles.modalTitle}>Lịch làm việc</Text>
            <TouchableOpacity onPress={() => setScheduleModalVisible(false)}>
              <Icon name="close" size={24} color="#666" />
            </TouchableOpacity>
          </View>

          <Text style={styles.sectionTitle}>Chọn ngày</Text>
          <View style={styles.daysContainer}>
            {weekDays.map((day) => (
              <TouchableOpacity
                key={day}
                style={[
                  styles.dayChip,
                  selectedDays.includes(day) && styles.dayChipSelected,
                ].filter(Boolean)}
                onPress={() => toggleDay(day)}
              >
                <Text
                  style={[
                    styles.dayChipText,
                    selectedDays.includes(day) && styles.dayChipTextSelected,
                  ].filter(Boolean)}
                >
                  {day}
                </Text>
              </TouchableOpacity>
            ))}
          </View>

          <Text style={styles.sectionTitle}>Giờ làm việc</Text>
          <View style={styles.timeRow}>
            <View style={styles.timeInputWrapper}>
              <Icon name="time-outline" size={18} color="#666" />
              <TextInput
                placeholder="08:00"
                value={startTime}
                onChangeText={(text) => setStartTime(formatTimeInput(text))}
                style={styles.timeInput}
                maxLength={5}
              />
            </View>
            <Text style={styles.timeSeparator}>→</Text>
            <View style={styles.timeInputWrapper}>
              <Icon name="time-outline" size={18} color="#666" />
              <TextInput
                placeholder="17:00"
                value={endTime}
                onChangeText={(text) => setEndTime(formatTimeInput(text))}
                style={styles.timeInput}
                maxLength={5}
              />
            </View>
          </View>

          <TouchableOpacity
            style={[
              styles.primaryButton,
              (!startTime || !endTime || selectedDays.length === 0 || !isValidTime(startTime) || !isValidTime(endTime))
                ? styles.buttonDisabled
                : null,
            ]}
            onPress={() => {
              if (selectedDays.length === 0 || !startTime || !endTime) {
                Alert.alert('Thiếu', 'Chọn ngày và giờ đầy đủ.');
                return;
              }
              if (!isValidTime(startTime) || !isValidTime(endTime)) {
                Alert.alert('Sai giờ', 'Dùng định dạng HH:MM');
                return;
              }
              setScheduleModalVisible(false);
            }}
          >
            <Text style={styles.primaryButtonText}>Xác nhận</Text>
          </TouchableOpacity>
        </View>
      </Modal>
    </KeyboardAvoidingView>
  );
}