import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:register_login/screens/auth/login_screen.dart';
import 'package:register_login/screens/auth/role_selection_screen.dart';
import 'package:register_login/screens/auth/student/student_registration_screen.dart';
import 'package:register_login/screens/auth/otp_verification_screen.dart';
import 'package:register_login/screens/auth/student/student_details_screen.dart';
import 'package:register_login/services/auth_service.dart';
import 'package:register_login/providers/auth_provider.dart';
import 'package:register_login/providers/theme_provider.dart';
import 'package:register_login/providers/student_provider.dart';
import 'package:register_login/theme/app_theme.dart';
import 'package:register_login/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({
    super.key,
    required this.prefs,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            context.read<AuthService>(),
            prefs,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(prefs),
        ),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: '/login',
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
            },
          );
        },
      ),
    );
  }
}
