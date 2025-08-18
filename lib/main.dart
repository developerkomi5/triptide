import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:triptide/firebase_options.dart';
import 'package:triptide/screens/splash_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: const SplashScreen(), // Always start with splash screen
    );
  }
}
