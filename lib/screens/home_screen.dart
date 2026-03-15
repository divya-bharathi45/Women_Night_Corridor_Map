import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'manage_contacts_screen.dart';
import 'search_history_screen.dart';
import 'sos_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2246),

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// LOCATION ICON
                const Icon(
                  Icons.location_on,
                  size: 90,
                  color: Colors.pinkAccent,
                ),

                const SizedBox(height: 20),

                /// TITLE
                const Text(
                  "Women Night Corridor Map",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                /// SUBTITLE
                const Text(
                  "Find the safest route at night\nwith confidence",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 40),

                /// FIND SAFE ROUTE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SearchScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      "Find Safe Route",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// SOS BUTTON (NOW OPENS SOS SCREEN)
                OutlinedButton.icon(

                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SOSScreen(),
                      ),
                    );

                  },

                  icon: const Icon(Icons.warning),

                  label: const Text("SOS"),
                ),

                const SizedBox(height: 20),

                /// MANAGE EMERGENCY CONTACTS
                OutlinedButton.icon(

                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ManageContactsScreen(),
                      ),
                    );

                  },

                  icon: const Icon(Icons.contacts),

                  label: const Text(
                    "Manage Emergency Contacts",
                  ),
                ),

                const SizedBox(height: 15),

                /// SEARCH HISTORY
                OutlinedButton.icon(

                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SearchHistoryScreen(),
                      ),
                    );

                  },

                  icon: const Icon(Icons.history),

                  label: const Text("Search History"),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}