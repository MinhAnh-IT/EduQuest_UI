import 'package:flutter/material.dart';
import 'package:edu_quest/app.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    final prefs = await SharedPreferences.getInstance();

    runApp(MyApp(prefs: prefs));
  } catch (e) {
    print('Error initializing app: $e');
    // Fallback initialization
    final prefs = await SharedPreferences.getInstance();
    runApp(MyApp(prefs: prefs));
  }
}


