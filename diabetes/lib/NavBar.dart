import 'package:diabetes/generated/l10n.dart';
import 'package:diabetes/pages/DiabetesYogaListPage.dart';
import 'package:diabetes/pages/DoctorHomePage.dart';
import 'package:diabetes/pages/LocaleProvider.dart';
import 'package:diabetes/pages/UserListPage.dart';
import 'package:diabetes/pages/chatPage.dart';
import 'package:diabetes/pages/custom_chart_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/pages/FAQpage.dart';
import 'package:diabetes/pages/home_screen.dart';
import 'package:diabetes/pages/login.dart';
import 'package:diabetes/pages/AccountSettings.dart';
import 'package:diabetes/pages/MainCalc.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  Map<String, dynamic>? _userProfile;

  Future<Map<String, dynamic>?> getUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userProfile = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      var data = userProfile.data() as Map<String, dynamic>?;
      if (data != null) {
        data['email'] = user.email; // Add email to the profile data
      }
      return data;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getUserProfile().then((profile) {
      setState(() {
        _userProfile = profile;
      });
    });
  }

  void _signOut(BuildContext context) async {
    final localeProvider =
        Provider.of<LocalizationService>(context, listen: false);
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LogIn()),
      (Route<dynamic> route) => false,
    );
    localeProvider.setLocale(Locale('en', 'US'));
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).translate('logout')),
          content: Text(S.of(context).translate('sureToLogout')),
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
          UserAccountsDrawerHeader(
            accountName: Text(_userProfile?['name'] ?? 'Loading...'),
            accountEmail: Text(_userProfile?['email'] ?? 'Loading...'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: _userProfile?['profileImage'] != null &&
                        _userProfile!['profileImage'].isNotEmpty &&
                        Uri.tryParse(_userProfile!['profileImage'])
                                ?.hasAbsolutePath ==
                            true
                    ? Image.network(
                        _userProfile!['profileImage'],
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'images/NoProfilePic.png', // Fallback asset image
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
          ),
          ListTile(
            title: Text(S.of(context).translate('home')),
            leading: const Icon(Icons.home),
            onTap: () async {
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                DocumentSnapshot userDoc = await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(user.uid)
                    .get();

                if (userDoc.exists) {
                  final data = userDoc.data() as Map<String, dynamic>;
                  final role = data['role'];

                  if (role == 'patient') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else if (role == 'doctor') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DoctorHomePage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Unknown role: $role')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User document does not exist')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No user is currently signed in')),
                );
              }
            },
          ),
          ListTile(
            title: Text(S.of(context).translate('faq')),
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
            title: Text(S.of(context).translate('insulinCalc')),
            leading: const Icon(Icons.calculate),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MainCalc()), // Navigate to UserListPage
              );
            },
          ),
          ListTile(
            title: Text(S.of(context).translate('chat')),
            leading: const Icon(Icons.chat),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        UserListPage()), // Navigate to UserListPage
              );
            },
            // onTap: () {
            //   if (_userProfile != null && _userProfile!['email'] != null) {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ChatPage(),
            //         settings: RouteSettings(
            //           arguments: _userProfile![
            //               'email'], // Pass the email as an argument
            //         ),
            //       ),
            //     );
            //   } else {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text('User profile not loaded yet')),
            //     );
            //   }
            // },
          ),
          ListTile(
            title: Text(S.of(context).translate('exercises')),
            leading: const Icon(Icons.fitness_center),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DiabetesYogaListPage()), // Navigate to UserListPage
              );
            },
          ),
          ListTile(
            title: Text(S.of(context).translate('accountSettings')),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AccountSettingsPage()), // Navigate to UserListPage
              );
            },
          ),
          ListTile(
            title: Text(S.of(context).translate('logout')),
            leading: const Icon(Icons.logout),
            onTap: () => _showSignOutDialog(context),
          ),
          // Add more ListTiles for other navigation items here
        ],
      ),
    );
  }
}
