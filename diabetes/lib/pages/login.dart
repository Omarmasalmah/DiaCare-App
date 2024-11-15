import 'package:diabetes/components/my_button.dart';
import 'package:diabetes/components/my_textfield.dart';
import 'package:diabetes/components/square_tile.dart';
import 'package:diabetes/pages/PhoneNumberPage.dart';
import 'package:diabetes/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diabetes/pages/ForgetPassPage.dart';

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

  void signUserIn() async {
    // Clear previous error messages
    setState(() {
      emailError = null;
      passwordError = null;
    });

    // Validate email and password fields
    if (emailController.text.isEmpty) {
      setState(() {
        emailError = 'Email cannot be empty.';
      });
      return; // Exit the function if email is empty
    }
    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = 'Password cannot be empty.';
      });
      return; // Exit the function if password is empty
    }

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
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Close loading indicator
      Navigator.pop(context);

      if (credential.user?.emailVerified ?? false) {
        // Email is verified, navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
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
        setState(() {
          emailError = 'No user found for that email.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          passwordError = 'Incorrect password.';
        });
      } else {
        setState(() {
          emailError = 'An error occurred. Please try again.';
        });
      }
    }
  }

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
                        TextButton(
                          onPressed: () {
                            // Add your action here
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage()),
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 18.0),
                  const SizedBox(height: 18.0),

                  // Sign in button
                  MyButton(
                    onTap: signUserIn,
                  ),

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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(imagePath: 'images/Google.png'),
                      SizedBox(width: 10.0),
                      SquareTile(imagePath: 'images/facebook.png')
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
