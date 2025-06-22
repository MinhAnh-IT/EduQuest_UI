import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:edu_quest/config/api_config.dart';
import 'package:edu_quest/core/network/api_client.dart';
import 'package:edu_quest/core/network/token_manager.dart';
import 'package:edu_quest/feature/auth/models/Profile_Model.dart';

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

    final headers = await ApiClient.getHeaders(useAuth: true);
    request.headers.addAll(headers);
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
    } else if (response.statusCode == 401) {
      ApiClient.token = await TokenManager().getValidAccessToken();
      if (ApiClient.token == null) {
        throw Exception('Không thể làm mới token. Vui lòng đăng nhập lại.');
      }
      request = http.MultipartRequest('PUT', Uri.parse(url));
      request.headers.addAll(await ApiClient.getHeaders(useAuth: true));
      request.fields['email'] = email;
      if (avatarFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('avatar', avatarFile.path),
        );
      }
      final retryResponse = await request.send();
      final finalResponse = await http.Response.fromStream(retryResponse);
      if (finalResponse.statusCode == 200) {
        final responseData = jsonDecode(finalResponse.body);
        if (responseData['code'] == 200) {
          return ProfileModel.fromJson(responseData['data']);
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('HTTP ${finalResponse.statusCode}: ${finalResponse.body}');
      }
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }
}