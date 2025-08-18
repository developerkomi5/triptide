// destination_picker_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:triptide/screens/personalize/trip_duration_screen.dart';
import 'package:triptide/services/unsplash_service.dart';
import 'package:triptide/utils/constants.dart';

class DestinationPickerScreen extends StatefulWidget {
  const DestinationPickerScreen({
    super.key,
    required Null Function(dynamic city) onDestinationSelected,
  });

  @override
  State<DestinationPickerScreen> createState() =>
      _DestinationPickerScreenState();
}

class _DestinationPickerScreenState extends State<DestinationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredCities = popularDestinations;

  void _filterCities(String query) async {
    final lowerQuery = query.trim().toLowerCase();
    if (lowerQuery.isEmpty) {
      setState(() {
        _filteredCities = popularDestinations;
      });
      return;
    }

    final matches = popularDestinations
        .where((city) => city.toLowerCase().contains(lowerQuery))
        .toList();

    if (matches.isNotEmpty) {
      setState(() {
        _filteredCities = matches;
      });
    } else {
      setState(() {
        _filteredCities = [];
      });
    }
  }

  void _onDestinationSelected(String city) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TripDurationScreen(selectedCity: city)),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Where do you want to go?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: _filterCities,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search destinations...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Grid of destinations
                  Expanded(
                    child: _filteredCities.isEmpty
                        ? const Center(child: Text('No destinations found.'))
                        : GridView.builder(
                            itemCount: _filteredCities.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.8,
                                ),
                            itemBuilder: (context, index) {
                              final city = _filteredCities[index];
                              return GestureDetector(
                                onTap: () => _onDestinationSelected(city),
                                child: DestinationCard(cityName: city),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    'Step 1 of 5',
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

class DestinationCard extends StatefulWidget {
  final String cityName;

  const DestinationCard({super.key, required this.cityName});

  @override
  State<DestinationCard> createState() => _DestinationCardState();
}

class _DestinationCardState extends State<DestinationCard> {
  String? _imageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCityImage();
  }

  void _loadCityImage() async {
    final imageUrl = await UnsplashService.fetchCityImage(widget.cityName);
    setState(() {
      _imageUrl = imageUrl;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fallbackImage = 'assets/images/${widget.cityName.toLowerCase()}.jpg';

    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: _isLoading
                ? const SizedBox(
                    height: 140,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : (_imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: _imageUrl!,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (_, __, ___) =>
                              Image.asset(fallbackImage, fit: BoxFit.cover),
                        )
                      : Image.asset(
                          fallbackImage,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              widget.cityName,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
