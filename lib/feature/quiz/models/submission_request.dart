import 'package:edu_quest/feature/quiz/models/answer_selected.dart';

class SubmissionRequest {
  final int participationId;
  final List<AnswerSelected> selectedAnswers;

  SubmissionRequest({
    required this.participationId,
    required this.selectedAnswers
  });

  Map<String, dynamic> toJson(){
    return {
      'participationId':participationId,
      'selectedAnswers':  selectedAnswers.map((e) => e.toJson()).toList() 
    };
  }
}