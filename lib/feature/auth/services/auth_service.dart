import 'dart:convert';
import 'package:register_login/config/api_config.dart';
import 'package:register_login/core/network/api_client.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.login}';
    final response = await ApiClient.post(url, {
      'username': username,
      'password': password,
    });

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> payload) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.register}';
    final response = await ApiClient.post(url, payload);
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> verifyOtp(String username, String otp) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.verifyOtp}';

    print('Request URL: $url');
    print('Request body: ${jsonEncode({
      'username': username,
      'otp': otp,
    })}');

    final response = await ApiClient.post(url, {
      'username': username,
      'otp': otp,
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final responseData = jsonDecode(response.body);

    // Kiểm tra code trong response body
    if (responseData['code'] == 200) {
      return responseData;
    } else {
      throw Exception(responseData['message']);
    }
  }

  static Future<Map<String, dynamic>> updateStudentDetails(int userId, Map<String, dynamic> details) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.updateStudentDetails.replaceAll('{userId}', userId.toString())}';

    print('Request URL: $url');
    print('Request body: ${jsonEncode(details)}');

    final response = await ApiClient.post(url, details);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final responseData = jsonDecode(response.body);

    if (responseData['code'] == 200 || responseData['code'] == 201) {
      return responseData;
    } else {
      throw Exception(responseData['message']);
    }
  }

  static Future<Map<String, dynamic>> resendOtp(String username) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.resendOtp}';
    final response = await ApiClient.post(url, {'username': username});
    print('Resend OTP response status: ${response.statusCode}');
    print('Resend OTP response body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to resend OTP: ${response.statusCode} - ${response.body}');
    }
  }
}
