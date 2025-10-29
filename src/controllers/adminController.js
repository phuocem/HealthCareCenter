import { createDoctorWithRoleService } from '../services/adminService';
import { Alert } from 'react-native';

export const createDoctorWithRole = async (email, password, fullName, departmentId = null) => {
  try {
    const role = 2; // role bác sĩ
    const result = await createDoctorWithRoleService(email, password, fullName, departmentId, role);
    Alert.alert('✅ Thành công', result.message);
    return result;
  } catch (error) {
    console.error('❌ Lỗi tạo tài khoản:', error);
    Alert.alert('Lỗi', error.message);
    throw error;
  }
};
