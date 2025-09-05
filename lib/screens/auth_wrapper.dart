import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triptide/providers/user_preferences_provider.dart';
import 'package:triptide/screens/personalize/destination_picker_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<Map<String, dynamic>> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return {'screen': 'login'};
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists && userDoc.data()?['preferences'] != null) {
      final prefs = userDoc.data()?['preferences'];
      final destination = prefs?['destination'] ?? '';
      final startDate = prefs?['startDate'];
      final endDate = prefs?['endDate'];

      print('Destination: $destination');
      print('Start: $startDate');
      print('End: $endDate');

      String durationLabel = '';
      if (startDate != null && endDate != null) {
        final start = DateTime.tryParse(startDate);
        final end = DateTime.tryParse(endDate);

        if (start != null && end != null) {
          final days = end.difference(start).inDays + 1;

          if (days <= 3) {
            durationLabel = 'Weekend (2-3 days)';
          } else if (days <= 5) {
            durationLabel = 'Short trip (4-5 days)';
          } else if (days <= 7) {
            durationLabel = 'One Week';
          } else if (days <= 10) {
            durationLabel = '10 Days';
          } else {
            durationLabel = 'Long vacation (14+ days)';
          }
        }
      }

      print('Duration label: $durationLabel');

      if (destination.isEmpty || durationLabel.isEmpty) {
        return {'screen': 'picker'};
      }

      return {
        'screen': 'home',
        'destination': destination,
        'duration': durationLabel,
      };
    } else {
      return {'screen': 'picker'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("Something went wrong")),
          );
        } else {
          final result = snapshot.data!;
          final screen = result['screen'];

          if (screen == 'login') {
            return const LoginScreen();
          } else if (screen == 'home') {
            final destination = result['destination'] ?? '';
            final duration = result['duration'] ?? '';

            WidgetsBinding.instance.addPostFrameCallback((_) {
              final prefs = Provider.of<UserPreferencesProvider>(
                context,
                listen: false,
              );
              prefs.setDestination(destination);
              prefs.setDuration(duration);
            });

            return const HomeScreen();
          } else {
            return DestinationPickerScreen(
              onDestinationSelected: (city) {
                print('Selected City: $city');
              },
            );
          }
        }
      },
    );
  }
}
