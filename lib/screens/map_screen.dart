import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../data/ambasamudram_kallidaikurichi_data.dart';
import '../models/route_data.dart';
import '../models/safety_score.dart';

class MapScreen extends StatefulWidget {
  final String startPlace;
  final String destinationPlace;
  final Position? userPosition;

  const MapScreen({
    super.key,
    required this.startPlace,
    required this.destinationPlace,
    this.userPosition,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _animationController;

  List<RouteData> routes = [];
  bool routeAvailable = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    loadRoutes();
  }

  /// LOAD ROUTES BASED ON USER INPUT
  void loadRoutes() {

    String start = widget.startPlace.toLowerCase().trim();
    String end = widget.destinationPlace.toLowerCase().trim();

    /// CHECK IF DATASET EXISTS
    if (start == AmbasamudramKallidaikurichiData.startName &&
        end == AmbasamudramKallidaikurichiData.endName) {

      routes = AmbasamudramKallidaikurichiData.routes;
      routeAvailable = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSafestRouteDialog();
      });

    } else {

      routeAvailable = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Route datapoints coming soon"),
          ),
        );
      });
    }

    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// SAFEST ROUTE INFO POPUP
  void _showSafestRouteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("🛡 Safest Route Selected"),
        content: const Text(
          "Green glowing route is the safest.\n"
          "Red routes are less safe.\n"
          "Choose safer paths at night.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    /// IF NO ROUTE DATA
    if (!routeAvailable) {

      return Scaffold(

        appBar: AppBar(
          title: Text("${widget.startPlace} → ${widget.destinationPlace}"),
          backgroundColor: Colors.deepPurple,
        ),

        body: const Center(
          child: Text(
            "Route datapoints coming soon",
            style: TextStyle(fontSize: 18),
          ),
        ),

      );
    }

    /// CALCULATE SAFETY SCORE
    final routesWithScore = routes.map((route) {

      final score = SafetyScore.calculate(
        cctv: route.hasCCTV ? 1 : 0,
        police: route.policeCount,
        hospital: route.hospitalCount,
        streetLight: route.hasStreetLights ? 1 : 0,
      );

      return {
        "route": route,
        "score": score,
      };

    }).toList();

    /// SORT BY SAFETY
    routesWithScore.sort(
      (a, b) =>
          (b["score"] as int).compareTo(a["score"] as int),
    );

    final RouteData safestRoute =
        routesWithScore.first["route"] as RouteData;

    final LatLng startPoint = safestRoute.points.first;
    final LatLng endPoint = safestRoute.points.last;

    return Scaffold(

      appBar: AppBar(
        title: Text("${widget.startPlace} → ${widget.destinationPlace}"),
        backgroundColor: Colors.deepPurple,
      ),

      body: AnimatedBuilder(

        animation: _animationController,

        builder: (context, child) {

          double glowWidth =
              12 + (_animationController.value * 8);

          return FlutterMap(

            options: MapOptions(
              initialCenter: startPoint,
              initialZoom: 13,
            ),

            children: [

              /// MAP TILES
              TileLayer(
                urlTemplate:
                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName:
                    'com.example.women_night_corridor_map',
              ),

              /// ROUTE POLYLINES
              PolylineLayer(
                polylines: routes.map((route) {

                  bool isSafest =
                      route.routeName == safestRoute.routeName;

                  Color routeColor =
                      isSafest ? Colors.green : Colors.red;

                  if (isSafest) {

                    return Polyline(
                      points: route.points,
                      strokeWidth: glowWidth,
                      color: Colors.green.withOpacity(0.4),
                    );

                  }

                  return Polyline(
                    points: route.points,
                    strokeWidth: 5,
                    color: routeColor,
                  );

                }).toList(),
              ),

              /// MARKERS
              MarkerLayer(
                markers: [

                  /// START
                  Marker(
                    point: startPoint,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),

                  /// DESTINATION
                  Marker(
                    point: endPoint,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 35,
                    ),
                  ),

                  /// USER LOCATION
                  if (widget.userPosition != null)
                    Marker(
                      point: LatLng(
                        widget.userPosition!.latitude,
                        widget.userPosition!.longitude,
                      ),
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.blueAccent,
                        size: 30,
                      ),
                    ),

                ],
              ),

            ],

          );

        },

      ),

    );
  }
}