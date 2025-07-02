import 'package:flutter/material.dart';

class Assignment {
  final int id;
  final int classId;
  final String name;
  final DateTime startAt;
  final DateTime endAt;
  final int durationMinutes;
  final String? status;
  final int questionCount;

  Assignment({
    required this.id,
    required this.classId,
    required this.name,
    required this.startAt,
    required this.endAt,
    required this.durationMinutes,
    required this.status,
    required this.questionCount,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] == null ? 0 : int.tryParse(json['id'].toString()) ?? 0,
      classId: json['classId'] == null ? 0 : int.tryParse(json['classId'].toString()) ?? 0,
      name: json['name'] ?? '',
      startAt: DateTime.parse(json['startAt']),
      endAt: DateTime.parse(json['endAt']),
      durationMinutes: json['durationMinutes'] == null ? 0 : int.tryParse(json['durationMinutes'].toString()) ?? 0,
      status: json['status'],
      questionCount: json['questionCount'] == null ? 0 : int.tryParse(json['questionCount'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classId': classId,
      'name': name,
      'startAt': startAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      'durationMinutes': durationMinutes,
      'status': status,
      'questionCount': questionCount,
    };
  }

  bool get isSubmitted => status == 'SUBMITTED';

  bool get isNotStarted => status == null || status == 'NOT_STARTED' || status == 'pending';

  bool get isInProgress => status == 'IN_PROGRESS';

  bool get isOverdue => DateTime.now().isAfter(endAt);

  bool get isExpired => status == 'EXPIRED' || isOverdue;

  bool get isDisabled => isNotStarted && !isExpired;

  bool get isNotStartedYet => DateTime.now().isBefore(startAt);

  bool get canStart => !isSubmitted && !isOverdue && !isNotStartedYet;

  String get actualStatus {
    if (isOverdue && status != 'SUBMITTED') {
    }
    return status ?? 'NOT_STARTED';
  }

  Color get statusColor {
    final actualStatus = this.actualStatus;
    switch (actualStatus) {
      case 'IN_PROGRESS':
        return Colors.blue;
      case 'SUBMITTED':
        return Colors.green;
      case 'EXPIRED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get statusText {
    final actualStatus = this.actualStatus;
    switch (actualStatus) {
      case 'IN_PROGRESS':
        return 'Đang làm';
      case 'SUBMITTED':
        return 'Đã nộp';
      case 'EXPIRED':
        return 'Quá hạn';
      default:
        return 'Chưa làm';
    }
  }

  String get formattedEndAt {
    return '${endAt.day.toString().padLeft(2, '0')}/${endAt.month.toString().padLeft(2, '0')}/${endAt.year}';
  }
}