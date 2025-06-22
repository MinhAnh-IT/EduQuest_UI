import 'package:flutter/material.dart';

class Student {
  final int studentId;
  final String studentCode;
  final String studentName;
  final String studentEmail;
  final String enrollmentStatus;
  final String? avatarUrl; // Đổi tên cho đúng với API
  Student({
    required this.studentId,
    required this.studentCode,
    required this.studentName,
    required this.studentEmail,
    required this.enrollmentStatus,
    this.avatarUrl, // Avatar có thể null
  });
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'] as int,
      studentCode: json['studentCode'] as String,
      studentName: json['studentName'] as String,
      studentEmail: json['studentEmail'] as String,
      enrollmentStatus: json['enrollmentStatus'] as String,
      avatarUrl: json['avatarUrl'] as String?, // Đọc avatarUrl từ API, có thể null
    );
  }

  Map<String, dynamic> toJson() {    return {
      'studentId': studentId,
      'studentCode': studentCode,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'enrollmentStatus': enrollmentStatus,
      'avatarUrl': avatarUrl,
    };
  }

  // Helper methods for UI
  String get statusText {
    switch (enrollmentStatus.toUpperCase()) {
      case 'ENROLLED':
        return 'Đã tham gia';
      case 'PENDING':
        return 'Chờ duyệt';
      case 'REJECTED':
        return 'Bị từ chối';
      default:
        return enrollmentStatus;
    }
  }

  Color get statusColor {
    switch (enrollmentStatus.toUpperCase()) {
      case 'ENROLLED':
        return const Color(0xFF4CAF50); // Green
      case 'PENDING':
        return const Color(0xFFFF9800); // Orange
      case 'REJECTED':
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
}
