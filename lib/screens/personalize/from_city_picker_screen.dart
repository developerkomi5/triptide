import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:triptide/screens/personalize/travel_with_screen.dart';

import '../../utils/constants.dart';

class FromCityPickerScreen extends StatefulWidget {
  final String destination;
  final String durationOption;
  final String budgetOption;
  final DateTime? startDate;
  final DateTime? endDate;

  const FromCityPickerScreen({
    super.key,
    required this.destination,
    required this.durationOption,
    required this.budgetOption,
    this.startDate,
    this.endDate,
  });

  @override
  State<FromCityPickerScreen> createState() => _FromCityPickerScreenState();
}

class _FromCityPickerScreenState extends State<FromCityPickerScreen> {
  final List<String> _allCities = [
    'Ahmedabad',
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Pune',
    'Kolkata',
    'Chennai',
    'Jaipur',
    'Surat',
    'Indore',
    'Goa',
    'Lucknow',
    'Nagpur',
  ];

  List<String> _filteredCities = [];
  String _searchText = '';
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _filteredCities = _allCities;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchText = query;
      _filteredCities = _allCities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onContinue() {
    if (_selectedCity != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TravelWithScreen(
            destination: widget.destination,
            fromCity: _selectedCity,
            startDate: widget.startDate,
            endDate: widget.endDate,
            durationOption: widget.durationOption,
            budgetOption: widget.budgetOption,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select your city!')));
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    "Where are you starting from?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: _onSearchChanged,
                    style: const TextStyle(color: kTextColor),
                    decoration: InputDecoration(
                      hintText: 'Search your city...',
                      hintStyle: const TextStyle(color: kTextColor),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search, color: kTextColor),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: 3,
                    child: ListView.builder(
                      itemCount: _filteredCities.length,
                      itemBuilder: (context, index) {
                        final city = _filteredCities[index];
                        final isSelected = city == _selectedCity;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedCity = city);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  city,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white,
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
                    'Step 5 of 7',
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
