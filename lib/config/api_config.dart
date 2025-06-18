class ApiConfig {
  static const String baseUrl = 'http://192.168.1.15:8080/api';

  // API configuration for authentication endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String updateStudentDetails = '/auth/students/{userId}/details';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  // Profile endpoints
  static const String getProfile = '/update/me';
  static const String updateProfile = '/update/profile';
}
