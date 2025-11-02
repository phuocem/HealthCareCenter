import { supabase } from '../../api/supabase';

export const createDoctorWithRoleService = async (email, password, fullName, departmentId = null, role = 2) => {
  const { data: authData, error: authError } = await supabase.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
  });

  if (authError) {
    if (authError.message.includes('already registered')) {
      return { success: false, message: `Email ${email} đã tồn tại` };
    }
    throw new Error(authError.message);
  }

  const userId = authData.user.id;

  const { data: existingProfile } = await supabase
    .from('user_profiles')
    .select('id')
    .eq('id', userId)
    .maybeSingle();

  if (!existingProfile) {
    const { error: profileError } = await supabase
      .from('user_profiles')
      .insert([{ id: userId, full_name: fullName, role_id: role, email }]);
    if (profileError) throw new Error(profileError.message);
  }

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

  return { success: true, message: `Đã tạo tài khoản bác sĩ cho ${fullName}`, userId };
};

export const getAllDoctorsService = async () => {
  const { data, error } = await supabase
    .from('doctors')
    .select(`
      id,
      department_id,
      user_profiles (full_name, role_id)
    `);

  if (error) throw new Error(error.message);
  return data;
};
