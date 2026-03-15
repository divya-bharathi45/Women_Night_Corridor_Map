import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/contact_model.dart';

class ManageContactsScreen extends StatefulWidget {
  const ManageContactsScreen({super.key});

  @override
  State<ManageContactsScreen> createState() => _ManageContactsScreenState();
}

class _ManageContactsScreenState extends State<ManageContactsScreen> {

  List<ContactModel> contacts = [];

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  void loadContacts() async {

    contacts = await DatabaseService.getContacts();

    setState(() {});
  }

  void addContact() async {

    if (nameController.text.isEmpty || phoneController.text.isEmpty) return;

    await DatabaseService.addContact(
      ContactModel(
        name: nameController.text,
        phone: phoneController.text,
      ),
    );

    nameController.clear();
    phoneController.clear();

    loadContacts();
  }

  void deleteContact(int id) async {

    await DatabaseService.deleteContact(id);

    loadContacts();
  }

  void showAddDialog() {

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Emergency Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.phone,
            ),

          ],
        ),
        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {
              addContact();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Emergency Contacts"),
        backgroundColor: Colors.redAccent,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(

        itemCount: contacts.length,

        itemBuilder: (context, index) {

          final contact = contacts[index];

          return ListTile(

            leading: const Icon(Icons.person),

            title: Text(contact.name),

            subtitle: Text(contact.phone),

            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                deleteContact(contact.id!);
              },
            ),
          );
        },
      ),
    );
  }
}