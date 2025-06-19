import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TripTideApp());
}

class TripTideApp extends StatelessWidget {
  const TripTideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripTide',
      theme: tripTideTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
