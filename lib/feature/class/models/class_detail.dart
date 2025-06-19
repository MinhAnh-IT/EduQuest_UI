import 'assignment.dart';

class ClassDetail {
  final int id;
  final String name;
  final String code;
  final String description;
  final String instructorName;
  final String instructorEmail;
  final int studentCount;
  final DateTime createdAt;
  final List<Assignment> assignments;

  ClassDetail({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.instructorName,
    required this.instructorEmail,
    required this.studentCount,
    required this.createdAt,
    required this.assignments,
  });

  factory ClassDetail.fromJson(Map<String, dynamic> json) {
    return ClassDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String? ?? '',
      instructorName: json['instructorName'] as String,
      instructorEmail: json['instructorEmail'] as String,
      studentCount: json['studentCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      assignments: (json['assignments'] as List<dynamic>?)
          ?.map((assignment) => Assignment.fromJson(assignment))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'instructorName': instructorName,
      'instructorEmail': instructorEmail,
      'studentCount': studentCount,
      'createdAt': createdAt.toIso8601String(),
      'assignments': assignments.map((assignment) => assignment.toJson()).toList(),
    };
  }

  // Helper methods
  int get pendingAssignmentsCount => 
      assignments.where((assignment) => assignment.status == 'pending').length;
  
  int get overdueAssignmentsCount => 
      assignments.where((assignment) => assignment.isOverdue).length;
      
  int get submittedAssignmentsCount => 
      assignments.where((assignment) => assignment.isSubmitted).length;
}
