class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ. Ví dụ: example@gmail.com';
    }

    final commonDomains = ['gmail.com'];
    final domain = value.split('@')[1];
    if (!commonDomains.contains(domain)) {
      return 'Email phải có domain hợp lệ (gmail.com)';
    }

    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên người dùng';
    }
    if (value.length < 3) {
      return 'Tên người dùng phải có ít nhất 3 ký tự ';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Tên người dùng chỉ có thể chứa chữ cái, số và dấu gạch dưới';
    }
    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập OTP';
    }
    if (value.length != 6) {
      return 'OTP phải có 6 chữ số';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP chỉ có thể chứa chữ số';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    final regex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    if (!regex.hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường, 1 số, 1 ký tự đặc biệt và tối thiểu 8 ký tự';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    if (value != password) {
      return 'Mật khẩu không khớp';
    }
    return null;
  }

  static String? validateStudentCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mã số sinh viên';
    }
    if (value.length < 8 || value.length > 20) {
      return 'Mã số sinh viên phải từ 8 đến 20 ký tự';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Mã số sinh viên chỉ được chứa số';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }
    return null;
  }
}
