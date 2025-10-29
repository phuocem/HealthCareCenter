import React, { useEffect, useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert, ScrollView } from 'react-native';
import { Picker } from '@react-native-picker/picker';
import { Colors } from '../../shared/colors';
import { supabase } from '../../api/supabase';
import { createDoctorWithRole } from '../../controllers/adminController';
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

  // 🧩 Lấy danh sách khoa từ Supabase
  useEffect(() => {
    const fetchDepartments = async () => {
      const { data, error } = await supabase.from('departments').select('*');
      if (error) {
        Alert.alert('Lỗi', 'Không thể tải danh sách khoa.');
      } else {
        setDepartments(data);
      }
    };
    fetchDepartments();
  }, []);

  const handleCreateDoctor = async () => {
  if (!fullName || !email || !password || !departmentId) {
    Alert.alert('Thiếu thông tin', 'Vui lòng nhập đầy đủ thông tin bắt buộc.');
    return;
  }

  try {
    const result = await createDoctorWithRole(email, password, fullName, departmentId);

    await supabase
      .from('doctors')
      .update({
        specialization,
        experience_years: parseInt(experienceYears) || 0,
        room_number: roomNumber,
        max_patients_per_slot: parseInt(maxPatients),
        bio,
      })
      .eq('id', result.userId);

    Alert.alert('✅ Thành công', `Đã tạo tài khoản bác sĩ ${fullName}`);
    // reset form ...
  } catch (error) {
    Alert.alert('Lỗi', error.message);
  }
};


  return (
    <ScrollView style={styles.container} contentContainerStyle={{ paddingBottom: 50 }}>
      <Text style={styles.title}>Tạo tài khoản bác sĩ</Text>

      <TextInput style={styles.input} placeholder="Họ và tên" value={fullName} onChangeText={setFullName} />
      <TextInput style={styles.input} placeholder="Email" keyboardType="email-address" value={email} onChangeText={setEmail} />
      <TextInput style={styles.input} placeholder="Mật khẩu" secureTextEntry value={password} onChangeText={setPassword} />

      <View style={styles.pickerContainer}>
        <Text style={styles.label}>Khoa</Text>
        <Picker selectedValue={departmentId} onValueChange={setDepartmentId}>
          <Picker.Item label="Chọn khoa" value="" />
          {departments.map((dep) => (
            <Picker.Item key={dep.id} label={dep.name} value={dep.id} />
          ))}
        </Picker>
      </View>

      <TextInput style={styles.input} placeholder="Chuyên khoa" value={specialization} onChangeText={setSpecialization} />
      <TextInput style={styles.input} placeholder="Số năm kinh nghiệm" keyboardType="numeric" value={experienceYears} onChangeText={setExperienceYears} />
      <TextInput style={styles.input} placeholder="Số phòng" value={roomNumber} onChangeText={setRoomNumber} />
      <TextInput style={styles.input} placeholder="Số bệnh nhân tối đa / ca" keyboardType="numeric" value={maxPatients} onChangeText={setMaxPatients} />
      <TextInput
        style={[styles.input, { height: 100, textAlignVertical: 'top' }]}
        placeholder="Giới thiệu ngắn (Bio)"
        multiline
        value={bio}
        onChangeText={setBio}
      />

      <TouchableOpacity style={styles.button} onPress={handleCreateDoctor}>
        <Text style={styles.buttonText}>Tạo tài khoản bác sĩ</Text>
      </TouchableOpacity>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.background, padding: 20 },
  title: { fontSize: 22, fontWeight: 'bold', color: Colors.text, textAlign: 'center', marginBottom: 20 },
  input: {
    borderWidth: 1,
    borderColor: Colors.grayLight,
    borderRadius: 10,
    padding: 12,
    color: Colors.text,
    marginBottom: 12,
  },
  pickerContainer: {
    borderWidth: 1,
    borderColor: Colors.grayLight,
    borderRadius: 10,
    marginBottom: 15,
  },
  label: {
    color: Colors.textSecondary,
    marginLeft: 10,
    marginTop: 5,
  },
  button: {
    backgroundColor: Colors.primary,
    paddingVertical: 14,
    borderRadius: 10,
    alignItems: 'center',
  },
  buttonText: { color: Colors.white, fontWeight: 'bold', fontSize: 16 },
});
