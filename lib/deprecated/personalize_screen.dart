import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:triptide/screens/home_screen.dart';
import '../utils/constants.dart';

class PersonalizeScreen extends StatefulWidget {
  const PersonalizeScreen({super.key});

  @override
  State<PersonalizeScreen> createState() => _PersonalizeScreenState();
}

class _PersonalizeScreenState extends State<PersonalizeScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is your travel budget?',
      'options': ['Low', 'Medium', 'Luxury'],
      'key': 'budget',
    },
    {
      'question': 'Who are you travelling with?',
      'options': ['Solo', 'Couple', 'Family', 'Friends'],
      'key': 'travel_type',
    },
    {
      'question': 'What kind of places do you like?',
      'options': ['Nature', 'Urban', 'Beach', 'Mountains'],
      'key': 'interest',
    },
    {
      'question': 'What is your preferred travel pace?',
      'options': ['Relaxed', 'Balanced', 'Fast-paced'],
      'key': 'pace',
    },
  ];

  int currentQuestion = 0;
  Map<String, String> answers = {};

  void _nextQuestion(String selectedOption) {
    final currentKey = questions[currentQuestion]['key'];
    answers[currentKey] = selectedOption;
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      _savePreferences();
    }
  }

  Future<void> _savePreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'preferences': answers,
        }, SetOptions(merge: true));
        if (!mounted) return;
        // Navigate only after successful write
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } catch (e) {
        // show error if write fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save preferences: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User not logged in'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionData = questions[currentQuestion];
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'assets/animations/login.json',
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    questionData['question'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ...List.generate(questionData['options'].length, (index) {
                    final option = questionData['options'][index];
                    return GestureDetector(
                      onTap: () => _nextQuestion(option),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const Spacer(),
                  Text(
                    'Step ${currentQuestion + 1} of ${questions.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
