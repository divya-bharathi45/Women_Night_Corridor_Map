import 'package:latlong2/latlong.dart';
import '../models/route_data.dart';

class AmbasamudramKallidaikurichiData {

  static const String startName = "ambasamudram";
  static const String endName = "kallidaikurichi";

  static final LatLng start = LatLng(8.7139, 77.4520);
  static final LatLng end = LatLng(8.6853, 77.4652);

  static final List<RouteData> routes = [

    RouteData(
      routeName: "Route 1",
      points: [
        LatLng(8.7139, 77.4520),
        LatLng(8.7050, 77.4550),
        LatLng(8.6950, 77.4600),
        LatLng(8.6853, 77.4652),
      ],
      policeCount: 3,
      hospitalCount: 2,
      hasCCTV: true,
      hasStreetLights: true,
    ),

    RouteData(
      routeName: "Route 2",
      points: [
        LatLng(8.7139, 77.4520),
        LatLng(8.7100, 77.4600),
        LatLng(8.6950, 77.4630),
        LatLng(8.6853, 77.4652),
      ],
      policeCount: 1,
      hospitalCount: 1,
      hasCCTV: false,
      hasStreetLights: true,
    ),

    RouteData(
      routeName: "Route 3",
      points: [
        LatLng(8.7139, 77.4520),
        LatLng(8.7080, 77.4500),
        LatLng(8.6950, 77.4550),
        LatLng(8.6853, 77.4652),
      ],
      policeCount: 2,
      hospitalCount: 1,
      hasCCTV: true,
      hasStreetLights: false,
    ),

  ];
}