// src/services/searchDoctorService.js
import { supabase } from '../../api/supabase';

/**
 * 🔍 Tìm kiếm bác sĩ theo tên
 * Join bảng doctors với user_profiles để lấy tên đầy đủ
 */
export const searchDoctorsService = async (keyword) => {
  const { data, error } = await supabase
    .from('doctors')
    .select(`
      id,
      department_id,
      user_profiles!inner(full_name)
    `)
    .ilike('user_profiles.full_name', `%${keyword}%`);

  if (error) throw error;
  return data;
};
