// filepath: c:\Users\Admin\Downloads\CNPM\EduQuest_UI\lib\core\enums\status_code.dart
enum StatusCode {
  OK(200, "Success."),
  PASSWORD_RESET_SUCCESS(200, "Password reset successful."),
  LOGOUT_SUCCESS(200, "Logged out successfully."),
  OTP_VERIFIED_SUCCESS(200, "OTP verified successfully. You can now reset your password."),
  BAD_REQUEST(400, "Bad Request."),
  INVALID_OTP(400, "Invalid or expired OTP."),
  OTP_VERIFICATION_NEEDED(400, "OTP must be verified before password can be reset, or the session has expired."),
  INVALID_TOKEN(401, "Invalid or expired token."),
  NOT_FOUND(404, "Not Found."),
  USER_NOT_FOUND(404, "User not found."),
  EMAIL_SEND_ERROR(500, "Failed to send email."),
  INTERNAL_SERVER_ERROR(500, "Internal Server Error.");

  const StatusCode(this.code, this.message);
  final int code;
  final String message;

  static StatusCode fromCode(int code, {String? responseMessage}) {
    // Handle specific cases for code 200 based on message
    if (code == 200) {
      if (responseMessage == "Password reset successful") return StatusCode.PASSWORD_RESET_SUCCESS;
      if (responseMessage == "Logged out successfully") return StatusCode.LOGOUT_SUCCESS;
      if (responseMessage == "OTP verified successfully. You can now reset your password.") return StatusCode.OTP_VERIFIED_SUCCESS;
      // Fallback for generic 200 OK if message doesn't match specific success types
      // This assumes a generic "OK" might also be possible for 200.
      // If not, this part might need adjustment based on actual API behavior.
      return values.firstWhere((e) => e.code == code && e.message == "Success.", orElse: () => StatusCode.OK);
    }
    // For other codes, find the first match.
    // This assumes non-200 codes don't have message-dependent variations.
    try {
      return values.firstWhere((e) => e.code == code);
    } catch (e) {
      // Fallback for unknown codes
      print('Unknown status code: $code, message: $responseMessage');
      return StatusCode.INTERNAL_SERVER_ERROR; // Or throw an error
    }
  }
}
