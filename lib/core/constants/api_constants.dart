class ApiConstants {
  static const String baseUrl = 'http://localhost:5000';

  // Motivation endpoints (dari fitur sebelumnya)
  static const String motivations = '$baseUrl/api/motivations';
  static const String generate = '$baseUrl/api/motivations/generate';

  // Auth
  static const String login = '$baseUrl/api/auth/login';

  // Mahasiswa
  static const String mahasiswa = '$baseUrl/api/mahasiswa/';
  static const String statistik = '$baseUrl/api/mahasiswa/statistik';

  // AI
  static const String aiAnalisis = '$baseUrl/api/ai/analisis';
  static String aiRekomendasi(String nim) => '$baseUrl/api/ai/rekomendasi/$nim';
}