// src/services/userService.js
import { supabase } from '../api/supabase';

/** 🔹 Lấy profile người dùng */
export const fetchUserProfile = async (userId) => {
  const { data, error } = await supabase
    .from('user_profiles')
    .select('id, full_name, gender, date_of_birth, roles(name)')
    .eq('id', userId)
    .maybeSingle();

  if (error) throw error;
  return data;
};

/** 🔹 Lấy thông tin xác thực (auth) */
export const fetchAuthUser = async () => {
  const { data, error } = await supabase.auth.getUser();
  if (error) throw error;
  return data.user;
};
