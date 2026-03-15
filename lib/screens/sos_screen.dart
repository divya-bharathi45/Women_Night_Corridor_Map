import 'package:flutter/material.dart';
import '../services/sos_service.dart';

class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  Future<void> _sendSOS(BuildContext context) async {

    await SOSService.sendSOSMessage();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🚨 SOS Alert Sent Successfully"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF1E2246),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(235, 207, 66, 66),
        elevation: 0,
        title: const Text("Emergency SOS"),
        centerTitle: true,
      ),

      body: Center(

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// WARNING ICON
              const Icon(
                Icons.warning_rounded,
                size: 150,
                color: Colors.redAccent,
              ),

              const SizedBox(height: 20),

              /// TITLE
              const Text(
                "Send Emergency Alert",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              /// DESCRIPTION
              const Text(
                "This will send an emergency alert message\n"
                "to your emergency contacts.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 50),

              /// SEND SOS BUTTON
              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  onPressed: () => _sendSOS(context),

                  child: const Text(
                    "SEND SOS ALERT",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// CANCEL BUTTON
              OutlinedButton(

                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text("Cancel"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}