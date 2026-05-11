/// API Configuration for CampusConnect .NET Backend
///
/// 🖥️  Running on Android Emulator?  → use 10.0.2.2  (maps to your PC's localhost)
/// 📱  Running on Physical Device?   → use your PC's local IP  e.g. 192.168.1.x
/// 🌐  Running on Web / Desktop?     → use localhost
class ApiConstants {
  // ─── Base URL ────────────────────────────────────────────────────────────────
  /// Change this to your PC's local IP when running on a real device.
  /// The .NET API runs on http://localhost:5205 (see launchSettings.json)
  static const String _androidEmulatorHost = '10.0.2.2';
  static const String _localHost = '192.168.1.6';
  static const int _port = 5205;

  /// ✅ Physical device on same WiFi → uses PC local IP (192.168.1.6)
  /// ✅ Android Emulator → change to _androidEmulatorHost (10.0.2.2)
  /// ✅ Web/Windows app → change to 'localhost'
  static const String baseUrl = 'http://$_localHost:$_port/api';

  // ─── Auth Endpoints ───────────────────────────────────────────────────────
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';

  // ─── Student Endpoints ────────────────────────────────────────────────────
  static const String students = '$baseUrl/student';
  static const String studentProfileMe = '$baseUrl/student/profile/me';

  // ─── Course Endpoints ─────────────────────────────────────────────────────
  static const String courses = '$baseUrl/course';

  // ─── Quiz Endpoints ───────────────────────────────────────────────────────
  static const String quizzes = '$baseUrl/quiz';



  // ─── Forum Endpoints ──────────────────────────────────────────────────────
  static const String forums = '$baseUrl/forum';

  // ─── Attendance Endpoints ─────────────────────────────────────────────────
  static const String attendance = '$baseUrl/attendance';

  // ─── Local Storage Keys ────────────────────────────────────────────────────
  static const String tokenKey = 'jwt_token';
}
