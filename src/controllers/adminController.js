import { supabase } from '../api/supabase';

export const createUserWithRole = async (email, password, fullName, roleName) => {
  const { data: authData, error: authError } = await supabase.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
  });

  if (authError) throw new Error(authError.message);
  const userId = authData.user.id;

  const { data: roleData, error: roleError } = await supabase
    .from('roles')
    .select('id')
    .eq('name', roleName)
    .single();

  if (roleError) throw new Error(roleError.message);

  const { error: profileError } = await supabase
    .from('user_profiles')
    .insert([{ id: userId, role_id: roleData.id, full_name: fullName }]);

  if (profileError) throw new Error(profileError.message);

  if (roleName === 'doctor') {
    const { error: doctorError } = await supabase
      .from('doctors')
      .insert([{ id: userId }]);

    if (doctorError) throw new Error(doctorError.message);
  }

  return { success: true, message: `Đã tạo tài khoản ${roleName} cho ${fullName}` };
};
