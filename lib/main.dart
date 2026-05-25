import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/services/supabase_service.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  await SupabaseService.init();
  
  String initialRoute = AppPages.INITIAL;
  final session = Supabase.instance.client.auth.currentSession;
  
  if (session != null) {
    try {
      final userId = session.user.id;
      final profile = await Supabase.instance.client
          .from('user_profiles')
          .select('role')
          .eq('id', userId)
          .single();
          
      final role = profile['role'];
      if (role == 'admin') {
        initialRoute = Routes.ADMIN_HOME;
      } else if (role == 'doctor') {
        initialRoute = Routes.DOCTOR_HOME;
      } else {
        initialRoute = Routes.PATIENT_HOME;
      }
    } catch (e) {
      initialRoute = AppPages.INITIAL;
    }
  }
  
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HealthX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}
