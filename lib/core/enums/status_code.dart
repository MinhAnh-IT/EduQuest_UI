enum StatusCode {
  ok(200, "Thành công"),
  badRequest(400, "Yêu cầu không hợp lệ"),
  invalidOtp(400, "OTP không đúng hoặc đã hết hạn"),
  otpVerificationNeeded(400, "OTP cần được xác minh trước khi đặt lại mật khẩu"),
  classCodeRequired(401, "Mã lớp học là bắt buộc"),
  invalidToken(401, "Token không hợp lệ hoặc đã hết hạn"),
  authenticationRequired(402, "Yêu cầu đăng nhập"),
  invalidOtpForgot(403, "OTP không hợp lệ"),
  notFound(404, "Không tìm thấy %s"),
  otpVerificationNeededReset(404, "Cần xác minh OTP"),
  userNotAStudent(405, "Người dùng không phải sinh viên"),
  classNotFoundByCode(406, "Không tìm thấy lớp học với mã này"),
  classNotFoundById(407, "Không tìm thấy lớp học với ID này"),
  studentNotEnrolledInClass(408, "Sinh viên chưa tham gia lớp học này"),
  studentAlreadyEnrolledInClass(409, "Sinh viên đã tham gia lớp học này"),
  userNotFound(430, "Không tìm thấy người dùng"),
  validationError(450, "Lỗi xác thực dữ liệu"),
  internalServerError(500, "Lỗi máy chủ nội bộ"),
  emailSendError(501, "Gửi email thất bại");

  final int code;
  final String message;

  const StatusCode(this.code, this.message);

  String formatMessage([String? param]) {
    if (param == null) return message;
    return message.replaceFirst("%s", param);
  }

  static StatusCode? fromCode(int code) {
    try {
      return StatusCode.values.firstWhere((e) => e.code == code);
    } catch (e) {
      return null;
    }
  }
}
