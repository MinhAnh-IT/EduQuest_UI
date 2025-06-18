class Enrollment {
  final int enrollmentId;
  final int studentId;
  final String studentName;
  final int classId;
  final String className;
  final String enrollmentDate;
  final String message;

  Enrollment({
    required this.enrollmentId,
    required this.studentId,
    required this.studentName,
    required this.classId,
    required this.className,
    required this.enrollmentDate,
    required this.message,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      enrollmentId: json['enrollmentId'] as int,
      studentId: json['studentId'] as int,
      studentName: json['studentName'] as String,
      classId: json['classId'] as int,
      className: json['className'] as String,
      enrollmentDate: json['enrollmentDate'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enrollmentId': enrollmentId,
      'studentId': studentId,
      'studentName': studentName,
      'classId': classId,
      'className': className,
      'enrollmentDate': enrollmentDate,
      'message': message,
    };
  }
}
