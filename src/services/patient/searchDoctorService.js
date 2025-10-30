import { supabase } from '../../api/supabase';
export const searchDoctorsService = async (keyword) => {
  const { data, error } = await supabase
    .from('doctors')
    .select(`
      id,
      department_id,
      user_profiles!inner(full_name)
    `)
    .ilike('user_profiles.full_name', `%${keyword}%`);

  if (error) throw error;
  return data;
};
