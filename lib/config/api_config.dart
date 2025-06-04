class ApiConfig {
  // Environment configuration
  static const bool isDevelopment = true;  // Thay đổi khi build production

  // Base URLs
  static const String devBaseUrl = 'http://localhost:8080/api';
  static const String prodBaseUrl = 'https://api.eduquest.com/v1';
  static const String baseUrl = isDevelopment ? devBaseUrl : prodBaseUrl;

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  
  // Student endpoints
  static const String studentDetails = '/students';
  static const String updateStudent = '/students/update';
  
  // Response status codes
  static const int successCode = 200;
  static const int createdCode = 201;
  static const int badRequestCode = 400;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int serverErrorCode = 500;

  // Headers
  static Map<String, String> getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Error messages
  static String getErrorMessage(int statusCode) {
    switch (statusCode) {
      case badRequestCode:
        return 'Yêu cầu không hợp lệ';
      case unauthorizedCode:
        return 'Vui lòng đăng nhập lại';
      case forbiddenCode:
        return 'Bạn không có quyền truy cập';
      case notFoundCode:
        return 'Không tìm thấy tài nguyên';
      case serverErrorCode:
        return 'Lỗi máy chủ, vui lòng thử lại sau';
      default:
        return 'Đã có lỗi xảy ra';
    }
  }
}