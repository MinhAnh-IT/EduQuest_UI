import 'package:edu_quest/feature/Profile/providers/profile_provider.dart';
import 'package:edu_quest/feature/Profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../feature/quiz/providers/quiz_provider.dart';
import '../../../feature/quiz/screens/exam_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edu_quest/feature/auth/screens/login_screen.dart';
import 'package:edu_quest/feature/auth/screens/student/student_registration_screen.dart';
import 'package:edu_quest/feature/auth/screens/otp_verification_screen.dart';
import 'package:edu_quest/feature/auth/screens/student/student_details_screen.dart';
import 'package:edu_quest/feature/result/screens/result_screen.dart';
import 'package:edu_quest/feature/result/providers/result_provider.dart';
import 'package:edu_quest/feature/auth/providers/auth_provider.dart';
import 'package:edu_quest/feature/auth/providers/theme_provider.dart';
import 'package:edu_quest/feature/class/providers/class_provider.dart';
import 'package:edu_quest/shared/utils/constants.dart';
import 'package:edu_quest/feature/home/screens/home_screen.dart';

import 'feature/class/providers/exercise_provider.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ResultProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ClassProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()..fetchAssignments()),

    ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            initialRoute: '/login',
            onGenerateRoute: (settings) {
              if (settings.name == '/otp-verification') {
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (context) => OtpVerificationScreen(
                    username: args['username'] as String,
                    registrationData:
                        args['registrationData'] as Map<String, dynamic>,
                  ),
                );
              }
              return null;
            },
            routes: {
              '/home': (context) => const HomeScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const StudentRegistrationScreen(),
              '/student-details': (context) => const StudentDetailsScreen(),
              '/quiz': (context) => const ExamScreen(),
              '/result': (context) {
                final args = ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;
                return ResultScreen(exerciseId: args['exerciseId'] as int);
              },
              '/profile': (context) => const ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}
