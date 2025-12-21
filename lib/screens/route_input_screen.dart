import 'package:flutter/material.dart';
import 'map_screen.dart';

class RouteInputScreen extends StatefulWidget {
  const RouteInputScreen({super.key});

  @override
  State<RouteInputScreen> createState() => _RouteInputScreenState();
}

class _RouteInputScreenState extends State<RouteInputScreen> {
  final TextEditingController startController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F4), // soft pink
      appBar: AppBar(
        title: const Text("Plan Your Safe Route"),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Title
            const Text(
              "Your Safety Matters 🌙",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Enter your start and destination.\nWe’ll find the safest route for you.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 30),

            // START LOCATION
            TextField(
              controller: startController,
              decoration: InputDecoration(
                labelText: "Starting Point",
                hintText: "Auto location or type manually",
                prefixIcon: const Icon(Icons.my_location),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // DESTINATION
            TextField(
              controller: destinationController,
              decoration: InputDecoration(
                labelText: "Destination",
                hintText: "Where do you want to go?",
                prefixIcon: const Icon(Icons.location_on),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // FIND ROUTE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                icon: const Icon(Icons.route),
                label: const Text(
                  "Find Safe Routes",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  if (destinationController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter destination"),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MapScreen(
                        startLocation: startController.text,
                        destinationLocation: destinationController.text,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
