import 'package:flutter/material.dart';
import '../../../feature/quiz/models/answer_selected.dart';
import '../../../feature/quiz/models/question_waper.dart';
import '../../../feature/quiz/models/start_exam_model.dart';
import '../../../feature/quiz/models/submission_request.dart';
import '../services/quiz_service.dart';

class QuizProvider extends ChangeNotifier {
  List<QuestionWrapper> questionWrappers = [];
  StartExamModel? startExamModel;
  List<AnswerSelected?> selectedAnswers = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> loadQuestions(int exerciseId) async {
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

  Future<bool> submit() async {
  if (startExamModel == null) {
    errorMessage = "Chưa load thông tin bài thi!";
    notifyListeners();
    return false;
  }
  final participationId = startExamModel!.participationId;
  final answers = selectedAnswers.whereType<AnswerSelected>().toList();

  if (answers.isEmpty) {
    errorMessage = "Bạn chưa chọn đáp án nào!";
    notifyListeners();
    return false;
  }

  SubmissionRequest request = SubmissionRequest(
    participationId: participationId,
    selectedAnswers: answers,
  );
  try {
    await QuizService.submissionExam(request);
    // Nộp thành công
    return true;
  } catch (e) {
    errorMessage = (e is Exception)
        ? e.toString().replaceFirst('Exception: ', '')
        : "Có lỗi xảy ra trong quá trình nộp bài.";
    notifyListeners();
    return false;
  }
}

}
