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
