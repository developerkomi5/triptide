import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/itinerary_model.dart';

class ItineraryService {
  // Replace with your real endpoint
  static const _baseUrl = 'https://68a2d7a0c5a31eb7bb1dff2d.mockapi.io/api/k5';

  /// Fetch itineraries by destination only
  Future<List<ItineraryModel>> fetchByDestination(String destination) async {
    final uri = Uri.parse('$_baseUrl/itineraries?search=$destination');
    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      print('Response body: ${resp.body}');
      throw Exception('API error: ${resp.statusCode}');
    }

    final List data = jsonDecode(resp.body);
    return data
        .map((item) => ItineraryModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  /// ✅ New: Fetch itineraries by destination AND duration
  Future<List<ItineraryModel>> fetchByDestinationAndDuration(
    String destination,
    String duration,
  ) async {
    final uri = Uri.parse(
      '$_baseUrl/itineraries?destination=$destination&duration=$duration',
    );
    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      print('Response body: ${resp.body}');
      throw Exception('API error: ${resp.statusCode}');
    }

    final List data = jsonDecode(resp.body);
    return data
        .map((item) => ItineraryModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
