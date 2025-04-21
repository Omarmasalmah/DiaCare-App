import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyContactsPage extends StatefulWidget {
  EmergencyContactsPage();

  @override
  _EmergencyContactsPageState createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  List<Map<String, dynamic>> contacts = [];
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    final retrievedContacts = await getContactsForUser(userId!);
    setState(() {
      contacts = retrievedContacts;
    });
  }

  void _addContactDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Phone or Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    contactController.text.isNotEmpty) {
                  await addContactToUser(
                      userId!, nameController.text, contactController.text);
                  Navigator.pop(context);
                  _fetchContacts(); // Refresh contacts
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Emergency Contacts'),
      ),
      body: contacts.isEmpty
          ? Center(child: Text('There Are No Contacts in Your List'))
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  title: Text(contact['name'] ?? 'No Name'),
                  subtitle: Text(contact['contact'] ?? 'No Contact Info'),
                  trailing: Icon(Icons.phone),
                  onTap: () {
                    // Handle contact action
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContactDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getContactsForUser(String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Reference to the user's document
      final userDocRef = firestore.collection('Users').doc(userId);

      // Fetch the document snapshot
      final docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        // Retrieve the contacts field (if it exists)
        List<dynamic>? contacts = docSnapshot.data()?['contacts'];
        return contacts?.cast<Map<String, dynamic>>() ?? [];
      } else {
        print('User document does not exist.');
        return [];
      }
    } catch (e) {
      print('Failed to retrieve contacts: $e');
      return [];
    }
  }

  Future<void> addContactToUser(
      String userId, String contactName, String contactInfo) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Reference to the user's document
      final userDocRef = firestore.collection('Users').doc(userId);

      // Update the 'contacts' field by adding a new contact
      await userDocRef.update({
        'contacts': FieldValue.arrayUnion([
          {'name': contactName, 'contact': contactInfo}
        ])
      });

      print('Contact added to user successfully!');
    } catch (e) {
      print('Failed to add contact: $e');
    }
  }
}
