class Student {
  final int userId;
  final String studentCode;
  final String faculty;
  final int enrolledYear;
  final DateTime birthDate;

  Student({
    required this.userId,
    required this.studentCode,
    required this.faculty,
    required this.enrolledYear,
    required this.birthDate,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      userId: json['userId'],
      studentCode: json['studentCode'],
      faculty: json['faculty'],
      enrolledYear: json['enrolledYear'],
      birthDate: DateTime.parse(json['birthDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'studentCode': studentCode,
      'faculty': faculty,
      'enrolledYear': enrolledYear,
      'birthDate': birthDate.toIso8601String(),
    };
  }

  Student copyWith({
    int? userId,
    String? studentCode,
    String? faculty,
    int? enrolledYear,
    DateTime? birthDate,
  }) {
    return Student(
      userId: userId ?? this.userId,
      studentCode: studentCode ?? this.studentCode,
      faculty: faculty ?? this.faculty,
      enrolledYear: enrolledYear ?? this.enrolledYear,
      birthDate: birthDate ?? this.birthDate,
    );
  }
} 