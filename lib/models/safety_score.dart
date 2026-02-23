import '../data/route_data.dart';

class SafetyScoreCalculator {
  static double calculate(RouteData route) {
    double score = 0;

    // 🛂 Police presence
    score += route.policeCount * 2.0;

    // 🏥 Hospitals
    score += route.hospitalCount * 1.5;

    // 🎥 CCTV
    if (route.hasCCTV) score += 3.0;

    // 💡 Street lights
    if (route.hasStreetLights) score += 2.0;

    return score;
  }

  static String getRiskLevel(double score) {
    if (score >= 8) return "Safe";
    if (score >= 5) return "Moderate";
    return "Risky";
  }
}
