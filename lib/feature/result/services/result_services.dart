import 'dart:convert';
import '../models/result_model.dart';
import '../../../config/api_config.dart';
import '../../../core/enums/error_message_resolver.dart';
import '../../../core/network/api_client.dart';

class ResultService {
  Future<ResultModel> fetchResult(int exerciseId) async {
    final url =
        '${ApiConfig.baseUrl}${ApiConfig.getResultByExerciseId}/$exerciseId';

    final response = await ApiClient.get(url, auth: true);

    final body = jsonDecode(response.body);
    final code = body['code'];
    final message = body['message'];

    if (code == 200) {
      return ResultModel.fromJson(body['data']);
    } else {
      throw Exception(ErrorMessageResolver.resolve(code, message));
    }
  }
}
