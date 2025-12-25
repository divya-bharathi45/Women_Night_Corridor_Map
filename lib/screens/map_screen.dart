import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Map"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Start: $startPlace"),
            const SizedBox(height: 10),
            Text("Destination: $destinationPlace"),
            const SizedBox(height: 20),
            if (userPosition != null)
              Text(
                  "Lat: ${userPosition!.latitude}, Lng: ${userPosition!.longitude}"),
          ],
        ),
      ),
    );
  }
}
