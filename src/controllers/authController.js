import { supabase } from '../api/supabase';

/**
 * Đăng nhập
 */
export const signIn = async (email, password) => {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });
  if (error) throw error;
  return data;
};

/**
 * Đăng ký tài khoản mới
 */
export const signUp = async (email, password, fullName, phone, dateOfBirth, gender) => {
  // Log for debugging
  console.log('signUp called with:', { email, password, fullName, phone, dateOfBirth, gender });

  // Normalize gender
  const normalizedGender =
    gender?.toLowerCase().includes('nam')
      ? 'male'
      : gender?.toLowerCase().includes('nữ') || gender?.toLowerCase().includes('nu')
      ? 'female'
      : 'other';

  // Validate dateOfBirth format (yyyy-mm-dd)
  let formattedDate = null;
  if (dateOfBirth) {
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (dateRegex.test(dateOfBirth)) {
      formattedDate = dateOfBirth;
    } else {
      console.warn('⚠️ Ngày sinh không hợp lệ:', dateOfBirth);
    }
  }

  // Register user
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      emailRedirectTo: null,
      data: {
        full_name: fullName || '',
        phone: phone || '',
        date_of_birth: formattedDate || null,
        gender: normalizedGender || 'other',
      },
    },
  });

  if (error) throw error;
  const user = data.user;

  // Insert into user_profiles
  if (user) {
    const { error: profileError } = await supabase
      .from('user_profiles')
      .upsert(
        { id: user.id, full_name: fullName, date_of_birth: formattedDate, phone, gender: normalizedGender },
        { onConflict: 'id' }
      );

    if (profileError) {
      console.error('❌ Lỗi khi chèn vào user_profiles:', profileError);
      throw profileError;
    }
  }

  return user;
};

/**
 * Lấy thông tin hồ sơ người dùng
 */
export const getUserProfile = async (userId) => {
  const { data, error } = await supabase
    .from('user_profiles')
    .select('*, roles(*)')
    .eq('id', userId)
    .maybeSingle();

  if (error) throw error;

  return {
    id: data?.id,
    name: data?.full_name,
    role: data?.roles?.name || 'patient',
  };
};