import 'package:flutter/material.dart';
import '../models/result_model.dart';
import '../services/result_services.dart';

class ResultProvider extends ChangeNotifier {
  ResultModel? result;
  bool isLoading = false;
  String? error;

  Future<void> fetchResult(int exerciseId, String jwtToken) async {
    isLoading = true;
    notifyListeners();

    try {
      print('Fetching result for exerciseId: $exerciseId');
      result = await ResultService().fetchResult(exerciseId, jwtToken);
      print('Result fetched successfully: ${result?.exerciseName}');
      error = null;
    } catch (e) {
      print('Error in ResultProvider: $e'); 
      print('Error type: ${e.runtimeType}');
      result = null;
      error = 'Không thể tải kết quả: ${e.toString()}';
    }

    isLoading = false;
    notifyListeners();
  }
}