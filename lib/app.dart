import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_quest/feature/quiz/providers/quiz_provider.dart';
import 'package:edu_quest/feature/quiz/screens/exam_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edu_quest/feature/auth/screens/login_screen.dart';
import 'package:edu_quest/feature/auth/screens/role_selection_screen.dart';
import 'package:edu_quest/feature/auth/screens/student/student_registration_screen.dart';
import 'package:edu_quest/feature/auth/screens/otp_verification_screen.dart';
import 'package:edu_quest/feature/auth/screens/student/student_details_screen.dart';
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
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            initialRoute: '/quiz',
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
              '/role-selection': (context) => const RoleSelectionScreen(),
              '/register': (context) => const StudentRegistrationScreen(),
              '/student-details': (context) => const StudentDetailsScreen(),
              '/quiz': (context) => const ExamScreen(),
            },
          );
        },
      ),
    );
  }
}
