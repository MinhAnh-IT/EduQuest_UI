import 'package:flutter/material.dart';
import 'package:register_login/feature/quiz/models/answer_selected.dart';
import 'package:register_login/feature/quiz/models/question_waper.dart';
import 'package:register_login/feature/quiz/models/start_exam_model.dart';
import 'package:register_login/feature/quiz/models/submission_request.dart';
import '../services/quiz_service.dart';

class QuizProvider extends ChangeNotifier {
  List<QuestionWrapper> questionWrappers = [];
  StartExamModel? startExamModel;
  List<AnswerSelected?> selectedAnswers = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> loadQuestions([int exerciseId = 1]) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      startExamModel = await QuizService.getQuestionsByExerciseId(exerciseId);

      questionWrappers = startExamModel?.questionWappers ?? [];
      selectedAnswers = List<AnswerSelected?>.filled(
          questionWrappers.length, null,
          growable: false);
    } catch (e) {
      errorMessage = (e is Exception)
          ? e.toString().replaceFirst('Exception: ', '')
          : "Có lỗi xảy ra trong quá trình tải dữ liệu.";
      questionWrappers = [];
      selectedAnswers = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectAnswerForIndex(int answerId, int index, int exerciseQuestionId) {
    if (index >= 0 && index < selectedAnswers.length) {
      selectedAnswers[index] = AnswerSelected(
        exerciseQuestionId: exerciseQuestionId,
        selectedAnswerId: answerId,
      );
      notifyListeners();
    }
  }

  Future<void> submit() async {
    if (startExamModel == null) {
      errorMessage = "Chưa load thông tin bài thi!";
      notifyListeners();
      return;
    }
    final participationId = startExamModel!.participationId;
    final answers = selectedAnswers.whereType<AnswerSelected>().toList();

    if (answers.isEmpty) {
      errorMessage = "Bạn chưa chọn đáp án nào!";
      notifyListeners();
      return;
    }

    SubmissionRequest request = SubmissionRequest(
      participationId: participationId,
      selectedAnswers: answers,
    );
    try {
      await QuizService.submissionExam(request);
    } catch (e) {
      errorMessage = (e is Exception)
          ? e.toString().replaceFirst('Exception: ', '')
          : "Có lỗi xảy ra trong quá trình nộp bài.";
      notifyListeners();
    }
  }
}
