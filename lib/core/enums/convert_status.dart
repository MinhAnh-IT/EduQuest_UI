enum ConvertStatus {
  //ignore: constant_identifier_names
  SUBMITTED('Đã nộp'),
  //ignore: constant_identifier_names
  IN_PROGRESS('Đang xử lý'),
  
  // Error message translations
  //ignore: constant_identifier_names
  USER_NOT_STUDENT('Chỉ sinh viên mới có thể tham gia lớp học'),
  //ignore: constant_identifier_names
  INVALID_CREDENTIALS('Thông tin đăng nhập không chính xác'),
  //ignore: constant_identifier_names
  USER_NOT_FOUND('Không tìm thấy người dùng'),
  //ignore: constant_identifier_names
  CLASS_NOT_FOUND('Không tìm thấy lớp học'),
  //ignore: constant_identifier_names
  INVALID_OTP('OTP không đúng hoặc đã hết hạn'),
  //ignore: constant_identifier_names
  CLASS_CODE_REQUIRED('Mã lớp học là bắt buộc'),
  //ignore: constant_identifier_names
  ALREADY_ENROLLED('Bạn đã tham gia lớp học này rồi'),
  //ignore: constant_identifier_names
  NOT_ENROLLED('Bạn chưa tham gia lớp học này'),
  //ignore: constant_identifier_names
  AUTHENTICATION_REQUIRED('Yêu cầu đăng nhập'),
  //ignore: constant_identifier_names
  INVALID_TOKEN('Token không hợp lệ hoặc đã hết hạn'),
  //ignore: constant_identifier_names
  NETWORK_ERROR('Lỗi kết nối mạng'),
  //ignore: constant_identifier_names
  INTERNAL_SERVER_ERROR('Lỗi máy chủ nội bộ'),
  //ignore: constant_identifier_names
  VALIDATION_ERROR('Lỗi xác thực dữ liệu'),
  //ignore: constant_identifier_names
  EMAIL_SEND_ERROR('Gửi email thất bại'),
  //ignore: constant_identifier_names
  UNKNOWN_ERROR('Đã xảy ra lỗi không mong muốn');

  final String message;
  const ConvertStatus(this.message);

  static String? getMessage(String name) {
    try {
      return ConvertStatus.values
          .firstWhere((e) => e.name == name)
          .message;
    } catch (e) {
      return null;
    }
  }

  /// Translates English error messages to Vietnamese
  /// Maps common backend error messages to Vietnamese equivalents
  static String translateErrorMessage(String englishMessage) {
    final lowerMessage = englishMessage.toLowerCase();
    
    if (lowerMessage.contains('user is not a student')) {
      return ConvertStatus.USER_NOT_STUDENT.message;
    } else if (lowerMessage.contains('invalid credentials')) {
      return ConvertStatus.INVALID_CREDENTIALS.message;
    } else if (lowerMessage.contains('user not found')) {
      return ConvertStatus.USER_NOT_FOUND.message;
    } else if (lowerMessage.contains('class not found')) {
      return ConvertStatus.CLASS_NOT_FOUND.message;
    } else if (lowerMessage.contains('invalid') && lowerMessage.contains('otp')) {
      return ConvertStatus.INVALID_OTP.message;
    } else if (lowerMessage.contains('expired') && lowerMessage.contains('otp')) {
      return ConvertStatus.INVALID_OTP.message;
    } else if (lowerMessage.contains('class code') && lowerMessage.contains('required')) {
      return ConvertStatus.CLASS_CODE_REQUIRED.message;
    } else if (lowerMessage.contains('already enrolled')) {
      return ConvertStatus.ALREADY_ENROLLED.message;
    } else if (lowerMessage.contains('not enrolled')) {
      return ConvertStatus.NOT_ENROLLED.message;
    } else if (lowerMessage.contains('authentication required')) {
      return ConvertStatus.AUTHENTICATION_REQUIRED.message;
    } else if (lowerMessage.contains('invalid') && lowerMessage.contains('token')) {
      return ConvertStatus.INVALID_TOKEN.message;
    } else if (lowerMessage.contains('expired') && lowerMessage.contains('token')) {
      return ConvertStatus.INVALID_TOKEN.message;
    } else if (lowerMessage.contains('network error')) {
      return ConvertStatus.NETWORK_ERROR.message;
    } else if (lowerMessage.contains('internal server error')) {
      return ConvertStatus.INTERNAL_SERVER_ERROR.message;
    } else if (lowerMessage.contains('validation error')) {
      return ConvertStatus.VALIDATION_ERROR.message;
    } else if (lowerMessage.contains('failed to send email')) {
      return ConvertStatus.EMAIL_SEND_ERROR.message;
    } else if (lowerMessage.contains('an error occurred')) {
      return ConvertStatus.UNKNOWN_ERROR.message;
    }
    
    // Return original message if no translation found
    return englishMessage;
  }
}