import 'package:get/get.dart';
import 'app_routes.dart';
import '../../modules/auth/login/presentation/views/login_view.dart';
import '../../modules/auth/login/presentation/bindings/login_binding.dart';
import '../../modules/auth/register/presentation/views/register_view.dart';
import '../../modules/auth/register/presentation/bindings/register_binding.dart';
import '../../modules/patient/dashboard/presentation/views/dashboard_view.dart' as patient_dashboard;
import '../../modules/patient/dashboard/presentation/bindings/dashboard_binding.dart' as patient_binding;
import '../../modules/patient/booking/presentation/views/book_by_doctor_view.dart';
import '../../modules/patient/booking/presentation/views/select_date_view.dart';
import '../../modules/patient/booking/presentation/views/select_time_slot_view.dart';
import '../../modules/patient/booking/presentation/bindings/booking_binding.dart';
import '../../modules/patient/history/presentation/views/history_view.dart';
import '../../modules/patient/history/presentation/bindings/history_binding.dart';
import '../../modules/doctor/appointments/presentation/views/appointment_view.dart';
import '../../modules/doctor/appointments/presentation/bindings/appointment_binding.dart';
import '../../modules/admin/dashboard/presentation/views/dashboard_view.dart' as admin_dashboard;
import '../../modules/admin/dashboard/presentation/bindings/dashboard_binding.dart' as admin_binding;
import '../../modules/admin/user_management/presentation/views/doctor_management_view.dart';
import '../../modules/admin/user_management/presentation/views/schedule_management_view.dart';
import '../../modules/admin/user_management/presentation/views/add_doctor_view.dart';
import '../../modules/admin/user_management/presentation/views/add_doctor_schedule_view.dart';
import '../../modules/admin/user_management/presentation/views/staff_management_view.dart';
import '../../modules/admin/user_management/presentation/bindings/user_management_binding.dart';
import '../../modules/admin/system_config/presentation/views/department_management_view.dart';
import '../../modules/admin/system_config/presentation/views/service_management_view.dart';
import '../../modules/admin/system_config/presentation/views/lab_test_management_view.dart';
import '../../modules/admin/system_config/presentation/bindings/system_config_binding.dart';
import '../../modules/admin/inventory/presentation/views/inventory_view.dart';
import '../../modules/admin/inventory/presentation/bindings/inventory_binding.dart';
import '../../modules/receptionist/presentation/views/receptionist_dashboard_view.dart';
import '../../modules/receptionist/presentation/bindings/receptionist_dashboard_binding.dart';
import '../../modules/billing/presentation/views/cashier_dashboard_view.dart';
import '../../modules/billing/presentation/bindings/cashier_dashboard_binding.dart';
import '../../modules/lab/presentation/views/lab_dashboard_view.dart';
import '../../modules/lab/presentation/bindings/lab_dashboard_binding.dart';
import '../../modules/pharmacy/presentation/views/pharmacist_dashboard_view.dart';
import '../../modules/pharmacy/presentation/bindings/pharmacist_dashboard_binding.dart';

// Doctor Examine
import '../../modules/doctor/examination/presentation/views/examination_view.dart';
import '../../modules/doctor/examination/presentation/bindings/examination_binding.dart';

// Receptionist Appointments
import '../../modules/receptionist/appointments/presentation/views/receptionist_appointments_view.dart';
import '../../modules/receptionist/appointments/presentation/bindings/receptionist_appointments_binding.dart';

// Lab Results Enter
import '../../modules/lab/results/presentation/views/enter_result_view.dart';
import '../../modules/lab/results/presentation/bindings/lab_results_binding.dart';

// Cashier Invoices
import '../../modules/billing/invoice/presentation/views/invoice_list_view.dart';
import '../../modules/billing/invoice/presentation/bindings/invoice_binding.dart';

// Pharmacy Dispensing
import '../../modules/pharmacy/dispensing/presentation/views/dispense_view.dart';
import '../../modules/pharmacy/dispensing/presentation/bindings/dispense_binding.dart';

