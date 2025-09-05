import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingHelper {
  static Future<LatLng?> getCoordinates(String cityName) async {
    final apiKey = 'da88bba21a5844448dd5c25ccab4cf4d';
    final url = Uri.parse(
      'https://api.opencagedata.com/geocode/v1/json?q=$cityName&key=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];
      if (results.isNotEmpty) {
        final geometry = results[0]['geometry'];
        final lat = geometry['lat'];
        final lng = geometry['lng'];
        return LatLng(lat, lng);
      }
    }

    return null; // If no results or error
  }
}
