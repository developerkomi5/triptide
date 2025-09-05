import 'package:flutter/foundation.dart';
import '../services/itinerary_service.dart';
import '../models/itinerary_model.dart';

class ItineraryProvider extends ChangeNotifier {
  final ItineraryService _service;

  ItineraryProvider([ItineraryService? service])
    : _service = service ?? ItineraryService();

  List<ItineraryModel> _items = [];
  bool _loading = false;
  String? _error;

  List<ItineraryModel> get items => _items;
  bool get loading => _loading;
  String? get error => _error;
  bool get hasError => _error != null;

  /// Fetch itineraries by destination only
  Future<void> fetchByDestination(String destination) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _service.fetchByDestination(destination);
    } catch (e) {
      _error = e.toString();
      _items = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ✅ New: Fetch itineraries by destination AND duration
  Future<void> fetchByDestinationAndDuration(
    String destination,
    String duration,
  ) async {
    print('API call: ?destination=$destination&duration=$duration');
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _service.fetchByDestinationAndDuration(
        destination,
        duration,
      );
    } catch (e) {
      _error = e.toString();
      _items = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
