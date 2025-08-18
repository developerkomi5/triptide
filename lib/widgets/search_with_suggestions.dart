import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class SearchWithSuggestions extends StatefulWidget {
  const SearchWithSuggestions({super.key});

  @override
  State<SearchWithSuggestions> createState() => _SearchWithSuggestionsState();
}

class _SearchWithSuggestionsState extends State<SearchWithSuggestions> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _allDestinations = [
    'Paris',
    'New York',
    'Tokyo',
    'Goa',
    'London',
    'Manali',
    'Bali',
    'Dubai',
  ];

  List<String> _filteredDestinations = [];

  void _filterDestinations(String query) {
    setState(() {
      _filteredDestinations = _allDestinations
          .where((dest) => dest.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            onChanged: _filterDestinations,
            style: GoogleFonts.poppins(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Search destination...',
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              border: InputBorder.none,
              icon: const Icon(Icons.search, color: Colors.black54),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_filteredDestinations.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: _filteredDestinations
                  .map(
                    (dest) => GestureDetector(
                      onTap: () {
                        // TODO: Handle destination selection
                        debugPrint("Selected: $dest");
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          dest,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
