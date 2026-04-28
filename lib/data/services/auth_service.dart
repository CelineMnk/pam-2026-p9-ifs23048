import 'api_service.dart';

class AuthService {
  static Future<bool> isLoggedIn() async {
    final token = await ApiService.getToken();
    return token != null;
  }

  static Future<void> logout() async {
    await ApiService.clearAll();
  }
}