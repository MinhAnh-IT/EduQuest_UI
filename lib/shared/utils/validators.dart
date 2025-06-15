class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!value.contains('@')) {
      return 'Vui lòng nhập email hợp lệ';
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
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
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
    return null;
  }

  static String? validateEnrolledYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập năm nhập học';
    }
    final year = int.tryParse(value);
    if (year == null || year < 1900 || year > DateTime.now().year) {
      return 'Vui lòng nhập năm hợp lệ';
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
