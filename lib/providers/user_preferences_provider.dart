import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPreferencesProvider with ChangeNotifier {
  String _destination = '';
  String _duration = '';

  String get destination => _destination;
  String get duration => _duration;

  /// ✅ Set both destination and duration together
  void setPreferences(String destination, String duration) {
    _destination = destination;
    _duration = duration;
    notifyListeners();
  }

  /// ✅ Set destination only
  void setDestination(String value) {
    _destination = value;
    notifyListeners();
  }

  /// ✅ Set duration only
  void setDuration(String value) {
    _duration = value;
    notifyListeners();
  }

  /// ✅ Clear preferences (e.g. on logout)
  void clearPreferences() {
    _destination = '';
    _duration = '';
    notifyListeners();
  }

  /// ✅ Load preferences from Firestore after login
  Future<void> loadPreferencesFromFirestore(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (!doc.exists || doc.data()?['preferences'] == null) {
      clearPreferences();
      return;
    }

    final prefs = doc.data()!['preferences'];
    _destination = prefs['destination'] ?? '';

    final start = DateTime.tryParse(prefs['startDate'] ?? '');
    final end = DateTime.tryParse(prefs['endDate'] ?? '');

    if (start != null && end != null) {
      _duration = (end.difference(start).inDays + 1).toString();
    } else {
      _duration = '';
    }

    notifyListeners();
  }
}
