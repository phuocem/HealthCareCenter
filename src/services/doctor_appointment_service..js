import { supabase } from '../api/supabase';

export const DoctorAppointmentService = {
  async getDoctorId() {
    const { data: userData, error: userError } = await supabase.auth.getUser();
    if (userError || !userData?.user) throw new Error('Không thể lấy thông tin người dùng.');
    const userId = userData.user.id;

    // Kiểm tra xem user có trong bảng doctors không
    const { data: doctor, error: docError } = await supabase
      .from('doctors')
      .select('id')
      .eq('id', userId)
      .single();

    if (docError || !doctor) throw new Error('Không tìm thấy thông tin bác sĩ.');

    return doctor.id;
  },

  async getAppointmentsByDoctor(doctorId) {
   const { data, error } = await supabase
  .from('appointments')
  .select(`
    id,
    appointment_date,
    symptoms,
    status,
    qr_code,
    created_at,
    doctor:doctor_id(full_name),
    patient:user_id(full_name),
    service:service_id(name),
    slot:slot_id(start_time, end_time)
  `)
  .eq('doctor_id', doctorId)
  .order('created_at', { ascending: false });

    if (error) throw new Error(error.message);
    return data || [];
  },
};
