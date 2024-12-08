import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  // Mock data for settings
  String name = "John Doe";
  String email = "johndoe@example.com";
  String phoneNumber = "+1234567890";
  String birthdate = "1990-01-01";
  String language = "English";
  String diabetesType = "Type 1";

  int fastingTarget = 80;
  int postMealTarget = 140;
  int dailyInsulin = 40;
  double weight = 70.0;
  double height = 175.0;

  bool medicationReminders = true;
  bool glucoseReminders = true;
  bool appointmentReminders = false;
  bool physicalActivityReminders = false;

  bool fingerprintEnabled = false; // Add this state variable

  @override
  void initState() {
    super.initState();
    _loadFingerprintPreference(); // Load the initial state from Firebase
  }

  Future<void> _loadFingerprintPreference() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        setState(() {
          fingerprintEnabled = doc['fingerprintEnabled'] ?? false;
        });
      }
    } catch (e) {
      print("Error loading fingerprint preference: $e");
    }
  }

  Future<void> _saveFingerprintPreference(bool enabled) async {
    try {
      final userId =
          FirebaseAuth.instance.currentUser?.uid; // Get the current user ID
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'fingerprintEnabled': enabled});
        print("Fingerprint preference updated.");
      }
    } catch (e) {
      print("Error saving fingerprint preference: $e");
    }
  }

  Future<bool> _authenticateWithFingerprint() async {
    final LocalAuthentication auth = LocalAuthentication();

    try {
      // Check if the device has biometrics and if biometrics are supported
      bool canAuthenticate =
          await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (!canAuthenticate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Biometric authentication is not supported on this device.")),
        );
        return false;
      }

      // Check if fingerprints are enrolled
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      if (!availableBiometrics.contains(BiometricType.fingerprint)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "No fingerprints enrolled. Please set up fingerprints on your device.")),
        );
        return false;
      }

      // Attempt to authenticate
      bool authenticated = await auth.authenticate(
        localizedReason: "Authenticate to enable fingerprint",
        options: const AuthenticationOptions(
          biometricOnly: true, // Only allow biometrics
        ),
      );
      return authenticated;
    } catch (e) {
      print("Authentication error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Biometric authentication error: $e")),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Account Settings"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              _buildProfileSection(),
              SizedBox(height: 20),

              // Health Preferences Section
              _buildHealthPreferencesSection(),
              SizedBox(height: 20),

              // Reminders Section
              _buildRemindersSection(),
              SizedBox(height: 20),

              // Privacy Section with Fingerprint
              _buildPrivacySection(),
              SizedBox(height: 20),

              // Emergency Section
              _buildEmergencySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/default_profile.png'),
            ),
            title: Text("Profile Picture"),
            trailing: Icon(Icons.edit),
            onTap: () {
              // Handle profile picture update
            },
          ),
          ListTile(
            title: Text("Name"),
            subtitle: Text(name),
            trailing: Icon(Icons.edit),
            onTap: () {
              // Handle name update
            },
          ),
          ListTile(
            title: Text("Email"),
            subtitle: Text(email),
            trailing: Icon(Icons.edit),
            onTap: () {
              // Handle email update
            },
          ),
          ListTile(
            title: Text("Phone Number"),
            subtitle: Text(phoneNumber),
            trailing: Icon(Icons.edit),
            onTap: () {
              // Handle phone number update
            },
          ),
          ListTile(
            title: Text("Date of Birth"),
            subtitle: Text(birthdate),
            trailing: Icon(Icons.edit),
            onTap: () {
              // Handle birthdate update
            },
          ),
          ListTile(
            title: Text("Language Preferences"),
            subtitle: Text(language),
            trailing: Icon(Icons.edit),
            onTap: () {
              // Handle language preferences update
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHealthPreferencesSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            title: Text("Target Glucose Range"),
            subtitle: Text(
                "Fasting: $fastingTarget mg/dL\nPost-Meal: $postMealTarget mg/dL"),
            trailing: Icon(Icons.edit),
            onTap: () {
              // Handle glucose range update
            },
          ),
          ListTile(
            title: Text("Daily Insulin Requirements"),
            subtitle: Text("$dailyInsulin units"),
            trailing: Icon(Icons.edit),
            onTap: () {
              // Handle insulin requirements update
            },
          ),
          ListTile(
            title: Text("Carbohydrate-to-Insulin Ratio"),
            subtitle: Text("1:15"),
            trailing: Icon(Icons.edit),
            onTap: () {
              // Handle ratio update
            },
          ),
          ListTile(
            title: Text("Weight & Height"),
            subtitle: Text("$weight kg, $height cm"),
            trailing: Icon(Icons.edit),
            onTap: () {
              // Handle weight and height update
            },
          ),
          ListTile(
            title: Text("Diabetes Type"),
            subtitle: Text(diabetesType),
            trailing: Icon(Icons.edit),
            onTap: () {
              // Handle diabetes type update
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SwitchListTile(
            title: Text("Medication Reminders"),
            value: medicationReminders,
            onChanged: (value) {
              setState(() {
                medicationReminders = value;
              });
            },
          ),
          SwitchListTile(
            title: Text("Blood Glucose Check Reminders"),
            value: glucoseReminders,
            onChanged: (value) {
              setState(() {
                glucoseReminders = value;
              });
            },
          ),
          SwitchListTile(
            title: Text("Appointment Reminders"),
            value: appointmentReminders,
            onChanged: (value) {
              setState(() {
                appointmentReminders = value;
              });
            },
          ),
          SwitchListTile(
            title: Text("Physical Activity Reminders"),
            value: physicalActivityReminders,
            onChanged: (value) {
              setState(() {
                physicalActivityReminders = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SwitchListTile(
            title: Text("Enable Fingerprint Authentication"),
            value: fingerprintEnabled,
            onChanged: (value) async {
              bool authenticated = await _authenticateWithFingerprint();
              if (authenticated) {
                setState(() {
                  fingerprintEnabled = value;
                });
                await _saveFingerprintPreference(value);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Authentication failed.")),
                );
              }
            },
          ),
          ListTile(
            title: Text("Change Password"),
            trailing: Icon(Icons.lock),
            onTap: () {
              // Handle change password
            },
          ),
          ListTile(
            title: Text("Privacy Policy"),
            trailing: Icon(Icons.description),
            onTap: () {
              // Open privacy policy
            },
          ),
          ListTile(
            title: Text("Terms and Conditions"),
            trailing: Icon(Icons.description),
            onTap: () {
              // Open terms and conditions
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencySection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            title: Text("Emergency Contacts"),
            trailing: Icon(Icons.contacts),
            onTap: () {
              // Handle emergency contacts
            },
          ),
          ListTile(
            title: Text("SOS Button Settings"),
            trailing: Icon(Icons.emergency),
            onTap: () {
              // Handle SOS button settings
            },
          ),
          ListTile(
            title: Text("Hypoglycemia Alerts"),
            trailing: Icon(Icons.warning),
            onTap: () {
              // Handle alerts configuration
            },
          ),
        ],
      ),
    );
  }
}
