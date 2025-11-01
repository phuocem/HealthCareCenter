import { DoctorAppointmentService } from '../../services/doctor/doctor_appointment_service';

export const DoctorAppointmentController = {
  async loadAppointments(setDoctorId, setAppointments, setLoading, showError) {
    try {
      setLoading(true);
      const doctorId = await DoctorAppointmentService.getDoctorId();
      setDoctorId(doctorId);

      const appointments = await DoctorAppointmentService.getAppointmentsByDoctor(doctorId);
      setAppointments(appointments);
    } catch (err) {
      showError(err.message || 'Có lỗi xảy ra khi tải lịch hẹn.');
    } finally {
      setLoading(false);
    }
  },
};
