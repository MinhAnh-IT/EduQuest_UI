import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:register_login/config/api_config.dart';
import 'package:register_login/core/network/api_client.dart';
import 'package:register_login/feature/auth/models/Profile_Model.dart';

class ProfileService {
  static Future<ProfileModel> getCurrentUser() async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.getProfile}';
    final response = await ApiClient.get(url, auth: true);
    final responseData = jsonDecode(response.body);
    if (responseData['code'] == 200) {
      return ProfileModel.fromJson(responseData['data']);
    } else {
      throw Exception(responseData['message']);
    }
  }

  static Future<ProfileModel> updateProfile(String email, File? avatarFile) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.updateProfile}';
    var request = http.MultipartRequest('PUT', Uri.parse(url));
    if (ApiClient.token != null) {
      request.headers['Authorization'] = 'Bearer ${ApiClient.token}';
    }
    request.fields['email'] = email;
    if (avatarFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('avatar', avatarFile.path),
      );
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['code'] == 200) {
        return ProfileModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message']);
      }
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }
}