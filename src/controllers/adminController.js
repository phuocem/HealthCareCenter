import { createUserWithRoleService } from '../services/adminService';
import { Alert } from 'react-native';

export const createUserWithRole = async (email, password, fullName, departmentId = null) => {
  try {
    const result = await createUserWithRoleService(email, password, fullName, departmentId);
    Alert.alert('✅ Thành công', result.message);
    return result;
  } catch (error) {
    console.error('❌ Lỗi tạo tài khoản:', error);
    Alert.alert('Lỗi', error.message);
    throw error;
  }
};
