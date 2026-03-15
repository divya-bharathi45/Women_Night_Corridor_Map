import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'map_screen.dart';

class SearchHistoryScreen extends StatefulWidget {
  const SearchHistoryScreen({super.key});

  @override
  State<SearchHistoryScreen> createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  /// LOAD HISTORY FROM DATABASE
  Future<void> loadHistory() async {
    history = await DatabaseService.getHistory();

    setState(() {});
  }

  /// DELETE HISTORY ITEM
  Future<void> deleteHistory(int id) async {
    
    print("Deleting ID : $id");

    await DatabaseService.deleteHistory(id);

    await loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search History"),
        backgroundColor: Colors.blueAccent,
      ),

      body:
          history.isEmpty
              ? const Center(
                child: Text(
                  "No Search History",
                  style: TextStyle(fontSize: 16),
                ),
              )
              : ListView.builder(
                itemCount: history.length,

                itemBuilder: (context, index) {
                  final item = history[index];

                  return ListTile(
                    leading: const Icon(Icons.history),

                    title: Text(item['startPlace']),

                    subtitle: Text("To ${item['destinationPlace']}"),

                    /// OPEN ROUTE AGAIN
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => MapScreen(
                                startPlace: item['startPlace'],
                                destinationPlace: item['destinationPlace'],
                                userPosition: null,
                              ),
                        ),
                      );
                    },

                    /// DELETE BUTTON
                    trailing: IconButton(
  icon: const Icon(Icons.delete, color: Colors.red),

  onPressed: () {

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text("Delete History"),

          content: const Text(
            "Are you sure you want to delete this search history?"
          ),

          actions: [

            /// CANCEL BUTTON
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            /// DELETE BUTTON
            TextButton(
              onPressed: () async {

                await deleteHistory(item['id']);

                Navigator.pop(context);

              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),

          ],
        );
      },
    );

  },
),
                  );
                },
              ),
    );
  }
}
