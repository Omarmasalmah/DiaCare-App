import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Mahmoud Hamdan'),
            accountEmail: Text('1201134@student.birzeit.edu'),
            currentAccountPicture: const CircleAvatar(
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
                image: AssetImage('images/back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () {
              // Handle navigation to home
            },
          ),
          // Add more ListTiles for other navigation items here
        ],
      ),
    );
  }
}
