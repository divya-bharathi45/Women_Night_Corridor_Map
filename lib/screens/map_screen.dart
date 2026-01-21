import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../data/ambasamudram_kallidai_routes.dart';

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
    // 🟢 Center map using dataset
    final LatLng center =
        ambasamudramToKallidaiRoutes.first.points.first;

    return Scaffold(
      appBar: AppBar(
        title: Text("$startPlace → $destinationPlace"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: 13,
          minZoom:5,
          maxZoom:19,
        ),
        children: [
          // 🗺 OpenStreetMap
          TileLayer(
            urlTemplate:
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName:
                'com.example.women_night_corridor_map',
          ),

          // 🟢 ROUTE POLYLINES
          PolylineLayer(
            polylines: ambasamudramToKallidaiRoutes.map((route) {
              return Polyline(
                points: route.points,
                strokeWidth: 5,
                color: Colors.green,
              );
            }).toList(),
          ),

          // 🔵 USER CURRENT LOCATION
          if (userPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    userPosition!.latitude,
                    userPosition!.longitude,
                  ),
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
