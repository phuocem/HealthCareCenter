import { supabase } from '../../api/supabase';

export const DoctorAppointmentService = {
  async getDoctorId() {
    try {
      const { data: userData, error: userError } = await supabase.auth.getUser();
      if (userError || !userData?.user) {
        throw new Error('Không thể lấy thông tin người dùng.');
      }
      const userId = userData.user.id;
      console.log('Fetched doctor ID:', userId); // Debug
      const { data: doctor, error: docError } = await supabase
        .from('doctors')
        .select('id')
        .eq('id', userId)
        .single();

      if (docError || !doctor) {
        throw new Error('Không tìm thấy thông tin bác sĩ.');
      }

      return doctor.id;
    } catch (err) {
      throw err;
    }
  },

  async getAppointmentsByDoctor(doctorId) {
    try {
      console.log('Fetching appointments for doctorId:', doctorId);
     const { data, error } = await supabase
  .from('appointments')
  .select(`
    id,
    appointment_date,
    symptoms,
    status,
    qr_code,
    created_at,

    doctor:user_profiles!appointments_doctor_id_fkey(full_name, phone),
    patient:user_profiles!appointments_user_id_fkey(full_name, phone),
    service:services!appointments_service_id_fkey(
      name,
      department:department_id(name)
    ),
    slot:slot_id(start_time, end_time)
  `)
  .eq('doctor_id', doctorId)
  .order('created_at', { ascending: false });



      if (error) {
        console.error('Supabase error:', error.message);
        throw new Error(error.message);
      }
      console.log('Fetched appointments data:', data);
     return data?.map(appointment => ({
  ...appointment,
  patient: appointment.patient || { full_name: 'Bệnh nhân không xác định', phone: '' },
  department: appointment.department || { name: 'Khoa không xác định', description: '' },
})) || [];


    } catch (err) {
      throw err;
    }
  },

  async confirmAppointment(appointmentId) {
    try {
      const { data, error } = await supabase
        .from('appointments')
        .update({ 
          status: 'confirmed',
          updated_at: new Date().toISOString()
        })
        .eq('id', appointmentId)
        .select()
        .single();

      if (error) throw new Error(error.message);
      if (!data) throw new Error('Không tìm thấy cuộc hẹn để xác nhận.');
      return data;
    } catch (err) {
      throw err;
    }
  },

  async cancelAppointment(appointmentId) {
    try {
      const { data, error } = await supabase
        .from('appointments')
        .update({ 
          status: 'cancelled',
          updated_at: new Date().toISOString()
        })
        .eq('id', appointmentId)
        .select()
        .single();

      if (error) throw new Error(error.message);
      if (!data) throw new Error('Không tìm thấy cuộc hẹn để hủy.');
      return data;
    } catch (err) {
      throw err;
    }
  },
};