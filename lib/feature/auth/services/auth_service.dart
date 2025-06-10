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

  static Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.verifyOtp}';
    final response = await ApiClient.post(url, {
      'email': email,
      'otp': otp,
    });
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> resendOtp(String email) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.resendOtp}';
    final response = await ApiClient.post(url, {'email': email});
    return jsonDecode(response.body);
  }
}
