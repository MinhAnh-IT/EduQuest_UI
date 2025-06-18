import 'package:flutter/material.dart';
import 'package:register_login/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:register_login/feature/auth/screens/login_screen.dart';
import 'package:register_login/feature/auth/screens/role_selection_screen.dart';
import 'package:register_login/feature/auth/screens/student/student_registration_screen.dart';
import 'package:register_login/feature/auth/screens/otp_verification_screen.dart';
import 'package:register_login/feature/auth/screens/student/student_details_screen.dart';
import 'package:register_login/feature/auth/providers/auth_provider.dart';
import 'package:register_login/feature/auth/providers/theme_provider.dart';
import 'package:register_login/shared/theme/app_theme.dart';
import 'package:register_login/shared/utils/constants.dart';
import 'package:register_login/feature/home/screens/home_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

