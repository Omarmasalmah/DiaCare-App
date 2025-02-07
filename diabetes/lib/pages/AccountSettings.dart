import 'dart:convert';
import 'dart:io';
import 'package:diabetes/constants.dart';
import 'package:diabetes/pages/EmergencyContactsPage.dart';
import 'package:diabetes/pages/LocaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:diabetes/Cloudinary.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

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
        if (!mounted) return; // Check if widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No image selected."),
          ),
        );
        return;
      }

      // Firebase user ID
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        if (!mounted) return; // Check if widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not authenticated.")),
        );
        return;
      }

      // Upload the image to Cloudinary
      final imageBytes = await pickedFile.readAsBytes();
      final imageUrl = await CloudinaryService.uploadBytes(imageBytes, "image");

      if (imageUrl == null) {
        if (!mounted) return; // Check if widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error uploading image to Cloudinary.")),
        );
        return;
      }

      // Update Firestore with the image URL
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'profileImage': imageUrl,
      });

      if (!mounted) return; // Check if widget is still mounted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile picture updated successfully!")),
      );

      //Optionally update state to reflect the new profile image
      setState(() {
        _profileImageUrl = imageUrl;
      });
    } catch (e) {
      if (!mounted) return; // Check if widget is still mounted
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
    bool oldPasswordVisible = false;
    bool newPasswordVisible = false;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dialog dismissal by tapping outside
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Change Password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Enter your old password and new password.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: oldPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        hintText: 'Enter your old password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.teal),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.green),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            oldPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              oldPasswordVisible = !oldPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !oldPasswordVisible,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: newPasswordController,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        hintText: 'Enter your new password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.teal),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.green),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            newPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              newPasswordVisible = !newPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !newPasswordVisible,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    final oldPassword = oldPasswordController.text.trim();
                    final newPassword = newPasswordController.text.trim();
                    if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
                      try {
                        User? user = _auth.currentUser;
                        if (user != null) {
                          // Re-authenticate the user
                          AuthCredential credential =
                              EmailAuthProvider.credential(
                            email: user.email!,
                            password: oldPassword,
                          );
                          await user.reauthenticateWithCredential(credential);

                          // Update the password
                          await user.updatePassword(newPassword);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Password updated successfully.')),
                          );
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to update password.')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Please enter both old and new passwords.')),
                      );
                    }
                  },
                ),
              ],
            );
          },
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
          const SnackBar(
              content: Text(
                  "Biometric authentication is not supported on this device.")),
        );
        return false;
      }

      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      if (!availableBiometrics.contains(BiometricType.fingerprint)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Account Settings",
            style: TextStyle(color: Colors.white, fontSize: 24)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // White back button
          onPressed: () {
            Navigator.of(context).pop(); // Handle back navigation
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileSection(),
              const SizedBox(height: 20),
              _buildHealthPreferencesSection(),
              const SizedBox(height: 20),
              _buildRemindersSection(),
              const SizedBox(height: 20),
              _buildPrivacySection(),
              const SizedBox(height: 20),
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
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading profile data"));
        }
        // if (!snapshot.hasData || !snapshot.data!.exists) {
        //   return Center(child: Text("Profile data not found"));
        // }

        final doc = snapshot.data!;
        _profileImageUrl = _userProfile?['profileImage'];
        return Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: _profileImageUrl != null &&
                          _profileImageUrl!.startsWith('http')
                      ? NetworkImage(_profileImageUrl!)
                      : const AssetImage('images/NoProfilePic.png')
                          as ImageProvider,
                ),
                title: const Text("Profile Picture",
                    style: TextStyle(fontSize: 18)),
                trailing: const Icon(Icons.edit, color: Colors.teal),
                onTap: _updateProfileImage,
              ),
              ListTile(
                  leading: Icon(Icons.person, color: Colors.teal),
                  title: const Text("Name"),
                  subtitle: Text(_userProfile?['name'] ?? 'Loading...'),
                  //   trailing: const Icon(Icons.edit),
                  onTap: () => _showUpdateFieldDialog(
                      "name", _userProfile?['name'] ?? '')),
              ListTile(
                leading: Icon(Icons.email, color: Colors.teal),
                title: const Text("Email"),
                subtitle: Text(_userProfile?['email'] ?? 'Loading...'),
                // trailing: Icon(Icons.edit),
                onTap: () {
                  //        _showUpdateFieldDialog('email', _userProfile?['email'] ?? '');
                },
              ),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.teal),
                title: const Text("Phone Number"),
                subtitle: Text(_userProfile?['phoneNumber'] ?? 'Loading...'),
                //   trailing: const Icon(Icons.edit),
                onTap: () => _showNumberInputDialog(
                    "phoneNumber", _userProfile?['phoneNumber'] ?? ''),
              ),
              ListTile(
                leading: Icon(Icons.calendar_month, color: Colors.teal),
                title: const Text("Date of Birth"),
                subtitle: Text(_userProfile?['birthdate'] ?? 'Loading...'),
                //  trailing: const Icon(Icons.edit),
                onTap: () => _showUpdateFieldDialog(
                    "birthdate", _userProfile?['birthdate'] ?? ''),
              ),
              ListTile(
                leading: Icon(Icons.language, color: Colors.teal),
                title: const Text("Language Preferences"),
                subtitle: Text(_userProfile?['prefLanguage'] ?? 'Loading...'),
                //   trailing: const Icon(Icons.edit),
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
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.water_drop, color: Colors.teal),
            title: const Text("Target Glucose Range",
                style: TextStyle(color: Colors.black)),
            subtitle: Text(
                "Fasting: $fastingTarget mg/dL\nPost-Meal: $postMealTarget mg/dL"),
            //   trailing: const Icon(Icons.edit),
            onTap: () {
              // Handle glucose range update
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services, color: Colors.teal),
            title: const Text("Daily Insulin Requirements"),
            subtitle: Text("$dailyInsulin units"),
            //   trailing: const Icon(Icons.edit),
            onTap: () {
              // Handle insulin requirements update
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate, color: Colors.teal),
            title: const Text("Carbohydrate-to-Insulin Ratio"),
            subtitle: const Text("1:15"),
            //   trailing: const Icon(Icons.edit),
            onTap: () {
              // Handle ratio update
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center, color: Colors.teal),
            title: const Text("Weight & Height"),
            subtitle: Text("$weight kg, $height cm"),
            //    trailing: const Icon(Icons.edit),
            onTap: () {
              // Handle weight and height update
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services, color: Colors.teal),
            title: const Text("Diabetes Type"),
            subtitle: Text(diabetesType),
            //    trailing: const Icon(Icons.edit),
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
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text("Medication Reminders"),
            value: medicationReminders,
            onChanged: (value) {
              setState(() {
                medicationReminders = value;
              });
            },
            activeColor: const Color.fromARGB(
                255, 2, 150, 0), // Thumb color when the switch is ON
            activeTrackColor: const Color.fromARGB(255, 45, 221, 0)
                .withOpacity(0.5), // Track color when the switch is ON
            inactiveThumbColor:
                Colors.grey, // Thumb color when the switch is OFF
            inactiveTrackColor: Colors.grey
                .withOpacity(0.5), // Track color when the switch is OFF
          ),
          SwitchListTile(
            title: const Text("Blood Glucose Check Reminders"),
            value: glucoseReminders,
            onChanged: (value) {
              setState(() {
                glucoseReminders = value;
              });
            },
            activeColor: const Color.fromARGB(
                255, 2, 150, 0), // Thumb color when the switch is ON
            activeTrackColor: const Color.fromARGB(255, 45, 221, 0)
                .withOpacity(0.5), // Track color when the switch is ON
            inactiveThumbColor:
                Colors.grey, // Thumb color when the switch is OFF
            inactiveTrackColor: Colors.grey
                .withOpacity(0.5), // Track color when the switch is OFF
          ),
          SwitchListTile(
            title: const Text("Appointment Reminders"),
            value: appointmentReminders,
            onChanged: (value) {
              setState(() {
                appointmentReminders = value;
              });
            },
            activeColor: const Color.fromARGB(
                255, 2, 150, 0), // Thumb color when the switch is ON
            activeTrackColor: const Color.fromARGB(255, 45, 221, 0)
                .withOpacity(0.5), // Track color when the switch is ON
            inactiveThumbColor:
                Colors.grey, // Thumb color when the switch is OFF
            inactiveTrackColor: Colors.grey
                .withOpacity(0.5), // Track color when the switch is OFF
          ),
          SwitchListTile(
            title: const Text("Physical Activity Reminders"),
            value: physicalActivityReminders,
            onChanged: (value) {
              setState(() {
                physicalActivityReminders = value;
              });
            },
            activeColor: const Color.fromARGB(
                255, 2, 150, 0), // Thumb color when the switch is ON
            activeTrackColor: const Color.fromARGB(255, 45, 221, 0)
                .withOpacity(0.5), // Track color when the switch is ON
            inactiveThumbColor:
                Colors.grey, // Thumb color when the switch is OFF
            inactiveTrackColor: Colors.grey
                .withOpacity(0.5), // Track color when the switch is OFF
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text("Enable Fingerprint Authentication"),
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
                  const SnackBar(content: Text("Authentication failed.")),
                );
              }
            },
            activeColor: const Color.fromARGB(
                255, 2, 150, 0), // Thumb color when the switch is ON
            activeTrackColor: const Color.fromARGB(255, 45, 221, 0)
                .withOpacity(0.5), // Track color when the switch is ON
            inactiveThumbColor:
                Colors.grey, // Thumb color when the switch is OFF
            inactiveTrackColor: Colors.grey
                .withOpacity(0.5), // Track color when the switch is OFF
          ),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.teal),
            title: const Text("Change Password"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showChangePasswordDialog();
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.teal),
            title: const Text("Privacy Policy"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Privacy Policy'),
                    content: const SingleChildScrollView(
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
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.teal),
            title: const Text("Terms and Conditions"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Terms and Conditions'),
                    content: const SingleChildScrollView(
                      child: Text(
                        termsAndConditions,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
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
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.contacts, color: Colors.teal),
            title: const Text("Emergency Contacts"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EmergencyContactsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.warning, color: Colors.teal),
            title: const Text("SOS Button Settings"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle SOS button settings
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
              decoration: InputDecoration(
                hintText: "Enter new $fieldName",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.teal.withOpacity(0.1), // Background color
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  final newValue = fieldController.text.trim();
                  if (newValue.isNotEmpty) {
                    await _updateField(fieldName, newValue);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Update"),
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

  void _showNumberInputDialog(String fieldName, String currentValue) {
    final TextEditingController fieldController =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update $fieldName"),
          content: TextField(
            controller: fieldController,
            decoration: InputDecoration(
              hintText: "Enter new phone number",
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.teal.withOpacity(0.1), // Background color
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.teal), // Border color when enabled
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.green), // Border color when focused
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.red), // Border color for errors
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.redAccent), // Focused error border
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.phone, // Ensures only numbers are input
            inputFormatters: [
              FilteringTextInputFormatter
                  .digitsOnly, // Restricts input to digits
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final newValue = fieldController.text.trim();
                if (newValue.isNotEmpty) {
                  await _updateField(fieldName, newValue); // Update the field
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Phone number cannot be empty.")),
                  );
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateLanguageDialog() {
    String selectedLanguage = _userProfile?['prefLanguage'] ?? 'English';
    final localeProvider =
        Provider.of<LocalizationService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Update Language Preferences",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Choose your preferred language from the dropdown below.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedLanguage,
                items: <String>['English', 'Arabic'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLanguage = newValue!;
                  });
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
                dropdownColor: Colors.teal[50],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (selectedLanguage.isNotEmpty) {
                  await _updateField('prefLanguage', selectedLanguage);
                  if (selectedLanguage == 'English') {
                    localeProvider.setLocale(const Locale('en', 'US'));
                  } else if (selectedLanguage == 'Arabic') {
                    localeProvider.setLocale(const Locale('ar', 'AE'));
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
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
