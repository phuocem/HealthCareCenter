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
        symptoms,
        status,
        created_at,
        qr_code,
        services(name),
        appointment_slots(start_time, end_time),
        user_profiles(full_name)
      `)
      .eq('doctor_id', doctorId)
      .order('created_at', { ascending: false });

    if (error) throw new Error(error.message);
    return data || [];
  },
};
