class ApiConfig {
  static const String baseUrl = 'http://localhost:8080/api';

  // API configuration for authentication endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';



  // Exercise
  static const String startExam = '/participations/exercises';
  static const String submissionExam = '/participations/exercises/submit';

}
