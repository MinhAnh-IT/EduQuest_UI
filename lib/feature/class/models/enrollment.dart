class Enrollment {
  final int enrollmentId;
  final int studentId;
  final int classId;
  final String className;
  final String instructorName;
  final String status;

  Enrollment({
    required this.enrollmentId,
    required this.studentId,
    required this.classId,
    required this.className,
    required this.instructorName,
    required this.status,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      enrollmentId: json['enrollmentId'] as int,
      studentId: json['studentId'] as int,
      classId: json['classId'] as int,
      className: json['className'] as String,
      instructorName: json['instructorName'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enrollmentId': enrollmentId,
      'studentId': studentId,
      'classId': classId,
      'className': className,
      'instructorName': instructorName,
      'status': status,
    };
  }
}
