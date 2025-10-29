import { supabase } from '../api/supabase';

/** 🧩 Tạo tài khoản người dùng mặc định vai trò bác sĩ (role_id = 2) */
export const createUserWithRoleService = async (email, password, fullName, departmentId = null) => {
  // 1️⃣ Tạo tài khoản Auth
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

  // 2️⃣ Kiểm tra user_profiles đã tồn tại chưa
  const { data: existingProfile } = await supabase
    .from('user_profiles')
    .select('id')
    .eq('id', userId)
    .maybeSingle();

  if (!existingProfile) {
    const { error: profileError } = await supabase
      .from('user_profiles')
      .insert([{ id: userId, full_name: fullName, role_id: 2, department_id: departmentId }]);
    if (profileError) throw new Error(profileError.message);
  }

  // 3️⃣ Nếu là bác sĩ → thêm vào doctors nếu chưa có
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

  return { success: true, message: `✅ Đã tạo tài khoản bác sĩ cho ${fullName}` };
};
