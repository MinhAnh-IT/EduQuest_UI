import 'package:register_login/feature/auth/models/user_model.dart';

class ProfileModel {
  final int? id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String name;
  final UserRole role;
  final String? studentCode;

  ProfileModel({
    this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.name,
    required this.role,
    this.studentCode,
  });


  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
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


  Map<String, dynamic> toUpdateRequest() {
    return {
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }

  // Method tạo JSON đầy đủ
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'name': name,
      'role': role.toString().split('.').last,
      'studentCode': studentCode,
    };
  }


  ProfileModel copyWith({
    int? id,
    String? username,
    String? email,
    String? avatarUrl,
    String? name,
    UserRole? role,
    String? studentCode,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      name: name ?? this.name,
      role: role ?? this.role,
      studentCode: studentCode ?? this.studentCode,
    );
  }


  factory ProfileModel.fromUser(User user, {String? studentCode}) {
    return ProfileModel(
      id: user.id,
      username: user.username,
      email: user.email ?? '',
      avatarUrl: user.avatarUrl,
      name: user.name,
      role: user.role,
      studentCode: studentCode,
    );
  }
}