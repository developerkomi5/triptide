// budget_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../utils/constants.dart';
import 'departure_date_screen.dart';

class BudgetScreen extends StatefulWidget {
  final String destination;
  final String durationOption;

  const BudgetScreen({
    super.key,
    required this.destination,
    required this.durationOption,
  });

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final List<String> budgetOptions = ['Low Budget', 'Mid Range', 'Luxury'];

  void _selectBudget(String selectedBudget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DepartureDateScreen(
          destination: widget.destination,
          durationOption: widget.durationOption,
          budgetOption: selectedBudget,
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
                children: [
                  const Spacer(),
                  Text(
                    "What's your budget type?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ...List.generate(budgetOptions.length, (index) {
                    final option = budgetOptions[index];
                    return GestureDetector(
                      onTap: () => _selectBudget(option),
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
                    'Step 3 of 5',
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
