import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
         title : const Text(
              "Women Night Corridor Map",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),centerTitle:true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           

            const SizedBox(height: 40),

            Icon(Icons.location_on, size: 80, color: Colors.blue),

            const SizedBox(height: 20),

            Text(
              "Find the Safest Route at Night",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              icon: Icon(Icons.route_rounded),
              label: Text("Find Safe Route"),
              onPressed: () {
                // Navigate to destination screen later
              },
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              icon: Icon(Icons.warning_rounded),
              label: Text("SOS"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // SOS logic later
              },
            ),
          ],
        ),
      ),
    );
  }
}
