import 'package:diabetes/pages/MainInfoPage.dart';
import 'package:flutter/material.dart';

class RoleSelectionPage extends StatefulWidget {
  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? selectedRole; // Track selected role (doctor or patient)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Select Your Role"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please select your role in the application:",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              RadioListTile(
                title: Row(
                  children: [
                    Icon(Icons.medical_services, color: Colors.teal),
                    SizedBox(width: 8),
                    Text("Doctor"),
                  ],
                ),
                value: "doctor",
                groupValue: selectedRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
                activeColor: Colors.teal,
              ),
              RadioListTile(
                title: Row(
                  children: [
                    Icon(Icons.person, color: Colors.teal),
                    SizedBox(width: 8),
                    Text("Patient"),
                  ],
                ),
                value: "patient",
                groupValue: selectedRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
                activeColor: Colors.teal,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: selectedRole != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainInfoPage()),
                        );
                      }
                    : null, // Disable if no role is selected
              ),
            ],
          ),
        ),
      ),
    );
  }
}
