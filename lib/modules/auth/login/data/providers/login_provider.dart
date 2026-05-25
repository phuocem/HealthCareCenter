import 'package:supabase_flutter/supabase_flutter.dart';

class LoginProvider {
  final _supabase = Supabase.instance.client;

  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    return await _supabase.from('user_profiles').select().eq('id', userId).maybeSingle();
  }
}
