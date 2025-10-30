// src/controllers/doctorController.js
import { createDoctorWithRoleService, getAllDoctorsService } from '../services/doctorService';
import { Alert } from 'react-native';

export const createDoctorWithRole = async (email, password, fullName, departmentId = null) => {
  try {
    const result = await createDoctorWithRoleService(email, password, fullName, departmentId);
    if (result.success) {
      Alert.alert('Thành công', result.message);
    } else {
      Alert.alert('Cảnh báo', result.message);
    }
    return result;
  } catch (error) {
    console.error('Lỗi tạo tài khoản:', error);
    Alert.alert('Lỗi', error.message || 'Không thể tạo tài khoản');
  }
};

export const fetchAllDoctors = async () => {
  try {
    const data = await getAllDoctorsService();
    return data;
  } catch (error) {
    Alert.alert('Lỗi', 'Không thể tải danh sách bác sĩ');
    console.error(error);
  }
};
