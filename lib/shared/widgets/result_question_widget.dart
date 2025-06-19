import 'package:flutter/material.dart';
import '../../feature/result/models/result_model.dart';

class ResultQuestionWidget extends StatelessWidget {
  final QuestionResult question;
  final int questionIndex;

  const ResultQuestionWidget({
    super.key,
    required this.question,
    required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Câu $questionIndex: ${question.content}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5,
                    ),
              ),
            ),
            ...question.answers.map(
              (answer) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getAnswerBackgroundColor(answer),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (answer.answerId == question.correctAnswer.answerId)
                        const Icon(Icons.check, color: Colors.green, size: 22),
                      if (question.selectedAnswer != null &&
                          answer.answerId == question.selectedAnswer!.answerId &&
                          answer.answerId != question.correctAnswer.answerId)
                        const Icon(Icons.close, color: Colors.red, size: 22),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          answer.content,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _getAnswerBackgroundColor(Answer answer) {
    final selected = question.selectedAnswer;
    final correct = question.correctAnswer;

    if (selected != null && selected.answerId == answer.answerId) {
      return selected.answerId == correct.answerId
          ? Colors.green[100] // Đáp án chọn đúng: nền xanh
          : Colors.red[100]; // Đáp án chọn sai: nền đỏ
    }
    return null; // Đáp án không được chọn: không có nền
  }
}