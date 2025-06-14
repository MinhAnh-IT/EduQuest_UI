import 'package:flutter/material.dart';

class AppColors {
  static final primary = Colors.blue;
  static final background = Colors.grey[100];
  static final text = Colors.grey[800];
  static final textLight = Colors.grey[600];
  static final success = Colors.green;
  static final error = Colors.red;
}

class AppStyles {
  static final headingStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static final bodyStyle = TextStyle(
    fontSize: 16,
    color: AppColors.textLight,
    height: 1.4,
  );

  static final linkStyle = TextStyle(
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
  );
}

class AppStrings {
  // Forgot Password Screen
  static const forgotPasswordTitle = 'Forgot Password';
  static const enterUsername = 'Enter your username and we will send you an OTP code';
  static const sendOTP = 'Send OTP';
  static const rememberPassword = 'Remember password? ';
  static const backToLogin = 'Back to Login';

  // OTP Verification Screen
  static const otpVerificationTitle = 'OTP Verification';
  static const enterVerificationCode = 'Enter Verification Code';
  static const verifyOTP = 'Verify OTP';
  static const resendOTP = 'Resend OTP';
  static const didntReceiveCode = 'Didn\'t receive the code? ';
  static const changeUsername = 'Change username';
  static const enterOTPMessage = 'We\'ve sent a 6-digit verification code for username:';
  static const resendCodeTimer = 'Resend code in: ';

  // Reset Password Screen
  static const resetPasswordTitle = 'Reset Password';
  static const createNewPassword = 'Create New Password';
  static const newPasswordHint = 'Your new password must be different from your previous password';
  static const passwordRequirements = 'Password Requirements:';
}

/// Các hằng số cho việc lưu trữ local
class StorageConstants {
  static const String token = 'token';
  static const String user = 'user';
  static const String theme = 'theme';
  static const String language = 'language';
  static const String onboarding = 'onboarding';
}

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