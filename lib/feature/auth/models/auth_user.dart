class AuthUser {
  final String token;
  final String username;
  final String role;

  AuthUser({
    required this.token,
    required this.username,
    required this.role,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      token: json['token'] as String,
      username: json['username'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'username': username,
      'role': role,
    };
  }
}
