enum StatusCode {
  ok(200, "Yêu cầu thành công"),
  created(201, "Tạo thành công"),
  notMatch(4002, "Bạn không có quyền nộp bài này!"),
  notIsStudent(4007, "Yêu cầu bạn phải là sinh viên để được tham gia làm bài."),
  notFound(4044, "Không tìm thấy %s"),
  participationAlreadyExists(4204, "Bạn đã nộp bài hoặc hết hạn làm bài tập này."),
  expiredExercise(4205, "Bài tập đã hết hạn nộp"),
  participationIsSubmitted(4200, "Bài tập đã được nộp")
    
  OK(200, "Success."),  PASSWORD_RESET_SUCCESS(200, "Password reset successful."),
  LOGOUT_SUCCESS(200, "Logged out successfully."),
  OTP_VERIFIED_SUCCESS(200, "OTP verified successfully. You can now reset your password."),
  JOIN_CLASS_SUCCESS(200, "Successfully joined class"),
  LEAVE_CLASS_SUCCESS(200, "Successfully left class"),
  BAD_REQUEST(400, "Bad Request."),
  INVALID_OTP(400, "Invalid or expired OTP."),
  OTP_VERIFICATION_NEEDED(400, "OTP must be verified before password can be reset, or the session has expired."),
  INVALID_TOKEN(401, "Invalid or expired token."),
  USER_NOT_A_STUDENT(403, "Only students can perform this action."),
  NOT_FOUND(404, "Not Found."),
  USER_NOT_FOUND(404, "User not found."),
  CLASS_NOT_FOUND_BY_CODE(404, "Class not found with the provided code"),
  CLASS_NOT_FOUND_BY_ID(404, "Class not found with the provided ID"),
  STUDENT_NOT_ENROLLED_IN_CLASS(404, "Student is not enrolled in this class"),
  STUDENT_ALREADY_ENROLLED_IN_CLASS(409, "Student is already enrolled in this class"),
  EMAIL_SEND_ERROR(500, "Failed to send email."),
  INTERNAL_SERVER_ERROR(500, "Internal Server Error.");;

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
