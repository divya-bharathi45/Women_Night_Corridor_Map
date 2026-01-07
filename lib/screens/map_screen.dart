import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatelessWidget {
  final String startPlace;
  final String destinationPlace;
  final Position? userPosition;

  const MapScreen({
    super.key,
    required this.startPlace,
    required this.destinationPlace,
    required this.userPosition,
  });

  @override
  Widget build(BuildContext context) {
    LatLng center = userPosition != null
        ? LatLng(userPosition!.latitude, userPosition!.longitude)
        : const LatLng(8.703596, 77.448539); // Tirunelveli fallback

    return Scaffold(
      appBar: AppBar(
        title: Text("$startPlace → $destinationPlace"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName:
                'com.example.women_night_corridor_map',
          ),

          if (userPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: center,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
