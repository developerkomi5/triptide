import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../utils/constants.dart';
import '../widgets/loading_overlay.dart';
import 'login_form.dart';
import 'register_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: LoadingOverlay(
        isLoading: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Lottie.asset(
                'assets/animations/login.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: kCardColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      if (!showLogin)
                        RegisterForm(
                          onToggle: () {
                            setState(() => showLogin = true);
                          },
                        )
                      else
                        LoginForm(
                          onToggle: () {
                            setState(() => showLogin = false);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
