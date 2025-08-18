// travel_with_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:triptide/screens/personalize/people_selector_screen.dart';
import 'package:triptide/screens/summary_screen.dart';

import '../../utils/constants.dart';

class TravelWithScreen extends StatefulWidget {
  final String destination;
  final String? fromCity;
  final DateTime? startDate;
  final DateTime? endDate;
  final String durationOption;
  final String budgetOption;

  const TravelWithScreen({
    super.key,
    required this.destination,
    this.fromCity,
    this.startDate,
    this.endDate,
    required this.durationOption,
    required this.budgetOption,
  });

  @override
  State<TravelWithScreen> createState() => _TravelWithScreenState();
}

class _TravelWithScreenState extends State<TravelWithScreen> {
  final List<String> travelWithOptions = [
    "Solo",
    "Couple",
    "Family",
    "Friends",
  ];

  String? selectedOption;

  void _onContinue() {
    if (selectedOption != null) {
      if (selectedOption == "Solo") {
        // Skip people selector and go directly to summary with solo defaults
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SummaryScreen(
              destination: widget.destination,
              fromCity: widget.fromCity,
              startDate: widget.startDate,
              endDate: widget.endDate,
              budgetOptions: widget.budgetOption,
              travelWith: "Solo",
              travelPeople: {"adults": 1, "children": 0, "infants": 0},
            ),
          ),
        );
      } else {
        // Pass all collected data to PeopleSelectorScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PeopleSelectorScreen(
              travelWithCategory: selectedOption!,
              destination: widget.destination,
              fromCity: widget.fromCity,
              startDate: widget.startDate,
              endDate: widget.endDate,
              durationOption: widget.durationOption,
              budgetOption: widget.budgetOption,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select an option.")));
    }
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    "Who are you travelling with?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ...travelWithOptions.map((option) {
                    final isSelected = option == selectedOption;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedOption = option;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? kPrimaryColor.withOpacity(0.85)
                                : Colors.white.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                            ],
                            border: Border.all(
                              color: isSelected
                                  ? kPrimaryColor
                                  : Colors.white24,
                              width: 1.2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              option,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Step 6 of 7',
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
