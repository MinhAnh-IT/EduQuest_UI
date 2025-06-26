import 'package:another_flushbar/flushbar.dart';
import 'package:edu_quest/core/enums/convert_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/result_provider.dart';
import '../../../shared/widgets/result_question_widget.dart';
import '../../../shared/widgets/exam_app_bar.dart';

class ResultScreen extends StatefulWidget {
  final int exerciseId;

  const ResultScreen({super.key, required this.exerciseId});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String? lastShownError;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ResultProvider>(context, listen: false)
          .fetchResult(widget.exerciseId);
    });
  }

  void _showErrorFlushbar(BuildContext context, String message) {
    Flushbar(
      titleText: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red.withOpacity(0.12),
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
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
      flushbarPosition: FlushbarPosition.BOTTOM,
      leftBarIndicatorColor: Colors.redAccent,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  Widget _buildBody(BuildContext context, ResultProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }


    final result = provider.result;
    if (result == null || result.questions.isEmpty) {
      return const Center(child: Text("Không có dữ liệu kết quả"));
    }

    final correctCount = result.questions
        .where((q) =>
            q.selectedAnswer != null &&
            q.selectedAnswer!.answerId == q.correctAnswer.answerId)
        .length;
    final totalQuestions = result.questions.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bài: ${result.exerciseName}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Điểm: ${result.score}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "Trạng thái: ${ConvertStatus.getMessage(result.status) ?? result.status}",
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            "Thời gian nộp: ${DateFormat('dd/MM/yyyy HH:mm').format(result.submittedAt)}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.topRight,
            child: Text(
              '$correctCount/$totalQuestions câu đúng',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: totalQuestions > 0 ? correctCount / totalQuestions : 0,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: totalQuestions,
              itemBuilder: (context, index) {
                final question = result.questions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ResultQuestionWidget(
                    question: question,
                    questionIndex: index + 1,
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
    return Consumer<ResultProvider>(
      builder: (context, provider, _) {
        if (provider.error != null && provider.error != lastShownError) {
          lastShownError = provider.error;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorFlushbar(context, provider.error!);
          });
        }

        return Scaffold(
          appBar: ExamAppBar(
            title: "Kết quả bài làm",
          showSubmitButton: false,
          ),

          body: _buildBody(context, provider),
        );
      },
    );
  }
}