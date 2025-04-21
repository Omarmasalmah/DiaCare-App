// import 'package:diabetes/generated/l10n.dart';
// import 'package:diabetes/pages/DiabetesYogaListPage.dart';
// import 'package:diabetes/pages/DoctorHomePage.dart';
// import 'package:diabetes/pages/LocaleProvider.dart';
// import 'package:diabetes/pages/SugesstedFoods.dart';
// import 'package:diabetes/pages/UserListPage.dart';
// import 'package:diabetes/pages/chatPage.dart';
// import 'package:diabetes/pages/custom_chart_page.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:diabetes/pages/FAQpage.dart';
// import 'package:diabetes/pages/home_screen.dart';
// import 'package:diabetes/pages/login.dart';
// import 'package:diabetes/pages/AccountSettings.dart';
// import 'package:diabetes/pages/MainCalc.dart';
// import 'package:provider/provider.dart';

// class NavBar extends StatefulWidget {
//   const NavBar({super.key});

//   @override
//   _NavBarState createState() => _NavBarState();
// }

// class _NavBarState extends State<NavBar> {
//   Map<String, dynamic>? _userProfile;

//   Future<Map<String, dynamic>?> getUserProfile() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot userProfile = await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(user.uid)
//           .get();
//       var data = userProfile.data() as Map<String, dynamic>?;
//       if (data != null) {
//         data['email'] = user.email; // Add email to the profile data
//       }
//       return data;
//     }
//     return null;
//   }

//   @override
//   void initState() {
//     super.initState();
//     getUserProfile().then((profile) {
//       setState(() {
//         _userProfile = profile;
//       });
//     });
//   }

//   void _signOut(BuildContext context) async {
//     final localeProvider =
//         Provider.of<LocalizationService>(context, listen: false);
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => LogIn()),
//       (Route<dynamic> route) => false,
//     );
//     localeProvider.setLocale(Locale('en', 'US'));
//   }

//   void _showSignOutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(S.of(context).translate('logout')),
//           content: Text(S.of(context).translate('sureToLogout')),
//           actions: <Widget>[
//             TextButton(
//               child: const Text("No"),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Dismiss the dialog
//               },
//             ),
//             TextButton(
//               child: const Text("Yes"),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Dismiss the dialog
//                 _signOut(context); // Sign out the user
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: Text(_userProfile?['name'] ?? 'Loading...'),
//             accountEmail: Text(_userProfile?['email'] ?? 'Loading...'),
//             currentAccountPicture: CircleAvatar(
//               child: ClipOval(
//                 child: _userProfile?['profileImage'] != null &&
//                         _userProfile!['profileImage'].isNotEmpty &&
//                         Uri.tryParse(_userProfile!['profileImage'])
//                                 ?.hasAbsolutePath ==
//                             true
//                     ? Image.network(
//                         _userProfile!['profileImage'],
//                         width: 90,
//                         height: 90,
//                         fit: BoxFit.cover,
//                       )
//                     : Image.asset(
//                         'images/NoProfilePic.png', // Fallback asset image
//                         width: 90,
//                         height: 90,
//                         fit: BoxFit.cover,
//                       ),
//               ),
//             ),
//             decoration: const BoxDecoration(
//               color: Colors.blue,
//               image: DecorationImage(
//                 image: AssetImage('images/backProfile.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           ListTile(
//             title: Text(S.of(context).translate('home')),
//             leading: const Icon(Icons.home),
//             onTap: () async {
//               User? user = FirebaseAuth.instance.currentUser;
//               if (user != null) {
//                 DocumentSnapshot userDoc = await FirebaseFirestore.instance
//                     .collection('Users')
//                     .doc(user.uid)
//                     .get();

//                 if (userDoc.exists) {
//                   final data = userDoc.data() as Map<String, dynamic>;
//                   final role = data['role'];

