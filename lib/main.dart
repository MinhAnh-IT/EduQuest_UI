import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../feature/auth/screens/login_screen.dart';
import '../feature/home/screens/home_screen.dart';
import '../feature/auth/providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'EduQuest',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) =>  LoginScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
