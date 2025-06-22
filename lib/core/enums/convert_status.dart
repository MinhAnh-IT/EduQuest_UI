enum ConvertStatus {
  SUBMITTED('Đã nộp'),
  IN_PROGRESS('Đang xử lý');

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
}