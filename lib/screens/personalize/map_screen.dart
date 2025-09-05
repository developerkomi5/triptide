import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:triptide/utils/geocoding_helper.dart';

class MapScreen extends StatefulWidget {
  final String cityName;

  const MapScreen({Key? key, required this.cityName}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _coordinates;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchCoordinates();
  }

  Future<void> _fetchCoordinates() async {
    final coords = await GeocodingHelper.getCoordinates(widget.cityName);
    setState(() {
      _coordinates = coords;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map of ${widget.cityName}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _coordinates == null
          ? const Center(child: Text('Could not find location'))
          : FlutterMap(
              options: MapOptions(
                initialCenter: _coordinates!,
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _coordinates!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
