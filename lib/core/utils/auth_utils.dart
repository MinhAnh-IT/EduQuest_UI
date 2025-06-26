import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../feature/auth/screens/login_screen.dart';
import '../network/api_client.dart';

class AuthUtils {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  
  /// Clear all tokens and redirect to login screen
  static Future<void> clearTokensAndRedirectToLogin(BuildContext context) async {
    try {
      // Clear all stored tokens
      await _secureStorage.delete(key: 'access_token');
      await _secureStorage.delete(key: 'refresh_token');
      
      // Clear ApiClient token
      ApiClient.token = null;
      
      // Navigate to login screen and clear all previous routes
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
        
        // Show message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      // Even if there's an error, still navigate to login
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }
  
  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      return refreshToken != null && refreshToken.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  /// Clear all authentication data
  static Future<void> clearAuthData() async {
    try {
      await _secureStorage.delete(key: 'access_token');
      await _secureStorage.delete(key: 'refresh_token');
      ApiClient.token = null;
    } catch (e) {
      // Ignore errors during cleanup
    }
  }
}
