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
  Keyboard,
} from 'react-native';
import { supabase } from '../../api/supabase';
import { createDoctorWithRole } from '../../controllers/adminController';
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

  const emailRef = useRef(null);
  const passwordRef = useRef(null);
  const deptRef = useRef(null);
  const specRef = useRef(null);
  const expRef = useRef(null);
  const roomRef = useRef(null);
  const maxRef = useRef(null);
  const bioRef = useRef(null);
  const navigation = useNavigation();

  useEffect(() => {
    const fetchDepartments = async () => {
      const { data, error } = await supabase.from('departments').select('*').order('name', { ascending: true });
      if (error) {
        Alert.alert('Lỗi', 'Không thể tải danh sách khoa.');
      } else {
        setDepartments(data || []);
        setFilteredDepts(data || []);
      }
    };
    fetchDepartments();
  }, []);

  useEffect(() => {
    const filtered = departments.filter(dep => dep.name.toLowerCase().includes(searchDept.toLowerCase()));
    setFilteredDepts(filtered);
  }, [searchDept, departments]);

  const isValidEmail = email => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  const isValidPassword = pwd => pwd.length >= 6;

  const selectedDepartmentName = () => {
    const dep = departments.find(d => String(d.id) === String(departmentId));
    return dep ? dep.name : 'Chọn khoa';
  };

  const handleCreateDoctor = async () => {
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

    setLoading(true);
    try {
      const result = await createDoctorWithRole(email, password, fullName, departmentId);
      if (result?.userId) {
        await supabase
          .from('doctors')
          .update({
            specialization: specialization.trim(),
            experience_years: experienceYears ? parseInt(experienceYears) : 0,
            room_number: roomNumber.trim(),
            max_patients_per_slot: maxPatients ? parseInt(maxPatients) : 5,
            bio: bio.trim(),
          })
          .eq('id', result.userId);
      }

      Alert.alert('Thành công', `Đã tạo tài khoản bác sĩ: ${fullName}`, [
        {
          text: 'OK',
          onPress: () => {
            navigation.navigate('Bác sĩ');
          },
        },
      ]);
    } catch (error) {
      Alert.alert('Lỗi', error.message || 'Đã xảy ra lỗi khi tạo tài khoản.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <ScrollView style={styles.container} contentContainerStyle={{ paddingBottom: 80 }} keyboardShouldPersistTaps="handled">
        <Text style={styles.title}>Tạo tài khoản bác sĩ</Text>

        <View style={styles.inputGroup}>
          <Text style={styles.label}>Họ và tên *</Text>
          <View style={styles.inputWrapper}>
            <Icon name="person-outline" size={20} color="#666" style={styles.icon} />
            <TextInput
              style={styles.inputWithIcon}
              placeholder="Nguyễn Văn A"
              value={fullName}
              onChangeText={setFullName}
              returnKeyType="next"
              onSubmitEditing={() => emailRef.current?.focus()}
            />
          </View>
        </View>

        <View style={styles.inputGroup}>
          <Text style={styles.label}>Email *</Text>
          <View style={styles.inputWrapper}>
            <Icon name="mail-outline" size={20} color="#666" style={styles.icon} />
            <TextInput
              ref={emailRef}
              style={styles.inputWithIcon}
              placeholder="doctor@example.com"
              keyboardType="email-address"
              autoCapitalize="none"
              value={email}
              onChangeText={setEmail}
              returnKeyType="next"
              onSubmitEditing={() => passwordRef.current?.focus()}
            />
          </View>
        </View>

        <View style={styles.inputGroup}>
          <Text style={styles.label}>Mật khẩu *</Text>
          <View style={styles.inputWrapper}>
            <Icon name="lock-closed-outline" size={20} color="#666" style={styles.icon} />
            <TextInput
              ref={passwordRef}
              style={styles.inputWithIcon}
              placeholder="••••••••"
              secureTextEntry
              value={password}
              onChangeText={setPassword}
              returnKeyType="next"
              onSubmitEditing={() => deptRef.current?.focus()}
            />
          </View>
        </View>

        <View style={styles.inputGroup}>
          <Text style={styles.label}>Khoa *</Text>
          <TouchableOpacity
            ref={deptRef}
            style={styles.dropdownButton}
            onPress={() => {
              setDeptModalVisible(true);
              Keyboard.dismiss();
            }}
          >
            <Icon name="business-outline" size={20} color="#666" style={styles.icon} />
            <Text style={styles.dropdownText}>{selectedDepartmentName()}</Text>
            <Icon name="chevron-down" size={20} color="#666" />
          </TouchableOpacity>
        </View>

        <View style={styles.inputGroup}>
          <Text style={styles.label}>Chuyên khoa</Text>
          <View style={styles.inputWrapper}>
            <Icon name="medkit-outline" size={20} color="#666" style={styles.icon} />
            <TextInput
              ref={specRef}
              style={styles.inputWithIcon}
              placeholder="Tim mạch, Nội tiết..."
              value={specialization}
              onChangeText={setSpecialization}
              returnKeyType="next"
              onSubmitEditing={() => expRef.current?.focus()}
            />
          </View>
        </View>

        <View style={styles.inputGroup}>
          <Text style={styles.label}>Số năm kinh nghiệm</Text>
          <View style={styles.inputWrapper}>
            <Icon name="time-outline" size={20} color="#666" style={styles.icon} />
            <TextInput
              ref={expRef}
              style={styles.inputWithIcon}
              placeholder="5"
              keyboardType="numeric"
              value={experienceYears}
              onChangeText={text => setExperienceYears(text.replace(/[^0-9]/g, ''))}
              returnKeyType="next"
              onSubmitEditing={() => roomRef.current?.focus()}
            />
          </View>
        </View>

        <View style={styles.inputGroup}>
          <Text style={styles.label}>Số phòng</Text>
          <View style={styles.inputWrapper}>
            <Icon name="home-outline" size={20} color="#666" style={styles.icon} />
            <TextInput
              ref={roomRef}
              style={styles.inputWithIcon}
              placeholder="P.301"
              value={roomNumber}
              onChangeText={setRoomNumber}
              returnKeyType="next"
              onSubmitEditing={() => maxRef.current?.focus()}
            />
          </View>
        </View>

        <View style={styles.inputGroup}>
          <Text style={styles.label}>Số bệnh nhân tối đa / ca</Text>
          <View style={styles.inputWrapper}>
            <Icon name="people-outline" size={20} color="#666" style={styles.icon} />
            <TextInput
              ref={maxRef}
              style={styles.inputWithIcon}
              placeholder="5"
              keyboardType="numeric"
              value={maxPatients}
              onChangeText={text => setMaxPatients(text.replace(/[^0-9]/g, ''))}
              returnKeyType="next"
              onSubmitEditing={() => bioRef.current?.focus()}
            />
          </View>
        </View>

        <View style={styles.inputGroup}>
          <Text style={styles.label}>Giới thiệu ngắn (Bio)</Text>
          <View style={styles.textAreaWrapper}>
            <Icon name="document-text-outline" size={20} color="#666" style={styles.icon} />
            <TextInput
              ref={bioRef}
              style={styles.textArea}
              placeholder="Bác sĩ chuyên khoa Tim mạch với 10 năm kinh nghiệm..."
              multiline
              numberOfLines={4}
              textAlignVertical="top"
              value={bio}
              onChangeText={setBio}
            />
          </View>
        </View>

        <TouchableOpacity
          style={[styles.button, loading && styles.buttonDisabled]}
          onPress={handleCreateDoctor}
          disabled={loading}
        >
          {loading ? <ActivityIndicator color="#fff" /> : <Text style={styles.buttonText}>Tạo tài khoản bác sĩ</Text>}
        </TouchableOpacity>
      </ScrollView>

      <Modal visible={deptModalVisible} animationType="slide" transparent>
        <TouchableWithoutFeedback onPress={() => setDeptModalVisible(false)}>
          <View style={styles.modalOverlay} />
        </TouchableWithoutFeedback>

        <View style={styles.modalContent}>
          <Text style={styles.modalTitle}>Chọn khoa</Text>

          <View style={styles.searchContainer}>
            <Icon name="search" size={20} color="#666" />
            <TextInput
              style={styles.searchInput}
              placeholder="Tìm khoa..."
              value={searchDept}
              onChangeText={setSearchDept}
              autoFocus
            />
            {searchDept ? (
              <TouchableOpacity onPress={() => setSearchDept('')}>
                <Icon name="close-circle" size={20} color="#999" />
              </TouchableOpacity>
            ) : null}
          </View>

          <ScrollView style={{ maxHeight: 400 }}>
            {filteredDepts.length === 0 ? (
              <Text style={styles.emptyText}>Không tìm thấy khoa nào.</Text>
            ) : (
              filteredDepts.map(dep => (
                <TouchableOpacity
                  key={dep.id}
                  style={styles.deptItem}
                  onPress={() => {
                    setDepartmentId(String(dep.id));
                    setDeptModalVisible(false);
                    setSearchDept('');
                    specRef.current?.focus();
                  }}
                >
                  <Text style={styles.deptName}>{dep.name}</Text>
                  {String(dep.id) === String(departmentId) && <Icon name="checkmark" size={20} color="#007AFF" />}
                </TouchableOpacity>
              ))
            )}
          </ScrollView>

          <TouchableOpacity
            style={styles.cancelButton}
            onPress={() => {
              setDeptModalVisible(false);
              setSearchDept('');
            }}
          >
            <Text style={styles.cancelText}>Hủy</Text>
          </TouchableOpacity>
        </View>
      </Modal>
    </>
  );
}
