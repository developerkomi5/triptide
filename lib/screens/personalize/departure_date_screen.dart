// departure_date_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:triptide/screens/personalize/from_city_picker_screen.dart';

import '../../utils/constants.dart';

class DepartureDateScreen extends StatefulWidget {
  final String destination;
  final String durationOption;
  final String budgetOption;

  const DepartureDateScreen({
    super.key,
    required this.destination,
    required this.durationOption,
    required this.budgetOption,
  });

  @override
  State<DepartureDateScreen> createState() => _DepartureDateScreenState();
}

class _DepartureDateScreenState extends State<DepartureDateScreen> {
  DateTime? _selectedDate;

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: kPrimaryColor,
            colorScheme: ColorScheme.dark(
              primary: kPrimaryColor,
              surface: Colors.white.withOpacity(0.9),
              onPrimary: kTextColor,
              onSurface: kTextColor,
            ),
            dialogTheme: DialogThemeData(backgroundColor: kBackgroundColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  int _durationToDays(String durationOption) {
    // pick minimal sensible days for each label
    if (durationOption.contains('Weekend')) return 2;
    if (durationOption.contains('Short')) return 4;
    if (durationOption.contains('1 Week')) return 7;
    if (durationOption.contains('10')) return 10;
    return 14; // 2 Weeks+
  }

  void _onContinue() {
    if (_selectedDate != null) {
      final int days = _durationToDays(widget.durationOption);
      final endDate = _selectedDate!.add(Duration(days: days));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FromCityPickerScreen(
            destination: widget.destination,
            durationOption: widget.durationOption,
            budgetOption: widget.budgetOption,
            startDate: _selectedDate,
            endDate: endDate,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a departure date!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _selectedDate != null
        ? DateFormat('MMMM dd, yyyy').format(_selectedDate!)
        : "Tap to select";

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
                    "When are you planning to leave?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
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
                    'Step 4 of 5',
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
