import { supabase } from '../../api/supabase';
import { createBookingService } from './../../services/patient/bookingService';

/**
 * Xác nhận đặt lịch khám
 * @param {string} doctorId - ID bác sĩ
 * @param {number} serviceId - ID dịch vụ
 * @param {Date} date - Ngày hẹn
 * @param {Date} time - Giờ hẹn
 * @param {string} symptoms - Triệu chứng / mô tả
 */
export const confirmBookingController = async (doctorId, serviceId, date, time, symptoms) => {
  // 1️⃣ Kiểm tra triệu chứng
  if (!symptoms?.trim()) {
    throw new Error('⚠️ Vui lòng nhập triệu chứng hoặc mô tả tình trạng.');
  }

  // 2️⃣ Kiểm tra dịch vụ
  if (!serviceId) {
    throw new Error('⚠️ Vui lòng chọn dịch vụ khám.');
  }

  // 3️⃣ Lấy user hiện tại
  const { data: { user }, error: userError } = await supabase.auth.getUser();
  if (userError || !user) {
    throw new Error('Không tìm thấy người dùng. Vui lòng đăng nhập lại.');
  }

  // 4️⃣ Chuyển date + time sang ISO string
  const appointmentDateTime = new Date(
    date.getFullYear(),
    date.getMonth(),
    date.getDate(),
    time.getHours(),
    time.getMinutes()
  ).toISOString();

  // 5️⃣ Gọi service lưu vào Supabase
  try {
    await createBookingService({
      doctor_id: doctorId,
      user_id: user.id,
      service_id: serviceId,
      appointment_date: appointmentDateTime,
      symptoms: symptoms.trim(),
      status: 'pending', // mặc định
    });
  } catch (err) {
    throw new Error('❌ Đặt lịch thất bại: ' + (err.message || 'Lỗi không xác định'));
  }

  return true; // Trả về true nếu đặt lịch thành công
};
