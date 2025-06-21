import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:triptide/screens/forgot_password_screen.dart';
import '../screens/home_screen.dart';
import '../utils/constants.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onToggle;

  const LoginForm({super.key, required this.onToggle});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '', error = '';
  bool showPassword = false;
  bool loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? 'Login failed');
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      setState(() => loading = true);

      final googleSignIn = GoogleSignIn();

      // 🔴 Force Google to show the account picker
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => loading = false);
        return; // user canceled
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      setState(() => error = 'Google Sign-In failed: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Login to TripTide',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (val) => email = val!.trim(),
                validator: (val) => val != null && val.contains('@')
                    ? null
                    : 'Enter valid email',
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: !showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                      color: kTextColor.withOpacity(0.6),
                    ),
                    onPressed: () =>
                        setState(() => showPassword = !showPassword),
                  ),
                ),
                onSaved: (val) => password = val!,
                validator: (val) =>
                    val != null && val.length >= 6 ? null : 'Min 6 characters',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: loading ? null : _signInWithGoogle,
                icon: Image.asset('assets/google.png', height: 20),
                label: const Text("Sign in with Google"),
              ),
              const SizedBox(height: 10),
              if (error.isNotEmpty)
                Text(error, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
              TextButton(
                onPressed: widget.onToggle,
                child: const Text("Don't have an account? Register"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: const Text("Forgot Password?"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
