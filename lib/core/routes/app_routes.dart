abstract class Routes {
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const PATIENT_HOME = '/patient';
  static const BOOK_BY_DOCTOR = '/book-doctor';
  static const SELECT_DATE = '/select-date';
  static const SELECT_TIME_SLOT = '/select-time';
  static const HISTORY = '/history';

  // Staff home routes
  static const ADMIN_HOME = '/admin';
  static const DOCTOR_HOME = '/doctor';
  static const RECEPTION_HOME = '/reception';
  static const CASHIER_HOME = '/cashier';
  static const LAB_HOME = '/lab';
  static const PHARMACY_HOME = '/pharmacy';

  // Admin management
  static const DOCTOR_MANAGEMENT = '/admin/doctors';
  static const SCHEDULE_MANAGEMENT = '/admin/schedules';
  static const ADD_DOCTOR = '/admin/doctors/add';
  static const ADD_DOCTOR_SCHEDULE = '/admin/doctors/add-schedule';
  static const DEPARTMENTS = '/admin/departments';
  static const SERVICES = '/admin/services';
  static const LAB_TESTS = '/admin/lab-tests';
  static const STAFF_MANAGEMENT = '/admin/staff';
  static const INVENTORY = '/admin/inventory';
  static const SUPPLIERS = '/admin/suppliers';

  // Doctor workflow
  static const DOCTOR_EXAMINE = '/doctor/examine';

  // Receptionist workflow
  static const RECEPTION_APPOINTMENTS = '/reception/appointments';

  // Lab workflow
  static const LAB_ENTER_RESULT = '/lab/results';

  // Cashier workflow
  static const CASHIER_INVOICES = '/cashier/invoices';

  // Pharmacy workflow
  static const PHARMACY_DISPENSE = '/pharmacy/dispense';

  // Patient detail screens
  static const PATIENT_LAB_RESULTS = '/patient/lab-results';
  static const PATIENT_PRESCRIPTIONS = '/patient/prescriptions';
  static const PATIENT_INVOICES = '/patient/invoices';

  // Expanded Features Routes
  static const ADMIN_ANALYTICS = '/admin/analytics';
  static const PATIENT_REVIEWS = '/patient/reviews';
  static const PATIENT_QUEUE = '/patient/queue';
  static const PATIENT_UPLOAD_DOCS = '/patient/upload-docs';
  static const RECEPTION_QUEUE = '/reception/queue';
  static const RECEPTION_WALKIN = '/reception/walkin';
  static const DOCTOR_EMR = '/doctor/emr';
  static const DOCTOR_TELEMEDICINE = '/doctor/telemedicine';
  static const PHARMACY_INVENTORY = '/pharmacy/inventory';
}
