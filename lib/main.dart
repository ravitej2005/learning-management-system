import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learning_management_system/pages/authPage.dart';
import 'package:learning_management_system/pages/landingPage3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
  runApp(MainApp(
    isFirstLaunch: isFirstLaunch,
  ));
}

class MainApp extends StatelessWidget {
  final bool isFirstLaunch;
  const MainApp({super.key, required this.isFirstLaunch});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isFirstLaunch ? LandingPage3() : AuthPage(),
    );
  }
}
