import 'package:flutter/material.dart';
import '../services/sos_service.dart';

class SOSButton extends StatelessWidget {
  const SOSButton({super.key});

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.all(30),
        shape: const CircleBorder(),
      ),

      onPressed: () {
        _showConfirmationDialog(context);
      },

      child: const Text(
        "SOS",
        style: TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {

    showDialog(
      context: context,

      builder: (context) => AlertDialog(
        title: const Text("Emergency Alert"),
        content: const Text("Send SOS alert to emergency contacts?"),

        actions: [

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          TextButton(
            onPressed: () async {

              Navigator.pop(context);

              await SOSService.sendSOSMessage();
              await SOSService.callPolice();

            },
            child: const Text("Confirm"),
          ),

        ],
      ),
    );
  }
}