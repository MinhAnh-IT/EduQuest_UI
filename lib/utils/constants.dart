class ApiConstants {
  static const String baseUrl = 'https://api.eduquest.com';
  static const String apiVersion = '/v1';
  static const String baseApiUrl = baseUrl + apiVersion;

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
}

class StorageConstants {
  static const String token = 'token';
  static const String user = 'user';
  static const String theme = 'theme';
  static const String language = 'language';
  static const String onboarding = 'onboarding';
}

class ValidationConstants {
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 32;
  static const int otpLength = 6;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
}

class AppConstants {
  static const String appName = 'EduQuest';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String supportEmail = 'support@eduquest.com';
  
  // Thời gian chờ
  static const int otpTimeoutSeconds = 60;
  static const int apiTimeoutSeconds = 30;
  static const int splashScreenDurationSeconds = 2;
  
  // Giới hạn
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;
} 