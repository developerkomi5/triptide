import 'dart:convert';
import 'package:http/http.dart' as http;

class UnsplashService {
  static const String _accessKey =
      'T7EZXkdVflfiWs75PGTsG5aaT0rGXdQEV78FqZAp4m8';

  static Future<String?> fetchCityImage(String cityName) async {
    final url = Uri.parse(
      'https://api.unsplash.com/search/photos?page=1&query=$cityName&client_id=$_accessKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          return data['results'][0]['urls']['regular'];
        }
      }
    } catch (e) {
      print('Error fetching Unsplash image: $e');
    }

    return null;
  }
}
