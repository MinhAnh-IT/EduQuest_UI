inimport 'dart:convert';
import '../../../../../config/api_config.dart';
import '../../../../../core/network/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterSecureStorage _storage;

  AuthService() : _storage = const FlutterSecureStorage();  
  Future<Map<String, dynamic>> requestPasswordReset(String username) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.forgotPassword}';
    final response = await ApiClient.post(url, {
      'username': username.trim()
    });
    return jsonDecode(response.body);
  }
  
  Future<Map<String, dynamic>> resetPassword(String username, String newPassword) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.resetPassword}';
    final response = await ApiClient.post(url, {
      'username': username.trim(),
      'newPassword': newPassword
    });
    return jsonDecode(response.body);
  }
  
  // Logout
  Future<Map<String, dynamic>> logout() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      return {
        'code': 401,
        'message': 'Authentication token not found',
        'data': null
      };
    }
      // Set token for auth header
    ApiClient.token = token;
    
    final url = '${ApiConfig.baseUrl}${ApiConfig.logout}';
    final response = await ApiClient.post(url, {}, auth: true);
    
    // Clear stored token after successful logout
    if (response.statusCode == 200) {
      await _storage.delete(key: 'auth_token');
      ApiClient.token = null;
    }
    
    return jsonDecode(response.body);
  }
  // Verify OTP for forgot password
  Future<Map<String, dynamic>> verifyOTPForgotPassword(String username, String otp) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.verifyOtpForgotPassword}';
    final response = await ApiClient.post(url, {
      'username': username.trim(),
      'otp': otp.trim()
    });
    return jsonDecode(response.body);
  }

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