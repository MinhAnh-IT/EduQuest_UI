/// Các hằng số cho việc lưu trữ local
class StorageConstants {
  static const String token = 'token';
  static const String user = 'user';
  static const String theme = 'theme';
  static const String language = 'language';
  static const String onboarding = 'onboarding';
}

/// Các hằng số cho validation
class ValidationConstants {
  // Mật khẩu
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 32;
  
  // OTP
  static const int otpLength = 6;
  static const int otpTimeoutSeconds = 60;
  
  // Username
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  
  // Email
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
}

/// Các hằng số cho ứng dụng
class AppConstants {
  // Thông tin app
  static const String appName = 'EduQuest';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String supportEmail = 'support@eduquest.com';
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration splashScreenDuration = Duration(seconds: 2);
  
  // Upload limits
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;
  
  // Error messages
  static const String networkError = 'Không thể kết nối đến server';
  static const String unknownError = 'Đã có lỗi xảy ra';
  static const String sessionExpired = 'Phiên đăng nhập đã hết hạn';
}

/// Các hằng số cho animation
class AnimationConstants {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}

/// Các hằng số cho kích thước UI
class UiConstants {
  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  
  // Border radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 16.0;
  
  // Icon sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
}