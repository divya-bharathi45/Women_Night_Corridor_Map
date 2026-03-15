import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import '../services/database_service.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  List<ContactModel> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    final data = await DatabaseService.getContacts();
    setState(() {
      contacts = data;
    });
  }

  Future<void> addContact() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty) return;

    ContactModel contact = ContactModel(
      name: nameController.text,
      phone: phoneController.text,
    );

    await DatabaseService.addContact(contact);

    nameController.clear();
    phoneController.clear();

    loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Contacts"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: addContact,
              child: const Text("Add Contact"),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(contacts[index].name),
                    subtitle: Text(contacts[index].phone),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await DatabaseService.deleteContact(
                            contacts[index].id!);
                        loadContacts();
                      },
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
