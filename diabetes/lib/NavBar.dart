import 'package:flutter/material.dart';
import 'package:diabetes/pages/FAQpage.dart';
import 'package:diabetes/pages/home_screen.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Mahmoud Hamdan'),
            accountEmail: Text('1201134@student.birzeit.edu'),
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
            onTap: () => null,
          ),
          // Add more ListTiles for other navigation items here
        ],
      ),
    );
  }
}
