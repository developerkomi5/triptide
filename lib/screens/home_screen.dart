import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triptide/providers/user_preferences_provider.dart';
import 'package:triptide/screens/chatbot_screen.dart';
import 'package:triptide/screens/itinerary_detail_screen.dart';
import 'package:triptide/screens/login_screen.dart';
import 'package:triptide/screens/personalize/map_screen.dart';
import '../providers/itinerary_provider.dart';
import '../widgets/itinerary_day_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefs = Provider.of<UserPreferencesProvider>(
        context,
        listen: false,
      );

      if (prefs.destination.isNotEmpty && prefs.duration.isNotEmpty) {
        print('HomeScreen prefs: ${prefs.destination}, ${prefs.duration}');
        _searchController.text = prefs.destination;
        _searchItinerary(prefs.destination, prefs.duration);
      } else {
        print('No preferences found — skipping auto-fetch');
      }
    });
  }

  String _toTitleCase(String input) {
    return input
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  Future<void> _searchItinerary(String destination, String duration) async {
    String normalizedDestination = _toTitleCase(destination.trim());
    String normalizedDuration = _normalizeDuration(duration.trim());

    print(
      'API call: ?destination=$normalizedDestination&duration=$normalizedDuration',
    );
    print('Searching for: $normalizedDestination, $normalizedDuration');

    if (normalizedDestination.isEmpty || normalizedDuration.isEmpty) return;

    setState(() => _loading = true);
    try {
      await context.read<ItineraryProvider>().fetchByDestinationAndDuration(
        normalizedDestination,
        normalizedDuration,
      );
    } catch (e) {
      print('Error fetching itinerary: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  String _normalizeDuration(String input) {
    final regex = RegExp(r'\d+');
    final match = regex.firstMatch(input);
    return match?.group(0) ??
        input; // Extracts "14" from "Long vacation (14+ days)"
  }

  Future<void> _searchDestination(String destination) async {
    if (destination.trim().isEmpty) return;
    setState(() => _loading = true);
    try {
      await context.read<ItineraryProvider>().fetchByDestination(destination);
    } catch (e) {
      print('Error fetching: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _onRefresh() async {
    final prefs = Provider.of<UserPreferencesProvider>(context, listen: false);
    final destination = prefs.destination;
    final duration = prefs.duration;

    await _searchItinerary(destination, duration);
  }

  void _openMapPicker() {
    final prefs = Provider.of<UserPreferencesProvider>(context, listen: false);
    final selectedCity = prefs.destination.trim();

    if (selectedCity.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No city selected. Please choose a destination first.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MapScreen(cityName: selectedCity)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItineraryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TripTide'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            tooltip: 'Pick from Map',
            onPressed: _openMapPicker,
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'AI Suggest',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatBotScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              // ✅ Clear preferences
              context.read<UserPreferencesProvider>().clearPreferences();

              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by destination',
                hintText: 'e.g. Dubai, Tokyo, Bali etc..',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchDestination(_searchController.text),
                ),
              ),
              onSubmitted: _searchDestination,
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                ? _buildErrorUi(provider.error!)
                : provider.items.isEmpty
                ? _buildEmptyUi()
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: provider.items.length,
                      itemBuilder: (context, index) {
                        print(
                          'Rendering: ${provider.items.length} itineraries',
                        );
                        final itinerary = provider.items[index];
                        return _buildItineraryCard(itinerary);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorUi(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Error: $message'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _searchDestination(_searchController.text),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyUi() {
    return Center(
      child: Text(
        "No itineraries found.\nTry a different destination or pull to refresh.",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildItineraryCard(itinerary) {
    final daysData = List.generate(
      itinerary.days.length,
      (i) => itinerary.getActivitiesForDay(i),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              itinerary.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: daysData.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  return ItineraryDayCard(
                    dayNumber: idx + 1,
                    activities: daysData[idx],
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ItineraryDetailScreen(itineraryModel: itinerary),
                    ),
                  );
                },
                child: const Text('View Details'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
