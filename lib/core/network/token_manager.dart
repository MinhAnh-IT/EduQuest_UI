import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';

class TokenManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getValidAccessToken() async {
    final accessToken = await _storage.read(key: 'access_token');
    print('Access Token: $accessToken');
    if (accessToken == null) {
      return await _refreshAccessToken();
    }

    final secondsLeft = _secondsUntilExpire(accessToken);
    print('Số giây đến khi hết hạn: $secondsLeft');
    if (secondsLeft == null || secondsLeft < 120) {
      return await _refreshAccessToken();
    }
    return accessToken;
  }

  int? _secondsUntilExpire(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        print('Định dạng JWT không hợp lệ: $token');
        return null;
      }
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      print('JWT Payload: $payload');
      final exp = payload['exp'] as int;
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return exp - currentTime;
    } catch (e) {
      print('Lỗi giải mã JWT: $e');
      return null;
    }
  }

  Future<String?> _refreshAccessToken() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    print('Refresh Token: $refreshToken');
    if (refreshToken == null) {
      print('Không có refresh token');
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/refresh-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      print('Trạng thái API làm mới: ${response.statusCode}');
      print('Phản hồi API làm mới: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['data']['accessToken'];
        final newRefreshToken = data['data']['refreshToken'];
        await _storage.write(key: 'access_token', value: newAccessToken);
        if (newRefreshToken != null) {
          await _storage.write(key: 'refresh_token', value: newRefreshToken);
        }
        return newAccessToken;
      } else {
        print('Làm mới thất bại: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Lỗi khi làm mới token: $e');
      return null;
    }
  }
}
