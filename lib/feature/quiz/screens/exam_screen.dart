import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/exam_app_bar.dart';
import '../providers/quiz_provider.dart';
import '../../../shared/widgets/question_widget.dart';

class ExamScreen extends StatefulWidget {
  final int exerciseId;
  const ExamScreen({Key? key, required this.exerciseId}
  ) : super(key: key);

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  String? lastShownError;

  void _showErrorFlushbar(BuildContext context, String message) {
    Flushbar(
      titleText: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red.withValues(alpha: 0.12),
            radius: 16,
            child: const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            "Lỗi",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: Colors.grey[900],
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      borderRadius: BorderRadius.circular(16),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
      flushbarPosition: FlushbarPosition.TOP,
      leftBarIndicatorColor: Colors.redAccent,
      duration: const Duration(seconds: 1),
    ).show(context);
  }

  Widget _buildBody(BuildContext context, QuizProvider quizProvider) {
    if (quizProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (quizProvider.questionWrappers.isEmpty) {
      return const Center(child: Text("Không có câu hỏi nào"));
    }

    final answeredCount =
        quizProvider.selectedAnswers.where((e) => e != null).length;
    final totalQuestions = quizProvider.questionWrappers.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              '$answeredCount/$totalQuestions câu',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: totalQuestions > 0 ? answeredCount / totalQuestions : 0,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: totalQuestions,
              itemBuilder: (context, index) {
                final question = quizProvider.questionWrappers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: QuestionWidget(
                    questionWrapper: question,
                    questionIndex: index + 1,
                    selectedAnswerId:
                        quizProvider.selectedAnswers[index]?.selectedAnswerId,
                    onAnswerSelected: (answerId) {
                      quizProvider.selectAnswerForIndex(
                        answerId,
                        index,
                        question.exerciseQuestionId,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizProvider()..loadQuestions(widget.exerciseId),
      child: Consumer<QuizProvider>(
        builder: (context, quizProvider, _) {
          final errorMessage = quizProvider.errorMessage;

          if (errorMessage != null && errorMessage != lastShownError) {
            lastShownError = errorMessage;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showErrorFlushbar(context, errorMessage);
            });
          }

          return Scaffold(
            appBar: ExamAppBar(
              title: "Làm trắc nghiệm",
              onSubmit: () => _confirmSubmit(context),
            ),
            body: _buildBody(context, quizProvider),
          );
        },
      ),
    );
  }

  void _confirmSubmit(BuildContext context) async{
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: const SizedBox(
          width: 280,
          child: Text(
            "Bạn có chắc chắn muốn nộp bài không ?",
            style: TextStyle(fontSize: 15),
          ),
        ),
        title: const Text(
          "Xác nhận nộp bài",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () async{
              Navigator.of(ctx).pop();
              final isSuccess = await context.read<QuizProvider>().submit();
              if (isSuccess) {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }
}
