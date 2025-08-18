// trip_duration_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../utils/constants.dart';
import 'budget_screen.dart';

class TripDurationScreen extends StatefulWidget {
  final String selectedCity;
  const TripDurationScreen({super.key, required this.selectedCity});

  @override
  State<TripDurationScreen> createState() => _TripDurationScreenState();
}

class _TripDurationScreenState extends State<TripDurationScreen> {
  final List<String> durationOptions = [
    'Weekend (2-3 days)',
    'Short trip (4-5 days)',
    '1 Week',
    '10 Days',
    '2 Weeks+',
  ];

  void _selectDuration(String selectedDuration) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BudgetScreen(
          destination: widget.selectedCity,
          durationOption: selectedDuration,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    'How long is your trip?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ...List.generate(durationOptions.length, (index) {
                    final option = durationOptions[index];
                    return GestureDetector(
                      onTap: () => _selectDuration(option),
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
                    'Step 2 of 5',
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
