import 'dart:convert';
import '../../../../../config/api_config.dart';
import '../../../../../core/network/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterSecureStorage _storage;

  AuthService() : _storage = const FlutterSecureStorage();
  Future<Map<String, dynamic>> requestPasswordReset(String username) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.forgotPassword}';
    final response = await ApiClient.post(url, {'username': username.trim()});
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> resetPassword(
      String username, String newPassword) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.resetPassword}';
    final response = await ApiClient.post(
        url, {'username': username.trim(), 'newPassword': newPassword});
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) {
        await _storage.delete(key: 'access_token');
        await _storage.delete(key: 'refresh_token');
        return {
          'code': 200,
          'message': 'Logged out successfully',
          'data': null
        };
      }

      final url = '${ApiConfig.baseUrl}${ApiConfig.logout}';
      final response =
          await ApiClient.post(url, {'refreshToken': refreshToken}, auth: true);
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      ApiClient.token = null;

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'code': 200, 'message': 'Logged out locally', 'data': null};
      }
    } catch (e) {
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      ApiClient.token = null;

      return {'code': 200, 'message': 'Logged out locally', 'data': null};
    }
  }

  Future<Map<String, dynamic>> verifyOTPForgotPassword(
      String username, String otp) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.verifyOtpForgotPassword}';
    final response = await ApiClient.post(
        url, {'username': username.trim(), 'otp': otp.trim()});
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.login}';
    final response = await ApiClient.post(url, {
      'username': username,
      'password': password,
    });

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(
      Map<String, dynamic> payload) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.register}';
    final response = await ApiClient.post(url, payload);
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> verifyOtp(
      String username, String otp) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.verifyOtp}';

    final response = await ApiClient.post(url, {
      'username': username,
      'otp': otp,
    });

    final responseData = jsonDecode(response.body);

    // Kiểm tra code trong response body
    if (responseData['code'] == 200) {
      return responseData;
    } else {
      throw Exception(responseData['message']);
    }
  }

  static Future<Map<String, dynamic>> updateStudentDetails(
      int userId, Map<String, dynamic> details) async {
    final url =
        '${ApiConfig.baseUrl}${ApiConfig.updateStudentDetails.replaceAll('{userId}', userId.toString())}';

    final response = await ApiClient.post(url, details);

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

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Không thể gửi lại OTP: ${response.statusCode} - ${response.body}');
    }
  }
}
