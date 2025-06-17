enum StatusCode {
  notFound(431, "Không tìm thấy %s"),
  ;

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
