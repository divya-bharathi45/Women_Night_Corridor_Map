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

  void loadHistory() async {

    history = await DatabaseService.getHistory();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Search History"),
        backgroundColor: Colors.blueAccent,
      ),

      body: ListView.builder(

        itemCount: history.length,

        itemBuilder: (context, index) {

          final item = history[index];

          return ListTile(

            leading: const Icon(Icons.history),

            title: Text(item['startPlace']),

            subtitle: Text("To ${item['destinationPlace']}"),

          );
        },
      ),
    );
  }
}