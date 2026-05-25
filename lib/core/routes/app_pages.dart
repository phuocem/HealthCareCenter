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
  ];
}
