import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';

class ApiService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── AUTH ──────────────────────────────────────────────────
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      await saveToken(data['token']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(data['user']));
    }
    return {'statusCode': res.statusCode, ...data};
  }

  static Future<Map<String, dynamic>?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('user_data');
    if (raw == null) return null;
    return jsonDecode(raw);
  }

  // ── MAHASISWA ─────────────────────────────────────────────
  static Future<Map<String, dynamic>> getMahasiswa() async {
    final res = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/mahasiswa/'),
      headers: await _authHeaders(),
    );
    return {'statusCode': res.statusCode, ...jsonDecode(res.body)};
  }

  static Future<Map<String, dynamic>> getStatistik() async {
    final res = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/mahasiswa/statistik'),
      headers: await _authHeaders(),
    );
    return {'statusCode': res.statusCode, ...jsonDecode(res.body)};
  }

  // ── AI ────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> getAiAnalisis() async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/api/ai/analisis'),
      headers: await _authHeaders(),
    );
    return {'statusCode': res.statusCode, ...jsonDecode(res.body)};
  }

  static Future<Map<String, dynamic>> getAiRekomendasi(String nim) async {
    final res = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/ai/rekomendasi/$nim'),
      headers: await _authHeaders(),
    );
    return {'statusCode': res.statusCode, ...jsonDecode(res.body)};
  }
}