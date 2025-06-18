import 'package:flutter/material.dart';
import 'package:register_login/feature/quiz/models/question_waper.dart';

class QuestionWidget extends StatelessWidget {
  final QuestionWrapper questionWrapper;
  final int? selectedAnswerId;
  final void Function(int) onAnswerSelected;
  final int? questionIndex;

  const QuestionWidget({
    super.key,
    required this.questionWrapper,
    required this.selectedAnswerId,
    required this.onAnswerSelected,
    required this.questionIndex
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
                "Câu $questionIndex: ${questionWrapper.question.content}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5,
                    ),
              ),
            ),
            ...questionWrapper.question.answers.map(
              (answer) => InkWell(
                onTap: () => onAnswerSelected(answer.id),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<int>(
                        value: answer.id,
                        groupValue: selectedAnswerId,
                        onChanged: (val) => onAnswerSelected(val!),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      ),
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
}