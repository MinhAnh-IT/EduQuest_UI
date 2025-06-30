import '../../../feature/quiz/models/question_model.dart';

class QuestionWrapper {
  final int exerciseQuestionId;
  final QuestionModel question;

  QuestionWrapper({
    required this.exerciseQuestionId,
    required this.question,
  });

  factory QuestionWrapper.fromJson(Map<String, dynamic> json) {
    return QuestionWrapper(
      exerciseQuestionId: json['exerciseQuestionId'],
      question: QuestionModel.fromJson(json['question']),
    );
  }
}