// Patient Lab Results
import '../../modules/patient/medical_results/presentation/views/medical_results_view.dart';
import '../../modules/patient/medical_results/presentation/bindings/medical_results_binding.dart';

// Patient Prescriptions
import '../../modules/patient/prescriptions/presentation/views/prescription_view.dart';
import '../../modules/patient/prescriptions/presentation/bindings/prescription_binding.dart';

// Patient Invoices
import '../../modules/patient/invoices/presentation/views/patient_invoice_view.dart';
import '../../modules/patient/invoices/presentation/bindings/patient_invoice_binding.dart';

// Expanded Features
// Admin Analytics
import '../../modules/admin/analytics/presentation/views/admin_analytics_view.dart';
import '../../modules/admin/analytics/presentation/bindings/admin_analytics_binding.dart';

// Patient Reviews
import '../../modules/patient/reviews/presentation/views/patient_reviews_view.dart';
import '../../modules/patient/reviews/presentation/bindings/patient_reviews_binding.dart';

// Patient Queue
import '../../modules/patient/queue/presentation/views/queue_status_view.dart';
import '../../modules/patient/queue/presentation/bindings/queue_status_binding.dart';

// Patient Upload Docs
import '../../modules/patient/docs/presentation/views/upload_docs_view.dart';
import '../../modules/patient/docs/presentation/bindings/upload_docs_binding.dart';

// Receptionist Queue
import '../../modules/receptionist/queue/presentation/views/queue_management_view.dart';
import '../../modules/receptionist/queue/presentation/bindings/queue_management_binding.dart';

// Receptionist Walkin Booking
import '../../modules/receptionist/booking/presentation/views/walkin_booking_view.dart';
import '../../modules/receptionist/booking/presentation/bindings/walkin_booking_binding.dart';

// Doctor EMR
import '../../modules/doctor/emr/presentation/views/emr_history_view.dart';
import '../../modules/doctor/emr/presentation/bindings/emr_history_binding.dart';

// Doctor Telemedicine
import '../../modules/doctor/telemedicine/presentation/views/telemedicine_call_view.dart';
import '../../modules/doctor/telemedicine/presentation/bindings/telemedicine_call_binding.dart';

