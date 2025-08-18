// people_selector_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:triptide/screens/summary_screen.dart';
import 'package:triptide/widgets/custom_button.dart';
import '../../utils/constants.dart';

class PeopleSelectorScreen extends StatefulWidget {
  final String travelWithCategory;
  final String destination;
  final String? fromCity;
  final DateTime? startDate;
  final DateTime? endDate;
  final String durationOption;
  final String budgetOption;

  const PeopleSelectorScreen({
    super.key,
    required this.travelWithCategory,
    required this.destination,
    this.fromCity,
    this.startDate,
    this.endDate,
    required this.durationOption,
    required this.budgetOption,
  });

  @override
  State<PeopleSelectorScreen> createState() => _PeopleSelectorScreenState();
}

class _PeopleSelectorScreenState extends State<PeopleSelectorScreen> {
  int adults = 0;
  int children = 0;
  int infants = 0;

  String? selectedOption;

  @override
  void initState() {
    super.initState();
    if (widget.travelWithCategory == "Couple") {
      adults = 2; // Default 2 adults for Couple
    }
  }

  void _increment(String category) {
    setState(() {
      if (category == 'adults') {
        if (widget.travelWithCategory == "Couple") {
          adults += 2;
        } else {
          adults++;
        }
      }
      if (category == 'children') children++;
      if (category == 'infants') infants++;
      selectedOption = category;
    });
  }

  void _decrement(String category) {
    setState(() {
      if (category == 'adults') {
        if (widget.travelWithCategory == "Couple") {
          if (adults > 2) adults -= 2;
        } else {
          if (adults > 0) adults--;
        }
      }
      if (category == 'children' && children > 0) children--;
      if (category == 'infants' && infants > 0) infants--;
      selectedOption = category;
    });
  }

  void _onContinue() {
    if ((widget.travelWithCategory == "Family" ||
            widget.travelWithCategory == "Friends") &&
        adults < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("At least 1 adult is required.")),
      );
      return;
    }

    final Map<String, int> people = {
      'adults': adults,
      'children': children,
      'infants': infants,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SummaryScreen(
          destination: widget.destination,
          fromCity: widget.fromCity,
          startDate: widget.startDate,
          endDate: widget.endDate,
          budgetOptions: widget.budgetOption,
          travelWith: widget.travelWithCategory,
          travelPeople: people,
        ),
      ),
    );
  }

  Widget _buildCounter(String label, int value, String option) {
    final isSelected = option == selectedOption;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
          color: isSelected ? kPrimaryColor : Colors.white24,
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white),
                onPressed: () => _decrement(option),
              ),
              Text(
                '$value',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => _increment(option),
              ),
            ],
          ),
        ],
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    'How many people are traveling?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildCounter('Adults', adults, 'adults'),
                  _buildCounter('Children', children, 'children'),
                  _buildCounter('Infants', infants, 'infants'),

                  const Spacer(),
                  CustomButton(label: 'Continue', onPressed: _onContinue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
