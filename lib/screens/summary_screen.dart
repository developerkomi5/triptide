// summary_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:triptide/screens/home_screen.dart';

import '../../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/saving_loader.dart';

class SummaryScreen extends StatefulWidget {
  final String? destination;
  final String? fromCity;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? budgetOptions;
  final String? travelWith;
  final Map<String, int>? travelPeople;

  const SummaryScreen({
    super.key,
    this.destination,
    this.fromCity,
    this.startDate,
    this.endDate,
    this.budgetOptions,
    this.travelWith,
    this.travelPeople,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _isSaving = false;

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day}/${date.month}/${date.year}";
  }

  String _displayPeople() {
    if (widget.travelPeople == null) return "-";
    return "${widget.travelPeople!['adults']} Adults, "
        "${widget.travelPeople!['children']} Children, "
        "${widget.travelPeople!['infants']} Infants";
  }

  Future<void> _savePreferences() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    setState(() => _isSaving = true);

    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

    try {
      await userDoc.update({
        "preferences": {
          "fromCity": widget.fromCity ?? "-",
          "destination": widget.destination ?? "-",
          "startDate": widget.startDate?.toIso8601String(),
          "endDate": widget.endDate?.toIso8601String(),
          "budget": widget.budgetOptions ?? "-",
          "travelWith": widget.travelWith ?? "-",
          "travelPeople": {
            "adults": widget.travelPeople?['adults'] ?? 0,
            "children": widget.travelPeople?['children'] ?? 0,
            "infants": widget.travelPeople?['infants'] ?? 0,
          },
        },
      });

      await Future.delayed(const Duration(seconds: 1));

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error saving trip: $e")));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          /// Background animation
          Positioned.fill(
            child: Lottie.asset(
              'assets/animations/login.json',
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),

          /// Foreground content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Spacer(),

                  /// Title
                  Text(
                    "Your Trip Summary",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Summary card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryTile("From", widget.fromCity ?? "-"),
                        _buildSummaryTile(
                          "Destination",
                          widget.destination ?? "-",
                        ),
                        _buildSummaryTile(
                          "Start Date",
                          _formatDate(widget.startDate),
                        ),
                        _buildSummaryTile(
                          "End Date",
                          _formatDate(widget.endDate),
                        ),
                        _buildSummaryTile(
                          "Trip Budget",
                          widget.budgetOptions ?? "-",
                        ),
                        _buildSummaryTile(
                          "Who’s Traveling",
                          widget.travelWith ?? "-",
                        ),
                        _buildSummaryTile("People Count", _displayPeople()),

                        const SizedBox(height: 20),
                        CustomButton(
                          label: "Finish & Save",
                          onPressed: _isSaving
                              ? null
                              : () => _savePreferences(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isSaving) const SavingLoader(),
        ],
      ),
    );
  }

  Widget _buildSummaryTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
