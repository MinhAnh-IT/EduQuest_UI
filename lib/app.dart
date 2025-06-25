import 'package:edu_quest/feature/Profile/providers/profile_provider.dart';
import 'package:edu_quest/feature/Profile/screens/profile_screen.dart';
import 'package:edu_quest/feature/discussion/providers/discussion_provider.dart';
import 'package:edu_quest/feature/discussion/screens/discusion_list_screen.dart';
import 'package:edu_quest/feature/discussion/services/discussion_service.dart';
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
import 'package:edu_quest/feature/class/screens/assignment_list_screen.dart';
import 'package:edu_quest/shared/utils/constants.dart';
import 'package:edu_quest/feature/home/screens/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'feature/class/providers/exercise_provider.dart';

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
        ChangeNotifierProvider(create: (_) => DiscussionProvider(api: DiscussionApiService())),
        ChangeNotifierProvider(create: (_) => ResultProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ClassProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            home: AuthGate(prefs: prefs),
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
              '/home': (context) => const HomeScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const StudentRegistrationScreen(),
              '/student-details': (context) => const StudentDetailsScreen(),
              '/quiz': (context) {
                final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                return ExamScreen(exerciseId: args['exerciseId'] as int);
              },
              '/discussion': (context) => const DiscussionListScreen(exerciseId: 101,),
              '/result': (context) {
                final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                return ResultScreen(exerciseId: args['exerciseId'] as int);
              },
              '/profile': (context) => const ProfileScreen(),
              '/assignments': (context) {
                final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                return AssignmentListScreen(
                  classId: args['classId'] as int,
                  className: args['className'] as String,
                );
              },
              '/discussion-list': (context) {
                final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                return DiscussionListScreen(
                  exerciseId: args['exerciseId'] as int,
                );
              },
            },
          );
        },
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  final SharedPreferences prefs;
  const AuthGate({super.key, required this.prefs});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Future<bool> _isLoggedIn;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<bool> checkLogin() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      return refreshToken != null && refreshToken.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoggedIn = checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.cyan),
                  SizedBox(height: 16),
                  Text('Đang kiểm tra trạng thái đăng nhập...'),
                ],
              ),
            ),
          );
        }
        
        if (snapshot.hasError) {
          return const LoginScreen();
        }
        
        if (!snapshot.hasData) {
          return const LoginScreen();
        }
        
        if (snapshot.data == true) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
