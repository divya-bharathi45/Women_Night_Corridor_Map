import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'map_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController startPlaceController = TextEditingController();
  final TextEditingController destinationPlaceController =
      TextEditingController();

  bool usingCurrentLocation = false;
  Position? userPosition;
  bool loadingLocation = false;

  // 📍 Ask permission + fetch location
  Future<void> useMyLocation() async {
    setState(() => loadingLocation = true);

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission permanently denied")),
      );
      setState(() => loadingLocation = false);
      return;
    }

    userPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      usingCurrentLocation = true;
      startPlaceController.text = "My Current Location";
      loadingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Enter Route Details"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Your Safety Matters 🩵",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlueAccent),
            ),
            const SizedBox(height: 20),

            // START PLACE
            TextField(
              controller: startPlaceController,
              readOnly: usingCurrentLocation,
              decoration: InputDecoration(
                labelText: "Start Place",
                prefixIcon: const Icon(Icons.my_location),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 10),

            // USE MY LOCATION BUTTON
            loadingLocation
                ? const CircularProgressIndicator()
                : TextButton.icon(
                    onPressed: useMyLocation,
                    icon: const Icon(Icons.gps_fixed),
                    label: const Text("Use My Current Location"),
                  ),

            const SizedBox(height: 20),

            // DESTINATION
            TextField(
              controller: destinationPlaceController,
              decoration: InputDecoration(
                labelText: "Destination Place",
                prefixIcon: const Icon(Icons.location_on),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                if (destinationPlaceController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter destination")),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MapScreen(
                      startPlace: startPlaceController.text,
                      destinationPlace: destinationPlaceController.text,
                      userPosition: userPosition,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                     shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                
              ),
              child: const Text(
                "Find Route",style: TextStyle(fontSize: 18)),
              
            )
          ],
        ),
      ),
    );
  }
}
