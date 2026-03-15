import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/contact_model.dart';

class ManageContactsScreen extends StatefulWidget {
  const ManageContactsScreen({super.key});

  @override
  State<ManageContactsScreen> createState() => _ManageContactsScreenState();
}

class _ManageContactsScreenState extends State<ManageContactsScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  List<ContactModel> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  /// LOAD CONTACTS FROM DATABASE
  Future<void> loadContacts() async {
    contacts = await DatabaseService.getContacts();
    setState(() {});
  }

  /// PHONE VALIDATION
  bool isValidPhone(String phone) {
    final RegExp phoneRegex = RegExp(r'^[0-9]{10,11}$');
    return phoneRegex.hasMatch(phone);
  }

  /// SHOW SNACKBAR
  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  /// ADD CONTACT
  Future<void> addContact() async {

    String name = nameController.text.trim();
    String phone = phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      showSnack("Enter name and phone number");
      return;
    }

    if (!isValidPhone(phone)) {
      showSnack("Enter valid phone number (10–11 digits)");
      return;
    }

    await DatabaseService.addContact(
      ContactModel(name: name, phone: phone),
    );

    nameController.clear();
    phoneController.clear();

    showSnack("Contact added successfully");

    loadContacts();
  }

  /// DELETE CONTACT
  Future<void> deleteContact(int id) async {

    await DatabaseService.deleteContact(id);

    showSnack("Contact deleted");

    loadContacts();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Emergency Contacts"),
        backgroundColor: Colors.pinkAccent,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// NAME FIELD
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Contact Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// PHONE FIELD
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 11,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            /// ADD BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                onPressed: addContact,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),

                child: const Text(
                  "Add Contact",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// CONTACT LIST
            Expanded(
              child: contacts.isEmpty
                  ? const Center(
                      child: Text("No contacts added"),
                    )
                  : ListView.builder(

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
            ),
          ],
        ),
      ),
    );
  }
}