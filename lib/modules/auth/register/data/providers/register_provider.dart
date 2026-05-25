import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterProvider {
  final _supabase = Supabase.instance.client;

  Future<AuthResponse> signUp(String email, String password, String fullName) async {
    
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
    
    return response;
  }
}
