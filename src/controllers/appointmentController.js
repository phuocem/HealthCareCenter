import { supabase } from '../api/supabase';

// đây là cái để lấy lịch khám
export async function fetchAppointments() {
  const { data, error } = await supabase
    .from('appointments')
    .select(`
      id,
      status,
      symptoms,
      created_at,
      doctor:doctors (
        name,
        specialization
      ),
      slot:appointment_slots (
        work_date,
        start_time,
        end_time
      )
    `)
    .order('created_at', { ascending: false });

  if (error) throw new Error(error.message);
  return data || [];
}

// đây là cái để hủy lịch khám
export async function cancelAppointment(id) {
  const { error } = await supabase
    .from('appointments')
    .update({ status: 'cancelled' })
    .eq('id', id);

  if (error) throw new Error(error.message);
  return true;
}
