// src/controllers/bookingController.js
import { supabase } from '../../api/supabase';
import { createBookingService } from '../../services/patient/bookingService';

export const confirmBookingController = async (doctorId, date, time, symptoms) => {
  if (!symptoms.trim()) {
    throw new Error('⚠️ Vui lòng nhập triệu chứng hoặc mô tả tình trạng.');
  }

  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('Không tìm thấy người dùng. Vui lòng đăng nhập lại.');

  const appointmentDateTime = new Date(
    date.getFullYear(),
    date.getMonth(),
    date.getDate(),
    time.getHours(),
    time.getMinutes()
  ).toISOString();

  await createBookingService({
    doctor_id: doctorId,
    user_id: user.id,
    appointment_date: appointmentDateTime,
    symptoms: symptoms.trim(),
    status: 'pending',
  });
};
