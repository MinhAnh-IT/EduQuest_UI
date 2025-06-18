import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:register_login/feature/auth/screens/login_screen.dart';
import 'package:register_login/feature/auth/screens/student/student_registration_screen.dart';
import 'package:register_login/feature/auth/screens/otp_verification_screen.dart';
import 'package:register_login/feature/auth/screens/student/student_details_screen.dart';
import 'package:register_login/feature/auth/services/auth_service.dart';
import 'package:register_login/feature/auth/providers/auth_provider.dart';
import 'package:register_login/feature/auth/providers/theme_provider.dart';
import 'package:register_login/shared/theme/app_theme.dart';
import 'package:register_login/shared/utils/constants.dart';

import 'core/network/api_client.dart';
import 'feature/auth/providers/profile_provider.dart';
import 'feature/auth/screens/student/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    final prefs = await SharedPreferences.getInstance();
    ApiClient.token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxNSIsImF1ZCI6IkVkdVF1ZXN0QXVkaWVuY2UiLCJpYXQiOjE3NTAyNTg3MzcsInVzZXJuYW1lIjoiaG9hbnZ1MmVlIiwiaXNzIjoiRWR1UXVlc3RJc3N1ZXIiLCJleHAiOjE3NTAyNjIzMzcsInJvbGUiOiJST0xFX1NUVURFTlQifQ.U97Z3JD3f16Hw6-Nrl38ggT95Y2QzEydxRUjByEUJtM';

    runApp(MyApp(prefs: prefs));
  } catch (e) {
    print('Error initializing app: $e');
    // Fallback initialization
    final prefs = await SharedPreferences.getInstance();
    runApp(MyApp(prefs: prefs));
  }
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: '/profile',
            onGenerateRoute: (settings) {
              if (settings.name == '/otp-verification') {
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (context) => OtpVerificationScreen(
                    username: args['username'] as String,
                    registrationData: args['registrationData'] as Map<String, dynamic>,
                  ),
                );
              }
              return null;
            },
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const StudentRegistrationScreen(),
              '/student-details': (context) => const StudentDetailsScreen(),
              '/profile': (context) => const ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}

