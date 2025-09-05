import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ItineraryModel {
  final String id;
  final String title;
  final String destination;
  final String duration;
  final String startDate;
  final String endDate;
  final double budget;
  final int people;
  final List<Map<String, dynamic>> days;
  final LatLng? mapCenter;

  ItineraryModel({
    required this.id,
    required this.title,
    required this.destination,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.people,
    required this.days,
    this.mapCenter,
  });

  factory ItineraryModel.fromMap(Map<String, dynamic> map) {
    return ItineraryModel(
      id: map['id'] ?? '',
      title: map['title'] ?? 'Untitled',
      destination: map['destination'] ?? 'Unknown',
      duration: map['duration'] ?? 'Unknown duration',
      startDate: _parseDate(map['startDate']),
      endDate: _parseDate(map['endDate']),
      budget: (map['budget'] ?? 0).toDouble(),
      people: (map['people'] ?? 1).toInt(),
      days: List<Map<String, dynamic>>.from(map['days'] ?? []),
      mapCenter: map['mapCenter'] != null
          ? LatLng(
              (map['mapCenter']['lat'] ?? 0.0).toDouble(),
              (map['mapCenter']['lng'] ?? 0.0).toDouble(),
            )
          : null,
    );
  }

  static String _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toIso8601String().split('T').first;
    } else if (value is String) {
      try {
        final parsed = DateTime.parse(value);
        return parsed.toIso8601String().split('T').first;
      } catch (_) {
        return 'N/A';
      }
    } else {
      return 'N/A';
    }
  }

  /// ✅ Safe helper to extract activities for a given day
  List<String> getActivitiesForDay(int dayIndex) {
    if (dayIndex >= 0 && dayIndex < days.length) {
      final activities = days[dayIndex]['activities'];
      if (activities is List) {
        return List<String>.from(activities.whereType<String>());
      }
    }
    return [];
  }
}
