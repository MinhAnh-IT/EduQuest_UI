import 'dart:io';

class ApiConfig {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://192.168.1.15:8080/api';
    }
    return 'http://localhost:8080/api';
  }
  
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String updateStudentDetails = '/auth/students/{userId}/details';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String getProfile = '/Profile/me';
  static const String updateProfile = '/update/profile';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtpForgotPassword = '/auth/verify-otp-forgot-password';
  static const String logout = '/auth/logout';  
  static const String joinClass = '/enrollments/join';
  static const String leaveClass = '/enrollments/leave';
  static const String myClasses = '/enrollments/my-classes';
  static const String myEnrolledClasses = '/enrollments/my-enrolled-classes';
  
  // Exercise
  static const String startExam = '/participations/exercises';
  static const String submissionExam = '/participations/exercises/submit';
  static const String getExercisesForStudent = '/exam/exercises';
  // Result
  static const String getResultByExerciseId = '/results';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

