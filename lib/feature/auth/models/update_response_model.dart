import 'package:register_login/feature/auth/models/user_model.dart';

class UpdateResponse {
  final int? id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String name;
  final UserRole role;
  final String? studentCode;

  UpdateResponse({
    this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.name,
    required this.role,
    this.studentCode,
  });

  factory UpdateResponse.fromJson(Map<String, dynamic> json) {
    return UpdateResponse(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      name: json['name'],
      role: UserRole.values.firstWhere(
            (role) => role.toString() == 'UserRole.${json['role']}',
      ),
      studentCode: json['studentCode'],
    );
  }
}