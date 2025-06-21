import '../enums/status_code.dart';

class ErrorMessageResolver {
  static String resolve(int code, [String? fallback]) {
    final status = StatusCode.fromCode(code);
    if (status != null) {
      return status.message;
    }
    return fallback ?? "Đã xảy ra lỗi không xác định.";
  }
}
