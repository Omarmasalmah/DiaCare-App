import 'dart:io';

import 'package:diabetes/pages/ToastMsg.dart';
import 'package:diabetes/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MainInfoPage extends StatefulWidget {
  final String phoneNumber; // Receive phone number as a parameter
  final String selectedRole; // Receive selected role as a parameter

  const MainInfoPage(
      {Key? key, required this.phoneNumber, required this.selectedRole})
      : super(key: key);

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
        SnackBar(content: Text("Please accept the terms and conditions.")),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match.")),
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

      if (_image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(credential.user!.uid);
        await storageRef.putFile(_image!);
        imageUrl = await storageRef.getDownloadURL();
      }

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
      });

      await credential.user!.sendEmailVerification();

      Toastmsg().showToast(
        "User signed up successfully! A verification email has been sent to ${credential.user?.email}",
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
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

  @override
  Widget build(BuildContext context) {
    var phoneNumber = widget.phoneNumber;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Personal Information"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : AssetImage('images/NoProfilePic.png') as ImageProvider,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: birthdateController,
              decoration: InputDecoration(
                labelText: "Birthdate",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)),
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
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  filled: true,
                  fillColor: Colors.grey[200]),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  filled: true,
                  fillColor: Colors.grey[200]),
              obscureText: true,
            ),
            SizedBox(height: 16),
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
                  child: Text(
                    "I accept the terms and conditions",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
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
                "Sign Up",
                style: TextStyle(fontSize: 16),
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
