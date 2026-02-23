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

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSafestRouteDialog();
    });

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showSafestRouteDialog() {

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("🛡 Safest Route Selected"),
        content: const Text(
            "Green glowing route is safest.\nRed route is dangerous.\nAvoid red routes at night."),
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

    /// CALCULATE SCORES
    final routesWithScore = ambasamudramToKallidaiRoutes.map((route) {

      final score = SafetyScoreCalculator.calculate(route);

      return {
        "route": route,
        "score": score,
      };

    }).toList();

    /// SORT BY BEST SCORE
    routesWithScore.sort(
      (a, b) =>
          (b["score"] as double).compareTo(a["score"] as double),
    );

    final safestRoute =
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
              12 + (_animationController.value * 10);

          return FlutterMap(

            options: MapOptions(
              initialCenter: startPoint,
              initialZoom: 13,
            ),

            children: [

              /// MAP
              TileLayer(
                urlTemplate:
                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName:
                    'com.example.women_night_corridor_map',
              ),

              /// ROUTES
              PolylineLayer(

                polylines: routesWithScore.expand((data) {

                  final route =
                      data["route"] as RouteData;

                  final score =
                      data["score"] as double;

                  bool isSafest =
                      route.routeName ==
                          safestRoute.routeName;

                  /// COLOR LOGIC
                  Color routeColor;

                  if (score >= 7) {

                    routeColor = Colors.green;

                  } else if (score >= 4) {

                    routeColor = Colors.orange;

                  } else {

                    routeColor = Colors.red;

                  }

                  /// SAFEST ROUTE GLOW
                  if (isSafest) {

                    return [

                      /// GLOW
                      Polyline(
                        points: route.points,
                        strokeWidth: glowWidth,
                        color: Colors.green.withValues(alpha: 0.3),
                      ),

                      /// MAIN LINE
                      Polyline(
                        points: route.points,
                        strokeWidth: 6,
                        color: Colors.green,
                      ),

                    ];

                  }

                  /// OTHER ROUTES
                  return [

                    Polyline(
                      points: route.points,
                      strokeWidth: 5,
                      color: routeColor,
                    )

                  ];

                }).toList(),

              ),

              /// MARKERS
              MarkerLayer(
                markers: [

                  /// START
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

                  /// DESTINATION
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
