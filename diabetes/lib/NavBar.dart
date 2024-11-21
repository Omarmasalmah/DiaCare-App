import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/pages/FAQpage.dart';
import 'package:diabetes/pages/home_screen.dart';
import 'package:diabetes/pages/login.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  Future<Map<String, dynamic>?> getUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userProfile = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      return userProfile.data() as Map<String, dynamic>?;
    }
    return null;
  }

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LogIn()),
      (Route<dynamic> route) => false,
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                _signOut(context); // Sign out the user
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: getUserProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const UserAccountsDrawerHeader(
                  accountName: Text('Loading...'),
                  accountEmail: Text('Loading...'),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image(
                        image: AssetImage('images/profile.jpg'),
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      image: AssetImage('images/backProfile.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const UserAccountsDrawerHeader(
                  accountName: Text('Error'),
                  accountEmail: Text('Error'),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image(
                        image: AssetImage('images/profile.jpg'),
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      image: AssetImage('images/backProfile.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                var userProfile = snapshot.data;
                return UserAccountsDrawerHeader(
                  accountName: Text(userProfile?['name'] ?? 'No Name'),
                  accountEmail: Text(userProfile?['email'] ?? 'No Email'),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image(
                        image: AssetImage('images/profile.jpg'),
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      image: AssetImage('images/backProfile.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              } else {
                return const UserAccountsDrawerHeader(
                  accountName: Text('No User'),
                  accountEmail: Text('No User'),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image(
                        image: AssetImage('images/profile.jpg'),
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      image: AssetImage('images/backProfile.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
            },
          ),
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('FAQ'),
            leading: const Icon(Icons.question_answer),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DiabetesFAQPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Calculate Calories'),
            leading: const Icon(Icons.calculate),
            onTap: () => null,
          ),
          ListTile(
            title: const Text('Chat'),
            leading: const Icon(Icons.chat),
            onTap: () => null,
          ),
          ListTile(
            title: const Text('Meal Planning'),
            leading: const Icon(Icons.launch),
            onTap: () => null,
          ),
          ListTile(
            title: const Text('Account Settings'),
            leading: const Icon(Icons.settings),
            onTap: () => null,
          ),
          ListTile(
            title: const Text('Log Out'),
            leading: const Icon(Icons.logout),
            onTap: () => _showSignOutDialog(context),
          ),
          // Add more ListTiles for other navigation items here
        ],
      ),
    );
  }
}
