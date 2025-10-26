import { supabase } from '../api/supabase';

/** 🔹 Lấy thông tin xác thực từ Supabase Auth */
export const fetchAuthUser = async () => {
  const { data, error } = await supabase.auth.getUser();
  if (error) throw error;
  return data.user;
};

/** 🔹 Lấy hồ sơ người dùng từ bảng user_profiles */
export const fetchUserProfile = async (userId) => {
  const { data, error } = await supabase
    .from('user_profiles')
    .select('id, full_name, gender, date_of_birth, roles(name)')
    .eq('id', userId)
    .maybeSingle();

  if (error) throw error;
  return data;
};
