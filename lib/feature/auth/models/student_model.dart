class Student {
  final int userId;
  final String studentCode;

  Student({
    required this.userId,
    required this.studentCode,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      userId: json['userId'],
      studentCode: json['studentCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'studentCode': studentCode,
    };
  }

  Student copyWith({
    int? userId,
    String? studentCode,
  }) {
    return Student(
      userId: userId ?? this.userId,
      studentCode: studentCode ?? this.studentCode,
    );
  }
} 