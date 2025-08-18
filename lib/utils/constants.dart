import 'package:flutter/material.dart';

/// Primary App Colors
const Color kPrimaryColor = Color(0xFF009CA6); // Ocean Teal
const Color kTextColor = Color(0xFF0F1E36); // Deep Navy
const Color kCardColor = Color(0xFFC1C8CD); // Cloud Gray
const Color kBackgroundColor = Color(0xFFF5F6F7); // Mist White

/// Popular Destination Names (used for personalization/search)
const List<String> popularDestinations = [
  'Paris',
  'Tokyo',
  'New York',
  'Bali',
  'London',
  'Sydney',
  'Rome',
  'Dubai',
  'Istanbul',
  'Bangkok',
];

/// Map city names to their corresponding local fallback asset image
const Map<String, String> cityFallbackAssets = {
  'Paris': 'assets/images/paris.jpg',
  'Tokyo': 'assets/images/tokyo.jpg',
  'New York': 'assets/images/new_york.jpg',
  'Bali': 'assets/images/bali.jpg',
  'London': 'assets/images/london.jpg',
  'Sydney': 'assets/images/sydney.jpg',
  'Rome': 'assets/images/rome.jpg',
  'Dubai': 'assets/images/dubai.jpg',
  'Istanbul': 'assets/images/istanbul.jpg',
  'Bangkok': 'assets/images/bangkok.jpg',
};

/// Unsplash API Access Key (⚠️ Store this securely in real apps!)
const String unsplashAccessKey = 'YOUR_UNSPLASH_ACCESS_KEY';
