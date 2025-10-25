import { supabase } from '../api/supabase';

export const signIn = async (email, password) => {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });
  if (error) throw error;
  return data;
};

export const signUp = async (email, password, fullName) => {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      emailRedirectTo: null,
      data: { full_name: fullName },
    },
  });
  if (error) throw error;
  return data.user;
};

export const getUserProfile = async (userId) => {
  const { data, error } = await supabase
    .from('user_profiles')
    .select('*, roles(*)')
    .eq('id', userId)
    .maybeSingle();

  if (error) throw error;

  return {
    id: data.id,
    name: data.full_name,
    role: data.roles?.name || 'patient',
  };
};
