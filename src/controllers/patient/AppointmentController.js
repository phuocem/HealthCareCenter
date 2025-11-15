import { supabase } from '../../api/supabase';
import { AppointmentService } from '../../services/patient/AppointmentService';

export class AppointmentController {
  static async loadAppointments(setAppointments, setLoading, setError) {
    try {
      if (!setAppointments || !setLoading || !setError) {
        throw new Error('Các hàm callback không hợp lệ.');
      }

      setLoading(true);
      setError(null);

      const { data: { user } } = await supabase.auth.getUser();
      if (!user) throw new Error('Người dùng chưa đăng nhập.');

      const appointments = await AppointmentService.fetchAppointmentsByUser(user.id);
      setAppointments(appointments);
    } catch (error) {
      console.error('Error in loadAppointments:', error);
      setError(error.message || 'Có lỗi xảy ra khi tải lịch hẹn.');
    } finally {
      setLoading(false);
    }
  }

  static async cancelAppointment(appointmentId, setAppointments, setError, cancelledBy = 'patient', reason = null) {
    try {
      if (!appointmentId || !setAppointments || !setError) {
        throw new Error('Dữ liệu không hợp lệ.');
      }

      const updatedAppointment = await AppointmentService.cancelAppointment(appointmentId, cancelledBy, reason);
      setAppointments(prev => 
        prev.map(appt => appt.id === appointmentId ? updatedAppointment : appt)
      );
      return { success: true, message: `Đã hủy lịch khám bởi ${cancelledBy === 'doctor' ? 'bác sĩ' : 'bệnh nhân'}` };
    } catch (error) {
      console.error('Error in cancelAppointment:', error);
      setError(error.message || 'Không thể hủy lịch.');
      return { success: false, message: error.message };
    }
  }
}