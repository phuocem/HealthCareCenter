import { supabase } from '../api/supabase';

export async function getUserRole(userId) {
  const { data, error } = await supabase
    .from('user_profiles')
    .select('roles(name)')
    .eq('id', userId)
    .single();

  if (error) return null;
  return data?.roles?.name;
}