// Pharmacist Inventory
import '../../modules/pharmacy/inventory/presentation/views/pharmacy_inventory_view.dart';
import '../../modules/pharmacy/inventory/presentation/bindings/pharmacy_inventory_binding.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.PATIENT_HOME,
      page: () => const patient_dashboard.DashboardView(),
      binding: patient_binding.DashboardBinding(),
    ),
    GetPage(
      name: Routes.BOOK_BY_DOCTOR,
      page: () => const BookByDoctorView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: Routes.SELECT_DATE,
      page: () => const SelectDateView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: Routes.SELECT_TIME_SLOT,
      page: () => const SelectTimeSlotView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: Routes.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: Routes.DOCTOR_HOME,
      page: () => const AppointmentView(),
      binding: AppointmentBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_HOME,
      page: () => const admin_dashboard.DashboardView(),
      binding: admin_binding.DashboardBinding(),
    ),
    GetPage(
      name: Routes.DOCTOR_MANAGEMENT,
      page: () => const DoctorManagementView(),
      binding: UserManagementBinding(),
    ),
    GetPage(
      name: Routes.SCHEDULE_MANAGEMENT,
      page: () => const ScheduleManagementView(),
      binding: UserManagementBinding(),
    ),
    GetPage(
      name: Routes.ADD_DOCTOR,
      page: () => AddDoctorView(),
      binding: UserManagementBinding(),
    ),
    GetPage(
      name: Routes.ADD_DOCTOR_SCHEDULE,
      page: () => AddDoctorScheduleView(),
      binding: UserManagementBinding(),
    ),
    GetPage(
      name: Routes.DEPARTMENTS,
      page: () => const DepartmentManagementView(),
      binding: SystemConfigBinding(),
    ),
    GetPage(
      name: Routes.SERVICES,
      page: () => const ServiceManagementView(),
      binding: SystemConfigBinding(),
    ),
    GetPage(
      name: Routes.LAB_TESTS,
      page: () => const LabTestManagementView(),
      binding: SystemConfigBinding(),
    ),
    GetPage(
      name: Routes.STAFF_MANAGEMENT,
      page: () => const StaffManagementView(),
      binding: UserManagementBinding(),
    ),
    GetPage(
      name: Routes.INVENTORY,
      page: () => const InventoryView(),
      binding: InventoryBinding(),
    ),
    // Receptionist
    GetPage(
      name: Routes.RECEPTION_HOME,
      page: () => const ReceptionistDashboardView(),
      binding: ReceptionistDashboardBinding(),
    ),
    // Cashier
    GetPage(
      name: Routes.CASHIER_HOME,
      page: () => const CashierDashboardView(),
      binding: CashierDashboardBinding(),
    ),
    // Lab Staff
    GetPage(
      name: Routes.LAB_HOME,
      page: () => const LabDashboardView(),
      binding: LabDashboardBinding(),
    ),
    // Pharmacist
    GetPage(
      name: Routes.PHARMACY_HOME,
      page: () => const PharmacistDashboardView(),
      binding: PharmacistDashboardBinding(),
    ),
    
    // New Workflow Pages
    GetPage(
      name: Routes.DOCTOR_EXAMINE,
      page: () => const ExaminationView(),
      binding: ExaminationBinding(),
    ),
    GetPage(
      name: Routes.RECEPTION_APPOINTMENTS,
      page: () => const ReceptionistAppointmentsView(),
      binding: ReceptionistAppointmentsBinding(),
    ),
    GetPage(
      name: Routes.LAB_ENTER_RESULT,
      page: () => const EnterResultView(),
      binding: LabResultsBinding(),
    ),
    GetPage(
      name: Routes.CASHIER_INVOICES,
      page: () => const InvoiceListView(),
      binding: InvoiceBinding(),
    ),
    GetPage(
      name: Routes.PHARMACY_DISPENSE,
      page: () => const DispenseView(),
      binding: DispenseBinding(),
    ),
    GetPage(
      name: Routes.PATIENT_LAB_RESULTS,
      page: () => const MedicalResultsView(),
      binding: MedicalResultsBinding(),
    ),
    GetPage(
      name: Routes.PATIENT_PRESCRIPTIONS,
      page: () => const PrescriptionView(),
      binding: PrescriptionBinding(),
    ),
    GetPage(
      name: Routes.PATIENT_INVOICES,
      page: () => const PatientInvoiceView(),
      binding: PatientInvoiceBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_ANALYTICS,
      page: () => const AdminAnalyticsView(),
      binding: AdminAnalyticsBinding(),
    ),
    GetPage(
      name: Routes.PATIENT_REVIEWS,
      page: () => const PatientReviewsView(),
      binding: PatientReviewsBinding(),
    ),
    GetPage(
      name: Routes.PATIENT_QUEUE,
      page: () => const QueueStatusView(),
      binding: QueueStatusBinding(),
    ),
    GetPage(
      name: Routes.PATIENT_UPLOAD_DOCS,
      page: () => const UploadDocsView(),
      binding: UploadDocsBinding(),
    ),
    GetPage(
      name: Routes.RECEPTION_QUEUE,
      page: () => const QueueManagementView(),
      binding: QueueManagementBinding(),
    ),
    GetPage(
      name: Routes.RECEPTION_WALKIN,
      page: () => const WalkinBookingView(),
      binding: WalkinBookingBinding(),
    ),
    GetPage(
      name: Routes.DOCTOR_EMR,
      page: () => const EmrHistoryView(),
      binding: EmrHistoryBinding(),
    ),
    GetPage(
      name: Routes.DOCTOR_TELEMEDICINE,
      page: () => const TelemedicineCallView(),
      binding: TelemedicineCallBinding(),
    ),
    GetPage(
      name: Routes.PHARMACY_INVENTORY,
      page: () => const PharmacyInventoryView(),
      binding: PharmacyInventoryBinding(),
    ),
  ];
}