//                   if (role == 'patient') {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => HomeScreen()),
//                     );
//                   } else if (role == 'doctor') {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => DoctorHomePage()),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Unknown role: $role')),
//                     );
//                   }
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('User document does not exist')),
//                   );
//                 }
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('No user is currently signed in')),
//                 );
//               }
//             },
//           ),
//           ListTile(
//             title: Text(S.of(context).translate('faq')),
//             leading: const Icon(Icons.question_answer),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const DiabetesFAQPage()),
//               );
//             },
//           ),
//           ListTile(
//             title: Text('Suggested Foods'),
//             leading: const Icon(Icons.food_bank),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         HealthyMealsPage()), // Navigate to UserListPage
//               );
//             },
//           ),
//           ListTile(
//             title: Text(S.of(context).translate('insulinCalc')),
//             leading: const Icon(Icons.calculate),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         MainCalc()), // Navigate to UserListPage
//               );
//             },
//           ),
//           ListTile(
//             title: Text(S.of(context).translate('chat')),
//             leading: const Icon(Icons.chat),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         UserListPage()), // Navigate to UserListPage
//               );
//             },
//             // onTap: () {
//             //   if (_userProfile != null && _userProfile!['email'] != null) {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //         builder: (context) => ChatPage(),
//             //         settings: RouteSettings(
//             //           arguments: _userProfile![
//             //               'email'], // Pass the email as an argument
//             //         ),
//             //       ),
//             //     );
//             //   } else {
//             //     ScaffoldMessenger.of(context).showSnackBar(
//             //       const SnackBar(content: Text('User profile not loaded yet')),
//             //     );
//             //   }
//             // },
//           ),
//           ListTile(
//             title: Text(S.of(context).translate('exercises')),
//             leading: const Icon(Icons.fitness_center),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         DiabetesYogaListPage()), // Navigate to UserListPage
//               );
//             },
//           ),
//           ListTile(
//             title: Text(S.of(context).translate('accountSettings')),
//             leading: const Icon(Icons.settings),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         AccountSettingsPage()), // Navigate to UserListPage
//               );
//             },
//           ),
//           ListTile(
//             title: Text(S.of(context).translate('logout')),
//             leading: const Icon(Icons.logout),
//             onTap: () => _showSignOutDialog(context),
//           ),
//           // Add more ListTiles for other navigation items here
//         ],
//       ),
//     );
//   }
// }

import 'package:diabetes/pages/DiabetesYogaListPage.dart';
import 'package:diabetes/pages/DoctorHomePage.dart';
import 'package:diabetes/pages/UserListPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/pages/FAQpage.dart';
import 'package:diabetes/pages/home_screen.dart';
import 'package:diabetes/pages/login.dart';
import 'package:diabetes/pages/AccountSettings.dart';
import 'package:diabetes/pages/MainCalc.dart';

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
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LogIn()),
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
      child: Container(
        color: const Color(0xFFF5F5F5), // Light background color
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                _userProfile?['name'] ?? 'Loading...',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                _userProfile?['email'] ?? 'Loading...',
                style: const TextStyle(fontSize: 14),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
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
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 3, 227, 205),
                    Color.fromARGB(255, 0, 120, 219)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                color: Colors
                    .teal, // Backup color in case the gradient isn't visible
                image: DecorationImage(
                  image: AssetImage('images/backProfile.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.5, // Make the image semi-transparent
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildListTile(
                    context,
                    title: "Home",
                    icon: Icons.home,
                    onTap: () {
                      try {
                        if (_userProfile != null &&
                            _userProfile!.containsKey('role')) {
                          String role = _userProfile!['role'];
                          if (role == 'patient') {
                            _navigateTo(context, const HomeScreen());
                          } else if (role == 'doctor') {
                            _navigateTo(context, const DoctorHomePage());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Unknown role, unable to navigate.')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'User profile not loaded or missing role.')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error determining role: $e')),
                        );
                      }
                    },
                  ),
                  _buildListTile(
                    context,
                    title: "FAQ",
                    icon: Icons.question_answer,
                    onTap: () => _navigateTo(context, const DiabetesFAQPage()),
                  ),

                  _buildListTile(
                    context,
                    title: "Insulin Calculation",
                    icon: Icons.calculate,
                    onTap: () => _navigateTo(context, const MainCalc()),
                  ),

                  _buildListTile(
                    context,
                    title: "Chat",
                    icon: Icons.chat,
                    onTap: () => _navigateTo(context, const UserListPage()),
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

                  _buildListTile(
                    context,
                    title: "Exercises",
                    icon: Icons.fitness_center,
                    onTap: () =>
                        _navigateTo(context, const DiabetesYogaListPage()),
                  ),

                  /*    ListTile(
            title: const Text('Chart'),
            leading: const Icon(Icons.pie_chart),
            onTap: () {
          /*    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const CustomChartPage()), // Navigate to UserListPage
              );*/
            },
          ),*/

                  _buildListTile(
                    context,
                    title: "Account Settings",
                    icon: Icons.settings,
                    onTap: () =>
                        _navigateTo(context, const AccountSettingsPage()),
                  ),
                  _buildListTile(
                    context,
                    title: "Log Out",
                    icon: Icons.logout,
                    onTap: () => _showSignOutDialog(context),
                  ),
                  // Add more ListTiles for other navigation items here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          leading: Icon(icon, color: Colors.teal),
          onTap: onTap,
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
