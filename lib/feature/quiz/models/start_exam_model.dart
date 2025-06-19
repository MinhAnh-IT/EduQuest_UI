import 'package:edu_quest/feature/quiz/models/question_waper.dart';

class StartExamModel {
  final int participationId;
  final int exerciseId;
  final int studentId;
  final DateTime startAt;
  final String status;
  final int durationMinutes;
  final List<QuestionWrapper> questionWappers;
  
  StartExamModel({
    required this.durationMinutes,
    required this.participationId,
    required this.exerciseId,
    required this.studentId,
    required this.startAt, 
    required this.status,
    required this.questionWappers 
  });



  factory StartExamModel.fromJson(Map<String, dynamic> json){
    return StartExamModel(
      durationMinutes: json['durationMinutes'], 
      participationId: json['participationId'], 
      exerciseId: json['exerciseId'], 
      studentId: json['studentId'], 
      startAt: DateTime.parse(json['startAt']), 
      questionWappers: (json['questions'] as List<dynamic>)
          .map((e) => QuestionWrapper.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status']
    );
  }
}