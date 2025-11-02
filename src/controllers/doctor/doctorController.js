import { supabase } from '../../api/supabase';

// Lấy danh sách bác sĩ
export async function getDoctors() {
  const { data, error } = await supabase
    .from('user_profiles')
    .select('*, roles(name)')
    .eq('role_id', 2); // role_id = 2 là bác sĩ

  if (error) throw error;
  return data;
}

// Tạo bác sĩ mới
export async function createDoctor(doctorData) {
  const { data, error } = await supabase.from('user_profiles').insert([doctorData]);
  if (error) throw error;
  return data;
}

// Cập nhật thông tin bác sĩ
export async function updateDoctor(id, updates) {
  const { data, error } = await supabase
    .from('user_profiles')
    .update(updates)
    .eq('id', id);

  if (error) throw error;
  return data;
}

// Xóa bác sĩ
export async function deleteDoctor(id) {
  const { error } = await supabase.from('user_profiles').delete().eq('id', id);
  if (error) throw error;
  return true;
}
