import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../data/ambasamudram_kallidai_routes.dart';
import '../data/route_data.dart';
import '../models/safety_score.dart';

class MapScreen extends StatefulWidget {
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
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    /// Glow animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    /// Show popup after screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSafestRouteDialog();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Popup dialog
  void _showSafestRouteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("🛡 Safest Route Selected"),
        content: const Text(
          "Green glowing route is safest.\n"
          "Red route is dangerous.\n"
          "Avoid red routes at night.",
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

    /// STEP 1: Calculate safety scores
    final routesWithScore = ambasamudramToKallidaiRoutes.map((route) {

      final score = SafetyScoreCalculator.calculate(route);

      return {
        "route": route,
        "score": score,
      };

    }).toList();

    /// STEP 2: Sort highest score first
    routesWithScore.sort(
      (a, b) =>
          (b["score"] as double).compareTo(a["score"] as double),
    );

    /// STEP 3: Safest route
    final safestRoute =
        routesWithScore.first["route"] as RouteData;

    /// Convert safest route points to Set for fast comparison
    final safestPointsSet = safestRoute.points
        .map((p) => "${p.latitude},${p.longitude}")
        .toSet();

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
              12 + (_animationController.value * 10);

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

  polylines: routesWithScore
      .expand<Polyline>((data) {

    final route = data["route"] as RouteData;
    final score = data["score"] as double;

    bool isSafest =
        route.routeName == safestRoute.routeName;

    /// Remove overlapping points
    List<LatLng> filteredPoints;

    if (isSafest) {

      filteredPoints = route.points;

    } else {

      filteredPoints = route.points.where((point) {

        final key =
            "${point.latitude},${point.longitude}";

        return !safestPointsSet.contains(key);

      }).toList();

    }

    if (filteredPoints.length < 2) {
      return <Polyline>[];
    }

    /// Color logic
    Color routeColor;

    if (score >= 7) {

      routeColor = Colors.green;

    } else if (score >= 4) {

      routeColor = Colors.orange;

    } else {

      routeColor = Colors.red;

    }

    /// SAFEST ROUTE
    if (isSafest) {

      return <Polyline>[

        /// Glow
        Polyline(
          points: filteredPoints,
          strokeWidth: glowWidth,
          color: Colors.green.withValues(alpha: 0.3),
        ),

        /// Main line
        Polyline(
          points: filteredPoints,
          strokeWidth: 6,
          color: Colors.green,
        ),

      ];

    }

    /// Other routes
    return <Polyline>[

      Polyline(
        points: filteredPoints,
        strokeWidth: 5,
        color: routeColor,
      ),

    ];

  }).toList(),

),


              /// MARKERS
              MarkerLayer(
                markers: [

                  /// START MARKER (Blue Circle)
                  Marker(
                    point: startPoint,
                    width: 30,
                    height: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                    ),
                  ),

                  /// DESTINATION MARKER (Red icon)
                  Marker(
                    point: endPoint,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
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
                        Icons.my_location,
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
