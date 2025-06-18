enum StatusCode {
  ok(200, "Yêu cầu thành công"),
  created(201, "Tạo thành công"),
  notMatch(4002, "Bạn không có quyền nộp bài này!"),
  notIsStudent(4007, "Yêu cầu bạn phải là sinh viên để được tham gia làm bài."),
  notFound(4044, "Không tìm thấy %s"),
  participationAlreadyExists(4204, "Bạn đã nộp bài hoặc hết hạn làm bài tập này."),
  expiredExercise(4205, "Bài tập đã hết hạn nộp"),
  participationIsSubmitted(4200, "Bài tập đã được nộp"),
  unknown(50001, "Unknown error occurred."),
  inValidToken(401, "Invalid or expired token."),
  internalServerError(500, "Internal Server Error.");

  final int code;
  final String message;

  const StatusCode(this.code, this.message);

  String formatMessage([String? param]) {
    if (param == null) return message;
    return message.replaceFirst("%s", param);
  }

  static StatusCode? fromCode(int code, {required String responseMessage}) {
    try {
      return StatusCode.values.firstWhere((e) => e.code == code);
    } catch (e) {
      return null;
    }
  }

}
