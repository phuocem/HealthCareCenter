// src/controllers/authController.js
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
      data: { full_name: fullName },
    },
  });
  if (error) throw error;
  return data;
};

export const getUserProfile = async (userId) => {
  const { data, error } = await supabase
    .from('user_profiles')
    .select('id, full_name, role_id, roles(name)')
    .eq('id', userId)
    .single();

  if (error) throw error;

  return {
    id: data.id,
    name: data.full_name,
    role: data.roles?.name || 'patient',
  };
};
