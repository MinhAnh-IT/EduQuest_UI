import 'package:edu_quest/feature/quiz/models/answer_model.dart';

class QuestionModel {
  final int id;
  final String content;
  final List<AnswerModel> answers;
  
  final String difficulty;

  QuestionModel({
    required this.id,
    required this.content,
    required this.answers,
    required this.difficulty,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      content: json['content'],
      difficulty: json['difficulty'] ?? '',
      answers: (json['answers'] as List<dynamic>?)
          ?.map((a) => AnswerModel.fromJson(a))
          .toList() ?? [],
    );
  }
}
