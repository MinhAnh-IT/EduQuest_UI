class ApiConfig {
  // For Android Emulator: use 10.0.2.2
  // For Physical Device: use your local IP address (192.168.1.2)
  // For iOS Simulator: use localhost or 127.0.0.1
  static const String baseUrl = 'http://localhost:8080/api';
  
  // Alternative URLs for different environments
  static const String localhostUrl = 'http://localhost:8080/api';
  
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}