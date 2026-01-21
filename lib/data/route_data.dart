import 'package:latlong2/latlong.dart';

class RouteData {
  final String routeName;
  final List<LatLng> points;

  final int policeCount;
  final int hospitalCount;
  final bool hasCCTV;
  final bool hasStreetLights;

  RouteData({
    required this.routeName,
    required this.points,
    required this.policeCount,
    required this.hospitalCount,
    required this.hasCCTV,
    required this.hasStreetLights,
  });
}
