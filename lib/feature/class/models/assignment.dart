import 'package:flutter/material.dart';

class Assignment {
  final int id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String status; // 'pending', 'submitted', 'graded'
  final String? grade;
  final DateTime createdAt;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.grade,
    required this.createdAt,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: json['status'] as String,
      grade: json['grade'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'grade': grade,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Helper methods
  bool get isOverdue => DateTime.now().isAfter(dueDate) && status == 'pending';
  bool get isSubmitted => status == 'submitted' || status == 'graded';
  
  Color get statusColor {
    switch (status) {
      case 'submitted':
        return Colors.blue;
      case 'graded':
        return grade != null ? Colors.green : Colors.orange;
      case 'pending':
        return isOverdue ? Colors.red : Colors.orange;
      default:
        return Colors.grey;
    }
  }
  String get statusText {
    switch (status) {
      case 'submitted':
        return 'Đã nộp';
      case 'graded':
        return 'Đã chấm điểm';
      case 'pending':
        return isOverdue ? 'Quá hạn' : 'Chưa nộp';
      default:
        return 'Không xác định';
    }
  }

  String get formattedDueDate {
    return '${dueDate.day.toString().padLeft(2, '0')}/${dueDate.month.toString().padLeft(2, '0')}/${dueDate.year}';
  }
}
