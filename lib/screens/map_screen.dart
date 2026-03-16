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

  /// store route scores
  Map<RouteData, int> routeScores = {};

  final Distance distance = const Distance();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    loadRoutes();
  }

  /// LOAD ROUTES
  void loadRoutes() {

    String start = widget.startPlace.toLowerCase().trim();
    String end = widget.destinationPlace.toLowerCase().trim();

    if (start == AmbasamudramKallidaikurichiData.startName &&
        end == AmbasamudramKallidaikurichiData.endName) {

      routes = AmbasamudramKallidaikurichiData.routes;
      routeAvailable = true;

      /// calculate scores
      for (var route in routes) {

        int score = SafetyScore.calculate(
          cctv: route.hasCCTV ? 1 : 0,
          police: route.policeCount,
          hospital: route.hospitalCount,
          streetLight: route.hasStreetLights ? 1 : 0,
        );

        routeScores[route] = score;
      }

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

  /// SAFEST ROUTE
  RouteData getSafestRoute() {

    routes.sort((a, b) =>
        routeScores[b]!.compareTo(routeScores[a]!));

    return routes.first;
  }

  /// TAP DETECTION
  void onMapTap(LatLng tappedPoint) {

    RouteData? selectedRoute;

    double minDistance = double.infinity;

    for (var route in routes) {

      for (var point in route.points) {

        double d = distance.as(
          LengthUnit.Meter,
          tappedPoint,
          point,
        );

        if (d < minDistance) {
          minDistance = d;
          selectedRoute = route;
        }
      }
    }

    if (selectedRoute != null && minDistance < 200) {

      int score = routeScores[selectedRoute]!;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(

          title: Text(selectedRoute!.routeName),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("Safety Score : $score"),

              const SizedBox(height: 10),

              Text("Police Stations : ${selectedRoute.policeCount}"),
              Text("Hospitals : ${selectedRoute.hospitalCount}"),

              Text(
                "CCTV : ${selectedRoute.hasCCTV ? "Yes" : "No"}",
              ),

              Text(
                "Street Lights : ${selectedRoute.hasStreetLights ? "Yes" : "No"}",
              ),

            ],
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],

        ),
      );
    }
  }

  /// SAFEST ROUTE POPUP
  void _showSafestRouteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("🛡 Safest Route Selected"),
        content: const Text(
          "Green route is safest\n"
          "Orange route is moderate\n"
          "Red route is risky\n\n"
          "Tap any route to see safety details.",
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

    if (!routeAvailable) {
      return Scaffold(
        appBar: AppBar(
          title: Text("${widget.startPlace} → ${widget.destinationPlace}"),
        ),
        body: const Center(
          child: Text("Route datapoints coming soon"),
        ),
      );
    }

    RouteData safestRoute = getSafestRoute();

    LatLng startPoint = safestRoute.points.first;
    LatLng endPoint = safestRoute.points.last;

    return Scaffold(

      appBar: AppBar(
        title: Text("${widget.startPlace} → ${widget.destinationPlace}"),
      ),

      body: AnimatedBuilder(

        animation: _animationController,

        builder: (context, child) {

          double glowWidth = 10 + (_animationController.value * 8);

          return FlutterMap(

            options: MapOptions(
              initialCenter: startPoint,
              initialZoom: 13,
              onTap: (tapPosition, latlng) {
                onMapTap(latlng);
              },
            ),

            children: [

              TileLayer(
                urlTemplate:
                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName:
                    'com.example.women_night_corridor_map',
              ),

              /// ROUTES
              PolylineLayer(
                polylines: routes.map((route) {

                  int score = routeScores[route]!;

                  Color color;

                  if (route.routeName == safestRoute.routeName) {
                    color = Colors.green;
                  } else if (score >= 40) {
                    color = Colors.orange;
                  } else {
                    color = Colors.red;
                  }

                  double width =
                      route.routeName == safestRoute.routeName
                          ? glowWidth
                          : 5;

                  return Polyline(
                    points: route.points,
                    strokeWidth: width,
                    color: color.withOpacity(0.8),
                  );

                }).toList(),
              ),

              /// MARKERS
              MarkerLayer(
                markers: [

                  Marker(
                    point: startPoint,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                    ),
                  ),

                  Marker(
                    point: endPoint,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                  ),

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