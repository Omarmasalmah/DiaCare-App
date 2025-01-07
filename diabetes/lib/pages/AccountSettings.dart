import 'dart:convert';
import 'dart:io';
import 'package:diabetes/constants.dart';
import 'package:diabetes/pages/EmergencyContactsPage.dart';
import 'package:diabetes/pages/LocaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
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

  bool fingerprintEnabled = false;
  File? _profileImage;
  String? _profileImageUrl;

  Map<String, dynamic>? _userProfile;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Uint8List? pickedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData().then((profile) {
      setState(() {
        _userProfile = profile as Map<String, dynamic>?;
      });
    });
  }

  Future<Object?> _loadUserData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .get();

        // setState(() {
        //   name = doc['name'] ?? name;
        //   email = doc['email'] ?? email;
        //   phoneNumber = doc['phoneNumber'] ?? phoneNumber;
        //   birthdate = doc['birthdate'] ?? birthdate;
        //   language = doc['language'] ?? language;
        //   diabetesType = doc['diabetesType'] ?? diabetesType;
        //   _profileImageUrl = doc['profileImage'] ?? 'images/NoProfilePic.png';
        //   fingerprintEnabled = doc['fingerprintEnabled'] ?? false;
        // });
        return doc.data();
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
    return null;
  }

  Future<void> _updateProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No image selected."),
          ),
        );
        return;
      }

      // Firebase Storage Reference with a unique path
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not authenticated.")),
        );
        return;
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child(
              'profile_images') // Firebase will create this folder automatically
          .child(
              '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg'); // Unique filename

      // Upload Image
      final imageBytes = await pickedFile.readAsBytes();
      //await storageRef.putData(imageBytes);
      final base64String = base64Encode(imageBytes);

      // Get the download URL
      //final downloadUrl = await storageRef.getDownloadURL();

      // Update Firestore with the new URL
      // await FirebaseFirestore.instance.collection('users').doc(userId).update({
      //   'profileImage': downloadUrl,
      // });
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'profileImage': base64String,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile picture updated successfully!")),
      );

      // setState(() {
      //   _profileImageUrl = downloadUrl;
      // });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile picture: $e")),
      );
    }
  }

  //   try {
  //     final pickedFile =
  //         await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       setState(() {
  //         _profileImage = File(pickedFile.path);
  //       });

  //       final userId = FirebaseAuth.instance.currentUser?.uid;
  //       if (userId != null) {
  //         final storageRef = FirebaseStorage.instance
  //             .ref()
  //             .child('profile_images')
  //             .child('$userId/${DateTime.now().millisecondsSinceEpoch}');
  //         await storageRef.putFile(_profileImage!);
  //         final downloadUrl = await storageRef.getDownloadURL();

  //         await FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(userId)
  //             .update({'profileImage': downloadUrl});

  //         setState(() {
  //           _profileImageUrl = downloadUrl;
  //         });

  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("Profile picture updated successfully!")),
  //         );
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("No image selected.")),
  //       );
  //     }
  //   } catch (e) {
  //     if (e.toString().contains("object-not-found")) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content:
  //                 Text("Error: File not found. Please upload a valid image.")),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Error updating profile picture: $e")),
  //       );
  //     }
  //   }
  // }

  Future<void> _showChangePasswordDialog() async {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Enter your old password and new password.'),
                TextField(
                  controller: oldPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Old Password',
                    hintText: 'Enter your old password',
                  ),
                  obscureText: true,
                ),
                TextField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    hintText: 'Enter your new password',
                  ),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                final oldPassword = oldPasswordController.text.trim();
                final newPassword = newPasswordController.text.trim();
                if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
                  try {
                    User? user = _auth.currentUser;
                    if (user != null) {
                      // Re-authenticate the user
                      AuthCredential credential = EmailAuthProvider.credential(
                        email: user.email!,
                        password: oldPassword,
                      );
                      await user.reauthenticateWithCredential(credential);

                      // Update the password
                      await user.updatePassword(newPassword);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Password updated successfully.')),
                      );
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update password.')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Please enter both old and new passwords.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _authenticateWithFingerprint() async {
    final LocalAuthentication auth = LocalAuthentication();

    try {
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

      bool authenticated = await auth.authenticate(
        localizedReason: "Authenticate to enable fingerprint",
        options: const AuthenticationOptions(
          biometricOnly: true,
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

  Future<void> _saveFingerprintPreference(bool enabled) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
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
              _buildProfileSection(),
              SizedBox(height: 20),
              _buildHealthPreferencesSection(),
              SizedBox(height: 20),
              _buildRemindersSection(),
              SizedBox(height: 20),
              _buildPrivacySection(),
              SizedBox(height: 20),
              _buildEmergencySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error loading profile data"));
        }
        // if (!snapshot.hasData || !snapshot.data!.exists) {
        //   return Center(child: Text("Profile data not found"));
        // }

        final doc = snapshot.data!;
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: _profileImageUrl != null &&
                          _profileImageUrl!.startsWith('http')
                      ? NetworkImage(_profileImageUrl!)
                      : AssetImage('images/NoProfilePic.png') as ImageProvider,
                ),
                title: Text("Profile Picture"),
                trailing: Icon(Icons.edit),
                onTap: _updateProfileImage,
              ),
              ListTile(
                  title: Text("Name"),
                  subtitle: Text(_userProfile?['name'] ?? 'Loading...'),
                  trailing: Icon(Icons.edit),
                  onTap: () => _showUpdateFieldDialog(
                      "name", _userProfile?['name'] ?? '')),
              ListTile(
                title: Text("Email"),
                subtitle: Text(_userProfile?['email'] ?? 'Loading...'),
                // trailing: Icon(Icons.edit),
                onTap: () {},
              ),
              ListTile(
                title: Text("Phone Number"),
                subtitle: Text(_userProfile?['phoneNumber'] ?? 'Loading...'),
                trailing: Icon(Icons.edit),
                onTap: () => _showUpdateFieldDialog(
                    "phoneNumber", _userProfile?['phoneNumber'] ?? ''),
              ),
              ListTile(
                title: Text("Date of Birth"),
                subtitle: Text(_userProfile?['birthdate'] ?? 'Loading...'),
                trailing: Icon(Icons.edit),
                onTap: () => _showUpdateFieldDialog(
                    "birthdate", _userProfile?['birthdate'] ?? ''),
              ),
              ListTile(
                title: Text("Language Preferences"),
                subtitle: Text(_userProfile?['prefLanguage'] ?? 'Loading...'),
                trailing: Icon(Icons.edit),
                onTap: _showUpdateLanguageDialog,
              ),
            ],
          ),
        );
      },
    );
  }

  // Other sections (_buildHealthPreferencesSection, _buildRemindersSection, etc.) remain unchanged
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
              _showChangePasswordDialog();
            },
          ),
          ListTile(
            title: Text("Privacy Policy"),
            trailing: Icon(Icons.description),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Privacy Policy'),
                    content: SingleChildScrollView(
                      child: Text(
                        privacyPolicy,
                        // Add your terms and conditions text here
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text("Terms and Conditions"),
            trailing: Icon(Icons.description),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Terms and Conditions'),
                    content: SingleChildScrollView(
                      child: Text(
                        termsAndConditions,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EmergencyContactsPage()),
              );
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

  void _showUpdateFieldDialog(String fieldName, String currentValue) {
    if (fieldName == "birthdate") {
      _showDatePickerDialog(fieldName, currentValue);
    } else {
      final TextEditingController fieldController =
          TextEditingController(text: currentValue);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update $fieldName"),
            content: TextField(
              controller: fieldController,
              decoration: InputDecoration(hintText: "Enter new $fieldName"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  final newValue = fieldController.text.trim();
                  if (newValue.isNotEmpty) {
                    await _updateField(fieldName, newValue);
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Update"),
              ),
            ],
          );
        },
      );
    }
  }

  void _showDatePickerDialog(String fieldName, String currentValue) {
    DateTime initialDate = DateTime.now();
    if (currentValue.isNotEmpty) {
      initialDate = DateTime.parse(currentValue);
    }

    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((selectedDate) {
      if (selectedDate != null) {
        final newValue = selectedDate
            .toIso8601String()
            .split('T')[0]; // Format as YYYY-MM-DD
        _updateField(fieldName, newValue);
      }
    });
  }

  void _showUpdateLanguageDialog() {
    String selectedLanguage = _userProfile?['prefLanguage'] ?? 'English';
    final localeProvider =
        Provider.of<LocalizationService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Language Preferences"),
          content: DropdownButton<String>(
            value: selectedLanguage,
            items: <String>['English', 'Arabic'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedLanguage = newValue!;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (selectedLanguage.isNotEmpty) {
                  await _updateField('prefLanguage', selectedLanguage);
                  if (selectedLanguage == 'English') {
                    localeProvider.setLocale(Locale('en', 'US'));
                  } else if (selectedLanguage == 'Arabic') {
                    localeProvider.setLocale(Locale('ar', 'AE'));
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateField(String fieldName, String newValue) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update({
          fieldName: newValue,
        });
        setState(() {
          _userProfile?[fieldName] = newValue;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$fieldName updated successfully!")),
        );
      }
    } catch (e) {
      print('Error updating $fieldName: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating $fieldName: $e")),
      );
    }
  }
}
