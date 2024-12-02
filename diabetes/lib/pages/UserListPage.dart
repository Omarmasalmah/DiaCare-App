import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatPage.dart'; // Import the ChatPage

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Select User'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> userList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                var user = userList[index];
                String userName = user['name'] ?? 'No Name';
                String userEmail = user['email'] ?? 'No Email';
                return ListTile(
                  title: Text(userName),
                  subtitle: Text(userEmail),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(),
                        settings: RouteSettings(arguments: userEmail),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
