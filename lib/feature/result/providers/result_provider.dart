import 'package:flutter/material.dart';
import '../models/result_model.dart';
import '../services/result_services.dart';
import '../../../core/enums/status_code.dart';

class ResultProvider extends ChangeNotifier {
  ResultModel? result;
  bool isLoading = false;
  String? error;

  Future<void> fetchResult(int exerciseId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      result = await ResultService().fetchResult(exerciseId);
    } catch (e) {
      result = null;

      final errorMessage = e.toString().replaceFirst('Exception: ', '');

      if (StatusCode.values.any((code) => code.message == errorMessage)) {
        error = errorMessage;
      } else {
        error = 'Không thể tải kết quả: $errorMessage';
      }
    }

    isLoading = false;
    notifyListeners();
  }
}
