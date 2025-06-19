class Answer {
  final int answerId;
  final String content;
  final bool isCorrect;

  Answer({
    required this.answerId,
    required this.content,
    this.isCorrect = false,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        answerId: json['id'] as int,
        content: json['content'] as String,
      );
}

class QuestionResult {
  final int questionId;
  final String content;
  final String difficulty;
  final Answer? selectedAnswer;
  final Answer correctAnswer;
  final List<Answer> answers;

  QuestionResult({
    required this.questionId,
    required this.content,
    required this.difficulty,
    this.selectedAnswer,
    required this.correctAnswer,
    required this.answers,
  });

  String get difficultyInVietnamese {
    switch (difficulty.toUpperCase()) {
      case 'EASY':
        return 'Dễ';
      case 'MEDIUM':
        return 'Trung bình';
      case 'HARD':
        return 'Khó';
      default:
        return difficulty;
    }
  }

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    final question = json['question'] as Map<String, dynamic>;
    final answers = (question['answers'] as List)
        .map((a) => Answer.fromJson(a as Map<String, dynamic>))
        .toList();

    print('Processing question ID: ${question['id']}');
    print('Available answer IDs: ${answers.map((a) => a.answerId).toList()}');

    Answer? selected;
    if (json['selectedAnswer'] != null) {
      final selectedId = json['selectedAnswer'] as int;
      print('Selected answer ID: $selectedId');
      try {
        selected = answers.firstWhere(
          (a) => a.answerId == selectedId,
          orElse: () {
            throw Exception(
                'Selected answer ID $selectedId not found in answers for question ${question['id']}');
          },
        );
      } catch (e) {
        print('Error finding selected answer: $e');
        selected = null;
      }
    } else {
      print('No selected answer provided for question ${question['id']}');
    }

    final correctId = json['correctAnswer'] as int;
    print('Correct answer ID: $correctId');
    final correct = answers.firstWhere(
      (a) => a.answerId == correctId,
      orElse: () {
        throw Exception(
            'Correct answer ID $correctId not found in answers for question ${question['id']}');
      },
    );

    return QuestionResult(
      questionId: question['id'] as int,
      content: question['content'] as String,
      difficulty: question['difficulty'] as String,
      selectedAnswer: selected,
      correctAnswer: correct,
      answers: answers,
    );
  }
}

class ResultModel {
  final int participationId;
  final int exerciseId;
  final String exerciseName;
  final double score;
  final String status;
  final DateTime submittedAt;
  final List<QuestionResult> questions;

  ResultModel({
    required this.participationId,
    required this.exerciseId,
    required this.exerciseName,
    required this.score,
    required this.status,
    required this.submittedAt,
    required this.questions,
  });

  String get statusInVietnamese {
    switch (status.toUpperCase()) {
      case 'GRADED':
        return 'Đã chấm điểm';
      case 'SUBMITTED':
        return 'Đã nộp bài';
      case 'IN_PROGRESS':
        return 'Đang làm bài';
      case 'NOT_STARTED':
        return 'Chưa bắt đầu';
      case 'COMPLETED':
        return 'Hoàn thành';
      default:
        return status;
    }
  }

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    print('Parsing ResultModel JSON: $json');
    return ResultModel(
      participationId: json['participationId'] as int,
      exerciseId: json['exerciseId'] as int,
      exerciseName: json['exerciseName'] as String,
      score: (json['score'] as num).toDouble(),
      status: json['status'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      questions: (json['questions'] as List)
          .map((q) => QuestionResult.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}