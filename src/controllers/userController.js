import { fetchAuthUser, fetchUserProfile } from '../services/userService';

/** 🔹 Controller: kết hợp Auth + Profile */
export const getUserProfile = async (userId) => {
  try {
    const authUser = await fetchAuthUser(); // ✅ Lấy email
    const profile = await fetchUserProfile(userId); // ✅ Lấy info DB

    return {
      id: profile?.id,
      name: profile?.full_name || 'Người dùng mới',
      email: authUser?.email || '',
      gender: profile?.gender || 'unknown',
      date_of_birth: profile?.date_of_birth || null,
      role: profile?.roles?.name || 'patient',
    };
  } catch (err) {
    console.error('❌ getUserProfile error:', err);
    throw err;
  }
};
