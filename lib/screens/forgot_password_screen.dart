import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String message = '';
  bool loading = false;

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        message = "Password reset email sent.";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        message = e.message ?? "Something went wrong";
      });
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Enter your email to receive password reset link",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (val) => email = val!.trim(),
                validator: (val) => val != null && val.contains('@')
                    ? null
                    : 'Enter valid email',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : _sendResetEmail,
                child: const Text('Send Reset Link'),
              ),
              const SizedBox(height: 20),
              if (message.isNotEmpty)
                Text(message, style: const TextStyle(color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}
