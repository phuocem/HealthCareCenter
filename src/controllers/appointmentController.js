// appointmentController.js
import { getAppointmentsByDoctorService, updateAppointmentStatusService } from '../services/appointmentService';

export const getAppointmentsByDoctorController = async (doctorId) => {
  try {
    const data = await getAppointmentsByDoctorService(doctorId);
    return data;
  } catch (error) {
    console.error('Lỗi lấy lịch hẹn:', error.message);
    throw error;
  }
};

export const updateAppointmentStatusController = async (id, status) => {
  try {
    return await updateAppointmentStatusService(id, status);
  } catch (error) {
    console.error('Lỗi cập nhật trạng thái:', error.message);
    throw error;
  }
};
