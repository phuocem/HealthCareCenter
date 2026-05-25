import '../providers/register_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterRepository {
  final RegisterProvider _provider = RegisterProvider();

  Future<AuthResponse> register(String email, String password, String fullName) async {
    return await _provider.signUp(email, password, fullName);
  }
}
