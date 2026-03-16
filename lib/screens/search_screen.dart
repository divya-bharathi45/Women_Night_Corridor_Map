import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/database_service.dart';
import 'map_screen.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController startPlaceController = TextEditingController();
  final TextEditingController destinationPlaceController = TextEditingController();

  bool usingCurrentLocation = false;
  bool loadingLocation = false;

  Position? userPosition;

  /// GET USER CURRENT LOCATION
  Future<void> useMyLocation() async {

    setState(() {
      loadingLocation = true;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      _showSnack("Please enable location services");
      setState(() => loadingLocation = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {

      _showSnack("Location permission denied");
      setState(() => loadingLocation = false);
      return;
    }

    userPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      usingCurrentLocation = true;
      startPlaceController.text = "My Current Location";
      loadingLocation = false;
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    startPlaceController.dispose();
    destinationPlaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Plan Safe Route"),
        backgroundColor: Colors.pinkAccent,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// SAFETY MESSAGE
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Your safety matters. Choose the safest route.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// START PLACE
            TextField(
              controller: startPlaceController,
              readOnly: usingCurrentLocation,
              decoration: InputDecoration(
                labelText: "Start Place",
                prefixIcon: const Icon(Icons.my_location),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            loadingLocation
                ? const Center(child: CircularProgressIndicator())
                : TextButton.icon(
                    onPressed: useMyLocation,
                    icon: const Icon(Icons.gps_fixed),
                    label: const Text("Use My Current Location"),
                  ),

            const SizedBox(height: 20),

            /// DESTINATION PLACE
            TextField(
              controller: destinationPlaceController,
              decoration: InputDecoration(
                labelText: "Destination Place",
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// FIND ROUTE BUTTON
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed: () async {

                  String start = startPlaceController.text.trim();
                  String destination = destinationPlaceController.text.trim();

                  if (start.isEmpty && !usingCurrentLocation) {
                    _showSnack("Enter start place or use current location");
                    return;
                  }

                  if (destination.isEmpty) {
                    _showSnack("Enter destination place");
                    return;
                  }

                  /// SAVE SEARCH HISTORY
                  await DatabaseService.saveSearch(start, destination);

                  /// NAVIGATE TO MAP
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MapScreen(
                        startPlace: start,
                        destinationPlace: destination,
                        userPosition: userPosition,
                      ),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                child: const Text(
                  "Find Route",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}