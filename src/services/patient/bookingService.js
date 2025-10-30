import { supabase } from '../../api/supabase';
export const createBookingService = async (bookingData) => {
  const { error } = await supabase.from('appointments').insert([bookingData]);
  if (error) throw error;
  return true;
};
