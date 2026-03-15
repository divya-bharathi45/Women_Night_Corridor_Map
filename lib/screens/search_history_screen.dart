import 'package:flutter/material.dart';
import '../services/database_service.dart';

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

    await DatabaseService.deleteHistory(id);

    loadHistory();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Search History"),
        backgroundColor: Colors.blueAccent,
      ),

      body: history.isEmpty
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

                  /// DELETE BUTTON
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),

                    onPressed: () {
                      deleteHistory(item['id']);
                    },
                  ),
                );
              },
            ),
    );
  }
}