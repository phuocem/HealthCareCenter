import '../providers/login_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginRepository {
  final LoginProvider _provider = LoginProvider();

  Future<AuthResponse> login(String email, String password) async {
    return await _provider.signIn(email, password);
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    return await _provider.fetchUserProfile(userId);
  }
}
