import 'package:diabetes/pages/MainInfoPage.dart';
import 'package:flutter/material.dart';

class RoleSelectionPage extends StatefulWidget {
  final String phoneNumber;
  const RoleSelectionPage({super.key, required this.phoneNumber});
  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? selectedRole; // Track selected role (doctor or patient)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Select Your Role",
          style: TextStyle(fontSize: 24, color: Colors.white),
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.teal,
                ),
                const SizedBox(height: 20),
                Text(
                  "Please select your role in the application:",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        RadioListTile(
                          title: Row(
                            children: const [
                              Icon(Icons.medical_services, color: Colors.teal),
                              SizedBox(width: 8),
                              Text(
                                "Doctor",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          value: "doctor",
                          groupValue: selectedRole,
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value.toString();
                            });
                          },
                          activeColor: Colors.teal,
                        ),
                        const Divider(thickness: 1, color: Colors.grey),
                        RadioListTile(
                          title: Row(
                            children: const [
                              Icon(Icons.person, color: Colors.teal),
                              SizedBox(width: 8),
                              Text(
                                "Patient",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          value: "patient",
                          groupValue: selectedRole,
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value.toString();
                            });
                          },
                          activeColor: Colors.teal,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    elevation: 5,
                  ),
                  onPressed: selectedRole != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainInfoPage(
                                phoneNumber: widget.phoneNumber,
                                selectedRole: selectedRole!,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
