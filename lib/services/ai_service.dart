import 'dart:math';

class AiService {
  final String apiKey;

  AiService(this.apiKey);

  Future<String> sendMessage(String message) async {
    final mockReplies = [
      'Let’s build your dream itinerary! 🗺️',
      'TripTide is cooking up something amazing for you...',
      'Where would you like to go next?',
    ];

    return mockReplies[Random().nextInt(mockReplies.length)];
  }
}
