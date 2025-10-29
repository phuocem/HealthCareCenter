// src/services/doctorService.js
import { supabase } from '../api/supabase';

/**
 * 🟢 Tạo tài khoản bác sĩ kèm user profile
 */
export const createDoctorWithRoleService = async (
  email,
  password,
  fullName,
  departmentId = null,
  role = 2 // 2 = bác sĩ
) => {
  // 1️⃣ Tạo tài khoản trong Supabase Auth
  const { data: authData, error: authError } = await supabase.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
  });

  if (authError) {
    if (authError.message.includes('already registered')) {
      return { success: false, message: `⚠️ Email ${email} đã tồn tại` };
    }
    throw new Error(authError.message);
  }

  const userId = authData.user.id;

  // 2️⃣ Tạo profile nếu chưa có
  const { data: existingProfile } = await supabase
    .from('user_profiles')
    .select('id')
    .eq('id', userId)
    .maybeSingle();

  if (!existingProfile) {
    await supabase
  .from('user_profiles')
  .insert([{ id: userId, full_name: fullName, email, role_id: role }]);


    if (profileError) throw new Error(profileError.message);
  }

  // 3️⃣ Thêm thông tin vào bảng doctors
  const { data: existingDoctor } = await supabase
    .from('doctors')
    .select('id')
    .eq('id', userId)
    .maybeSingle();

  if (!existingDoctor) {
    const { error: doctorError } = await supabase
      .from('doctors')
      .insert([{ id: userId, department_id: departmentId }]);

    if (doctorError) throw new Error(doctorError.message);
  }

  return { success: true, message: `✅ Đã tạo tài khoản bác sĩ cho ${fullName}`, userId };
};

/**
 * 🟡 Lấy danh sách toàn bộ bác sĩ (JOIN với user_profiles + departments + roles)
 */
export const getAllDoctorsService = async () => {
  const { data, error } = await supabase
    .from('doctors')
    .select(`
      id,
      department_id,
      specialization,
      experience_years,
      room_number,
      max_patients_per_slot,
      bio,
      created_at,
      user_profiles (
        full_name,
        email,
        role_id,
        roles ( name )
      ),
      departments ( name )
    `)
    .order('created_at', { ascending: false });

  if (error) throw new Error(error.message);
  return data;
};

/**
 * 🔵 Cập nhật thông tin bác sĩ
 */
export const updateDoctorService = async (userId, updateData = {}) => {
  const updates = {};

  if (updateData.fullName) {
    const { error: profileError } = await supabase
      .from('user_profiles')
      .update({ full_name: updateData.fullName })
      .eq('id', userId);

    if (profileError) throw new Error(profileError.message);
  }

  if (updateData.departmentId) updates.department_id = updateData.departmentId;
  if (updateData.specialization) updates.specialization = updateData.specialization;
  if (updateData.experience_years) updates.experience_years = updateData.experience_years;
  if (updateData.room_number) updates.room_number = updateData.room_number;
  if (updateData.max_patients_per_slot) updates.max_patients_per_slot = updateData.max_patients_per_slot;
  if (updateData.bio) updates.bio = updateData.bio;

  if (Object.keys(updates).length > 0) {
    const { error: doctorError } = await supabase
      .from('doctors')
      .update(updates)
      .eq('id', userId);

    if (doctorError) throw new Error(doctorError.message);
  }

  return { success: true, message: '✅ Đã cập nhật thông tin bác sĩ' };
};

/**
 * 🔴 Xoá bác sĩ (bao gồm Auth, Profile, Doctor)
 */
export const deleteDoctorService = async (userId) => {
  // Xoá trong bảng doctors
  const { error: doctorError } = await supabase.from('doctors').delete().eq('id', userId);
  if (doctorError) throw new Error(doctorError.message);

  // Xoá trong bảng user_profiles
  const { error: profileError } = await supabase.from('user_profiles').delete().eq('id', userId);
  if (profileError) throw new Error(profileError.message);

  // Xoá trong auth.users
  const { error: authError } = await supabase.auth.admin.deleteUser(userId);
  if (authError) throw new Error(authError.message);

  return { success: true, message: '🗑️ Đã xoá bác sĩ thành công' };
};
