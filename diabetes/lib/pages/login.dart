import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/components/my_button.dart';
import 'package:diabetes/components/my_textfield.dart';
import 'package:diabetes/components/square_tile.dart';
import 'package:diabetes/pages/LocaleProvider.dart';
import 'package:diabetes/pages/PhoneNumberPage.dart';
import 'package:diabetes/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:diabetes/pages/ForgetPassPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Error messages
  String? emailError;
  String? passwordError;

  bool rememberMe = false;

  // Last use : 19/12/2024
  // void signUserIn() async {
  //   // Clear previous error messages
  //   setState(() {
  //     emailError = null;
  //     passwordError = null;
  //   });

  //   // Validate email and password fields
  //   if (emailController.text.isEmpty) {
  //     setState(() {
  //       emailError = 'Email cannot be empty.';
  //     });
  //     return; // Exit the function if email is empty
  //   }
  //   if (passwordController.text.isEmpty) {
  //     setState(() {
  //       passwordError = 'Password cannot be empty.';
  //     });
  //     return; // Exit the function if password is empty
  //   }

  //   // Loading indicator
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return const Center(child: CircularProgressIndicator());
  //     },
  //   );

  //   // Sign in user
  //   try {
  //     final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );

  //     // Close loading indicator
  //     Navigator.pop(context);

  //     if (credential.user?.emailVerified ?? false) {
  //       // Email is verified, navigate to the home screen
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomeScreen()),
  //       );
  //     } else {
  //       // Email is not verified, show a message to the user
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content: Text("Please verify your email before signing in.")),
  //       );
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     // Close loading indicator
  //     Navigator.pop(context);

  //     // Handle different error types
  //     if (e.code == 'user-not-found') {
  //       setState(() {
  //         emailError = 'No user found for that email.';
  //       });
  //     } else if (e.code == 'wrong-password') {
  //       setState(() {
  //         passwordError = 'Incorrect password.';
  //       });
  //     } else {
  //       setState(() {
  //         emailError = 'An error occurred. Please try again.';
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    print('Init State Called');
    _checkForStoredCredentials();
  }

  Future<void> _checkForStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('email');
    final storedPassword = prefs.getString('password');
    final storedRememberMe = prefs.getBool('rememberMe') ?? false;

    print('Stored Email: $storedEmail');
    print('Stored Password: $storedPassword');
    print('Stored Remember Me: $storedRememberMe');

    if (storedRememberMe && storedEmail != null && storedPassword != null) {
      emailController.text = storedEmail;
      passwordController.text = storedPassword;
      setState(() {
        rememberMe = storedRememberMe;
      });
      //_signUserIn(storedEmail, storedPassword);
    }
  }

  Future<void> _signUserIn(String email, String password) async {
    // Loading indicator
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Sign in user
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Close loading indicator
      Navigator.pop(context);

      if (credential.user?.emailVerified ?? false) {
        // Store the email and password if remember me is checked
        if (rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('email', email);
          prefs.setString('password', password);
          prefs.setBool('rememberMe', rememberMe);
          print('Credentials stored in SharedPreferences');
        }

        // Email is verified, navigate to the home screen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } else {
        // Email is not verified, show a message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Please verify your email before signing in.")),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Close loading indicator
      Navigator.pop(context);

      // Handle different error types
      if (e.code == 'user-not-found') {
        if (mounted) {
          setState(() {
            emailError = 'No user found for that email.';
          });
        }
      } else if (e.code == 'wrong-password') {
        if (mounted) {
          setState(() {
            passwordError = 'Incorrect password.';
          });
        }
      } else {
        if (mounted) {
          setState(() {
            emailError = 'An error occurred. Please try again.';
          });
        }
      }
    }
  }

  void signUserIn() async {
    // Clear previous error messages
    if (mounted) {
      setState(() {
        emailError = null;
        passwordError = null;
      });
    }

    // Validate email and password fields
    if (emailController.text.isEmpty) {
      if (mounted) {
        setState(() {
          emailError = 'Email cannot be empty.';
        });
      }
      return; // Exit the function if email is empty
    }
    if (passwordController.text.isEmpty) {
      if (mounted) {
        setState(() {
          passwordError = 'Password cannot be empty.';
        });
      }
      return; // Exit the function if password is empty
    }

    // Call _signUserIn with the entered email and password
    _signUserIn(emailController.text, passwordController.text);

    final localeProvider =
        Provider.of<LocalizationService>(context, listen: false);

    try {
      // Get the current user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        print("No user is currently logged in.");
        return;
      }

      // Access the Firestore document for the user
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users') // Adjust the collection name if necessary
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        print("User document does not exist.");
        return;
      }

      // Retrieve the 'prefLanguage' field
      String? prefLanguage = userDoc.get('prefLanguage');

      if (prefLanguage == null) {
        print("Preferred language is not set.");
      } else if (prefLanguage == 'Arabic') {
        localeProvider.setLocale(const Locale('ar'));
        //print("User's preferred language is Arabic.");
      } else if (prefLanguage == 'English') {
        localeProvider.setLocale(const Locale('en'));
        //print("User's preferred language is English.");
      } else {
        print("User's preferred language is $prefLanguage.");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  // Future<void> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) {
  //       return; // The user canceled the sign-in
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomeScreen()),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to sign in with Google: $e")),
  //     );
  //   }
  // }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Obtain the Google Sign-In authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a credential using the Google Auth details
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        // Check if the user already exists in Firestore
        final userDoc =
            FirebaseFirestore.instance.collection('Users').doc(user.uid);

        final userSnapshot = await userDoc.get();

        if (!userSnapshot.exists) {
          // If the user does not exist, add them to Firestore
          await userDoc.set({
            'name': user.displayName ?? 'No Name', // Name from Google Account
            'email': user.email ?? '', // Email from Google Account
            'phoneNumber': user.phoneNumber ??
                '', // Phone number from Google Account, if available
            'profileImage':
                'images/NoProfilePic.png', // Profile image from Google Account
            'createdAt': Timestamp.now(),
            'role': 'Google User', // Customize the role if needed
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signed in as ${user.displayName}")),
        );

        // Navigate to the Home Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed: $e")),
      );
    }
  }

  // Future<void> signInWithFacebook() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     if (result.status == LoginStatus.success) {
  //       final AuthCredential credential =
  //           FacebookAuthProvider.credential(result.accessToken!.token);
  //       await FirebaseAuth.instance.signInWithCredential(credential);
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomeScreen()),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content:
  //                 Text("Failed to sign in with Facebook: ${result.message}")),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to sign in with Facebook: $e")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(205, 164, 207, 167),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/login_background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40.0),
                  Image.asset('images/mobile-phone.png',
                      height: 150, width: 150),
                  const SizedBox(height: 5),
                  const Text(
                    ' Welcome to',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 40,
                        fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    'DiaCare App ',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 45,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 1.0),
                  const SizedBox(height: 1.0),

                  // Email
                  MyTextField(
                    controller: emailController,
                    hint: 'Email',
                    obscure: false,
                    prefixIcon: const Icon(Icons.mail),
                  ),
                  if (emailError != null) ...[
                    Text(
                      emailError!,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14), // Increased font size
                    ),
                    const SizedBox(height: 10),
                  ],

                  const SizedBox(height: 10.0),

                  // Password
                  MyTextField(
                    controller: passwordController,
                    hint: 'Password',
                    obscure: true,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  if (passwordError != null) ...[
                    Text(
                      passwordError!,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14), // Increased font size
                    ),
                    const SizedBox(height: 10),
                  ],

                  const SizedBox(height: 10.0),

                  // Forget password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Add your action here
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()),
                                );
                              },
                              child: const Text(
                                "Forget password?",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 86, 83, 83),
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberMe = value ?? false;
                                    });
                                  },
                                ),
                                Text('Remember Me'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  MyButton(
                    onTap: signUserIn,
                  ),

                  const SizedBox(height: 18.0),
                  const SizedBox(height: 18.0),

                  // Sign in button

                  const SizedBox(height: 20),
                  const SizedBox(height: 20),

                  // Or continue with
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              Divider(color: Color.fromARGB(255, 45, 42, 42)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                                color: Color.fromARGB(255, 45, 42, 42),
                                fontSize: 15),
                          ),
                        ),
                        Expanded(
                          child:
                              Divider(color: Color.fromARGB(255, 45, 42, 42)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Google + Facebook
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => signInWithGoogle(context),
                        // onTap: () async {
                        //   final UserCredential? userCredential =
                        //       await signInWithGoogle();
                        //   if (userCredential != null) {
                        //     Navigator.pushReplacement(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => HomeScreen()),
                        //     );
                        //   }
                        // },
                        child: SquareTile(imagePath: 'images/Google.png'),
                      ),
                      SizedBox(width: 10.0),
                      // GestureDetector(
                      //   //onTap: signInWithFacebook,
                      //   child: SquareTile(imagePath: 'images/facebook.png'),
                      // ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Not a member?",
                        style: TextStyle(
                            color: Color.fromARGB(255, 1, 1, 1), fontSize: 17),
                      ),
                      const SizedBox(width: 6),
                      TextButton(
                        onPressed: () {
                          // Add your action here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneNumberPage()),
                          );
                        },
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                            color: Color.fromARGB(255, 14, 1, 187),
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
