import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_quest/feature/quiz/providers/quiz_provider.dart';
import 'package:edu_quest/feature/quiz/screens/exam_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edu_quest/feature/auth/screens/login_screen.dart';
import 'package:edu_quest/feature/auth/screens/student/student_registration_screen.dart';
import 'package:edu_quest/feature/auth/screens/otp_verification_screen.dart';
import 'package:edu_quest/feature/auth/screens/student/student_details_screen.dart';
import 'package:edu_quest/feature/result/screens/result_screen.dart';
import 'package:edu_quest/feature/result/providers/result_provider.dart';
import 'package:edu_quest/feature/auth/providers/auth_provider.dart';
import 'package:edu_quest/feature/auth/providers/theme_provider.dart';
import 'package:edu_quest/shared/utils/constants.dart';



class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ResultProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            initialRoute: '/result',
            onGenerateRoute: (settings) {
              if (settings.name == '/otp-verification') {
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (context) => OtpVerificationScreen(
                    email: args['email'] as String,
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
              '/quiz': (context) => const ExamScreen(),
              '/result': (context) => const ResultScreen(
                exerciseId: 2,
                jwtToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI0IiwiYXVkIjoiRWR1UXVlc3RBdWRpZW5jZSIsImlhdCI6MTc1MDMxMTYzNCwidXNlcm5hbWUiOiJzdHVkZW50MSIsImlzcyI6IkVkdVF1ZXN0SXNzdWVyIiwiZXhwIjoxNzUwMzE1MjM0LCJyb2xlIjoiUk9MRV9TVFVERU5UIn0.OWtDMfcqQQyqroVBfgZ_vZ_qUzkoKlmPN3DK1pwV4Mk',
              ),
            },
          );
        },
      ),
    );
  }
}
