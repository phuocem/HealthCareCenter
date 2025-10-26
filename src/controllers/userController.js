// src/controllers/userController.js
import * as userService from '../services/userService';

/** 🔹 Lấy thông tin hồ sơ người dùng (controller) */
export const getUserProfile = async (userId) => {
  try {
    const profile = await userService.fetchUserProfile(userId);
    if (!profile) throw new Error(`Không tìm thấy hồ sơ cho ID: ${userId}`);

    const user = await userService.fetchAuthUser();
    if (user?.id !== userId)
      throw new Error('User ID không khớp với user đang đăng nhập');

    return {
      id: profile.id,
      name: profile.full_name || 'Người dùng mới',
      email: user.email,
      gender: profile.gender || 'Không xác định',
      date_of_birth: profile.date_of_birth || null,
      role: profile.roles?.name || 'patient',
    };
  } catch (error) {
    console.error('❌ Lỗi khi lấy hồ sơ người dùng:', error.message);
    throw error;
  }
};
