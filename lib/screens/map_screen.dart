import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final String startPlace;
  final String destinationPlace;

  const MapScreen({
    super.key,
    required this.startPlace,
    required this.destinationPlace,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destinationPlace),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: currentLocation!,
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate:
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName:
                "com.example.women_night_corridor_map",
          ),

          // Temporary demo route
          PolylineLayer(
            polylines: [
              Polyline(
                points: [
                  currentLocation!,
                  LatLng(
                    currentLocation!.latitude + 0.01,
                    currentLocation!.longitude + 0.01,
                  ),
                ],
                strokeWidth: 5,
                color: Colors.green,
              ),
            ],
          ),

          MarkerLayer(
            markers: [
              Marker(
                point: currentLocation!,
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
