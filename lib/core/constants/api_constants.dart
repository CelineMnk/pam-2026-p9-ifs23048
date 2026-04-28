class ApiConstants {
  static const String baseUrl = 'http://localhost:5000';

  static const String motivations = '$baseUrl/motivations';
  static const String generate = '$baseUrl/motivations/generate';
  static const String login = '$baseUrl/api/auth/login';
  static const String mahasiswa = '$baseUrl/api/mahasiswa/';
  static const String statistik = '$baseUrl/api/mahasiswa/statistik';
  static const String aiAnalisis = '$baseUrl/api/ai/analisis';
  static String aiRekomendasi(String nim) => '$baseUrl/api/ai/rekomendasi/$nim';
}