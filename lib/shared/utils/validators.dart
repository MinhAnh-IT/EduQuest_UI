class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }

    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );

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
    if (value.length < 8 || value.length > 20) {
      return 'Mã số sinh viên phải từ 8 đến 20 ký tự';
    }
    // Kiểm tra chỉ cho phép số
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