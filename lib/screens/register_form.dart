import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onToggle;

  const RegisterForm({super.key, required this.onToggle});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '', confirmPassword = '', error = '', name = '';
  bool loading = false, showPassword = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (password != confirmPassword) {
      setState(() => error = 'Passwords do not match');
      return;
    }

    setState(() => loading = true);

    try {
      final auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await auth.currentUser?.updateDisplayName(name);
      await auth.currentUser?.sendEmailVerification();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Verification email sent. Please verify before logging in.",
          ),
        ),
      );
      widget.onToggle();
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? 'Registration failed');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            "Register",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          TextFormField(
            decoration: const InputDecoration(labelText: 'Full Name'),
            onSaved: (val) => name = val!.trim(),
          ),

          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            onSaved: (val) => email = val!.trim(),
            validator: (val) =>
                val != null && val.contains('@') ? null : 'Enter valid email',
          ),

          TextFormField(
            obscureText: !showPassword,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() => showPassword = !showPassword),
              ),
            ),
            onSaved: (val) => password = val!,
            validator: (val) =>
                val != null && val.length >= 6 ? null : 'Min 6 characters',
          ),

          TextFormField(
            obscureText: !showPassword,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            onSaved: (val) => confirmPassword = val!,
            validator: (val) =>
                val != null && val.length >= 6 ? null : 'Min 6 characters',
          ),

          const SizedBox(height: 10),
          if (error.isNotEmpty)
            Text(error, style: const TextStyle(color: Colors.red)),

          ElevatedButton(
            onPressed: loading ? null : _register,
            child: const Text("Register"),
          ),

          TextButton(
            onPressed: widget.onToggle,
            child: const Text("Already have an account? Login"),
          ),
        ],
      ),
    );
  }
}
