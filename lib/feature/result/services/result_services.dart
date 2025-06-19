import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/result_model.dart';
import '../../../config/api_config.dart';

class ResultService {
  Future<ResultModel> fetchResult(int exerciseId, String jwtToken) async {
    final url = Uri.parse("${ApiConfig.baseUrl}${ApiConfig.getResultByExerciseId}/$exerciseId");
    print('Making request to: $url with token: $jwtToken');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        print('Parsed JSON: $jsonData');

        final data = jsonData['data'] as Map<String, dynamic>;
        print('Data section: $data');

        return ResultModel.fromJson(data);
      } catch (e) {
        print('JSON parsing error: $e');
        throw Exception("Lỗi khi parse JSON: $e");
      }
    } else {
      print('HTTP error response: ${response.body}');
      throw Exception("HTTP Error ${response.statusCode}: ${response.body}");
    }
  }
}