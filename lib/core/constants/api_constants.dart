import 'api_env.dart';

class ApiConstants {
  ApiConstants._();

  /// Central API base URL for the entire app.
  /// Override at run/build time with:
  ///   flutter run --dart-define=API_BASE_URL=http://<host>:3000/api/v1
  /// Otherwise uses ApiEnv.host (auto-updated by START_PARABDI_DEV.ps1).
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://${ApiEnv.host}:3000/api/v1',
  );
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String googleAuth = '/auth/google';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';
  static const String fcmToken = '/auth/fcm-token';

  // Shorts
  static const String shorts = '/shorts';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationsReadAll = '/notifications/read-all';
}
