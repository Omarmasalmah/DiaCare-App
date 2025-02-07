import 'dart:io';

import 'package:diabetes/pages/ToastMsg.dart';
import 'package:diabetes/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:diabetes/constants.dart';

class MainInfoPage extends StatefulWidget {
  final String phoneNumber; // Receive phone number as a parameter
  final String selectedRole; // Receive selected role as a parameter

  const MainInfoPage(
      {super.key, required this.phoneNumber, required this.selectedRole});

  @override
  _MainInfoPageState createState() => _MainInfoPageState();
}

class _MainInfoPageState extends State<MainInfoPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isChecked = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String selectedDiabetesType = "Pre";
  String selectedGender = "Male";
  int selectedWeight = 70;

  // Future<void> signUp(BuildContext context) async {
  //   if (!_isChecked) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Please accept the terms and conditions.")),
  //     );
  //     return;
  //   }

  //   if (passwordController.text != confirmPasswordController.text) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Passwords do not match.")),
  //     );
  //     return;
  //   }

  //   try {
  //     // Create user with email and password in Firebase Authentication
  //     final credential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );

  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       print("User is authenticated: ${user.email}");
  //     } else {
  //       print("User is not authenticated");
  //       return;
  //     }

  //     // Save additional user data in Firestore
  //     await FirebaseFirestore.instance
  //         .collection('Users') // The collection name (e.g., "users")
  //         .doc(credential.user?.uid) // Use the user's UID as the document ID
  //         .set({
  //       'name': nameController.text.trim(),
  //       'birthdate': birthdateController.text.trim(),
  //       'phoneNumber': widget.phoneNumber,
  //       'email': emailController.text.trim(),
  //       'createdAt':
  //           Timestamp.now(), // Optional: track when the user was created
  //       'role': widget.selectedRole,
  //     }).whenComplete(() {
  //       print("User data added to Firestore");
  //     }).catchError((error, statckTrace) {
  //       print("Failed to add user data: $error");
  //     });

  //     // Send email verification
  //     await credential.user?.sendEmailVerification();

  //     Toastmsg().showToast(
  //       "User signed up successfully! A verification email has been sent to ${credential.user?.email}",
  //     );

  //     // Navigate to the login page
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => LogIn()),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to sign up: $e")),
  //     );
  //   }
  // }

  Future<void> signUp(BuildContext context) async {
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please accept the terms and conditions.")),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String imageUrl = 'images/NoProfilePic.png'; // Default image URL

      // if (_image != null) {
      //   final storageRef = FirebaseStorage.instance
      //       .ref()
      //       .child('profile_images')
      //       .child(credential.user!.uid);
      //   await storageRef.putFile(_image!);
      //   imageUrl = await storageRef.getDownloadURL();
      // }

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(credential.user!.uid)
          .set({
        'name': nameController.text.trim(),
        'birthdate': birthdateController.text.trim(),
        'phoneNumber': widget.phoneNumber,
        'email': emailController.text.trim(),
        'createdAt': Timestamp.now(),
        'role': widget.selectedRole,
        'profileImage': imageUrl,
        'diabetesType': selectedDiabetesType,
        'gender': selectedGender,
        'weight': selectedWeight,
      });

      await credential.user!.sendEmailVerification();

      Toastmsg().showToast(
        "User signed up successfully! A verification email has been sent to ${credential.user?.email}",
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogIn()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sign up: $e")),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      obscureText: label == 'Password' || label == 'Confirm Password',
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.teal, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
          dropdownColor: Colors.white,
        ),
      ],
    );
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms and Conditions'),
          content: const SingleChildScrollView(
            child: Text(
              termsAndConditions,
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
  }

  Widget _buildWeightPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Weight (kg)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: NumberPicker(
            value: selectedWeight,
            minValue: 30,
            maxValue: 200,
            onChanged: (int value) {
              setState(() {
                selectedWeight = value;
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var phoneNumber = widget.phoneNumber;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Personal Information",
            style: TextStyle(fontSize: 20, color: Colors.white)),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // GestureDetector(
            //   onTap: _pickImage,
            //   child: CircleAvatar(
            //     radius: 50,
            //     backgroundImage: _image != null
            //         ? FileImage(_image!)
            //         : AssetImage('images/NoProfilePic.png') as ImageProvider,
            //     child: _image == null
            //         ? const Icon(
            //             Icons.camera_alt,
            //             size: 30,
            //             color: Colors.grey,
            //           )
            //         : null,
            //   ),
            // ),
            const SizedBox(height: 16),
            _buildTextField(nameController, 'Name', Icons.person),
            const SizedBox(height: 16),
            TextField(
              controller: birthdateController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.calendar_today),
                labelText: "Birthdate",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              readOnly: true,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  birthdateController.text =
                      "${selectedDate.toLocal()}".split(' ')[0];
                }
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown('Diabetes Type', selectedDiabetesType,
                ['Pre', 'Type I', 'Type II'], (String? newValue) {
              setState(() {
                selectedDiabetesType = newValue!;
              });
            }),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text('Gender : '),
                  Radio<String>(
                    value: 'Male',
                    groupValue: selectedGender,
                    onChanged: (String? value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
                  const Text('Male'),
                  Radio<String>(
                    value: 'Female',
                    groupValue: selectedGender,
                    onChanged: (String? value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
                  const Text('Female'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildWeightPicker(),
            const SizedBox(height: 16),
            _buildTextField(emailController, 'Email', Icons.email),
            const SizedBox(height: 16),
            _buildTextField(passwordController, 'Password', Icons.password),
            const SizedBox(height: 16),
            _buildTextField(
                confirmPasswordController, 'Confirm Password', Icons.lock),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                  activeColor: Colors.teal,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _showTermsAndConditions,
                    child: const Text(
                      "I accept the terms and conditions",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () {
                signUp(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
