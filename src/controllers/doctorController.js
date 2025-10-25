import { supabase } from '../api/supabase';

export async function fetchDoctors() {
  const { data, error } = await supabase
    .from('doctors')
    .select('id, name, specialization')
    .order('id', { ascending: true });

  if (error) throw new Error(error.message);
  return data || [];
}
