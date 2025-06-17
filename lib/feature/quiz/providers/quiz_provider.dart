import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../services/quiz_service.dart';

class QuizProvider extends ChangeNotifier {
  List<QuestionModel> questions = [];
  List<int?> selectedAnswers = [];
  int currentIndex = 0;
  bool isLoading = true;
  String? errorMessage;

  Future<void> loadQuestions([int exerciseId = 1]) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      questions = await QuizService.getQuestionsByExerciseId(exerciseId);
      selectedAnswers = List<int?>.filled(questions.length, null);
      currentIndex = 0;
    } catch (e) {
      errorMessage = (e is Exception)
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
      questions = [];
      selectedAnswers = [];
      currentIndex = 0;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectAnswer(int answerId) {
    if (questions.isNotEmpty) {
      selectedAnswers[currentIndex] = answerId;
      notifyListeners();
    }
  }

  void selectAnswerForIndex(int answerId, int index) {
    if (index >= 0 && index < selectedAnswers.length) {
      selectedAnswers[index] = answerId;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      currentIndex++;
      notifyListeners();
    }
  }

  void prevQuestion() {
    if (currentIndex > 0) {
      currentIndex--;
      notifyListeners();
    }
  }

  void submit() {
    print("You pressed submit button");
  }
}
