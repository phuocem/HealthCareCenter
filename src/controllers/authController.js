import { supabase } from '../api/supabase';

export const signIn = async (email, password) => {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });
  if (error) throw error;
  return data;
};

export const signUp = async (email, password, fullName, phone, dateOfBirth, gender) => {
  const normalizedGender =
    gender?.toLowerCase().includes('nam')
      ? 'male'
      : gender?.toLowerCase().includes('nữ') || gender?.toLowerCase().includes('nu')
      ? 'female'
      : 'other';

  let formattedDate = null;
  const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
  if (dateRegex.test(dateOfBirth)) formattedDate = dateOfBirth;

  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: { full_name: fullName, phone, date_of_birth: formattedDate, gender: normalizedGender },
    },
  });

  if (error) throw error;
  const user = data.user;

  if (user) {
    const { error: profileError } = await supabase.from('user_profiles').upsert(
      {
        id: user.id,
        full_name: fullName,
        date_of_birth: formattedDate,
        phone,
        gender: normalizedGender,
        role_id: 3, // 🟢 người dùng mặc định là role 3
      },
      { onConflict: 'id' }
    );

    if (profileError) throw profileError;
  }

  return user;
};


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
