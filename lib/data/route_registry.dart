import 'ambasamudram_kallidaikurichi_data.dart';

class RouteRegistry {

  static dynamic getRouteData(String start, String end) {

    start = start.toLowerCase();
    end = end.toLowerCase();

    if (start == AmbasamudramKallidaikurichiData.startName &&
        end == AmbasamudramKallidaikurichiData.endName) {

      return AmbasamudramKallidaikurichiData();  // ✅ OBJECT
    }

    return null;
  }
}