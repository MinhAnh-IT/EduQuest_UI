class OTPVerification {
  final String username;
  final String otp;
  final String? newPassword;

  OTPVerification({
    required this.username,
    required this.otp,
    this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'otp': otp,
    if (newPassword != null) 'newPassword': newPassword,
  };
}