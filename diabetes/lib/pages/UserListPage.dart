import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatPage.dart'; // Import the ChatPage

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  String? currentUserRole; // Store the current user's role

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserRole();
  }

  Future<void> _fetchCurrentUserRole() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          currentUserRole = userDoc['role']; // Assuming 'role' field exists
        });
      }
    } catch (e) {
      debugPrint("Error fetching user role: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserRole == null) {
      return const Scaffold(
        body: Center(
            child:
                CircularProgressIndicator()), // Show loading while fetching user role
      );
    }

    // Determine which users to display based on the current user's role
    String targetRole = (currentUserRole == 'patient') ? 'doctor' : 'patient';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Select User',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Color.fromARGB(255, 41, 175, 45)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('role',
                isEqualTo: targetRole) // Fetch only users with opposite role
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 10),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> userList = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              itemCount: userList.length,
              itemBuilder: (context, index) {
                var user = userList[index];
                String userName = user['name'] ?? 'No Name';
                String userEmail = user['email'] ?? 'No Email';
                String? profileImageUrl = user['profileImage'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: Colors.white,
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.teal,
                        backgroundImage: (profileImageUrl != null &&
                                profileImageUrl.isNotEmpty)
                            ? NetworkImage(profileImageUrl)
                            : null,
                        child: (profileImageUrl == null ||
                                profileImageUrl.isEmpty ||
                                profileImageUrl == 'images/NoProfilePic.png')
                            ? Center(
                                child: Text(
                                  _getInitials(userName),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      title: Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        userEmail,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ChatPage.id,
                          arguments: {
                            'email': userEmail,
                            'name': userName,
                            'profileImage': profileImageUrl,
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No users found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
        },
      ),
    );
  }

  // Helper method to get initials from a user's name
  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return '?'; // Fallback for empty names
  }
}
