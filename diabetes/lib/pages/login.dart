import 'package:diabetes/components/my_button.dart';
import 'package:diabetes/components/my_textfield.dart';
import 'package:diabetes/components/square_tile.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  LogIn({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {}

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
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
                const SizedBox(
                  height: 40.0,
                ),
                // logo
                const Icon(
                  Icons.lock,
                  size: 150,
                ),
                const SizedBox(height: 5),

                // Welcome
                const Text(
                  'Welcome\n',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 1.0,
                ),
                
                // Username
                MyTextField(
                  controller: widget.usernameController,
                  hint: 'Username',
                  obscure: false,
                  prefixIcon: const Icon(Icons.mail),
                ),

                const SizedBox(
                  height: 10.0,
                ),

                // Password
                MyTextField(
                  controller: widget.passwordController,
                  hint: 'Password',
                  obscure: true,
                  prefixIcon: const Icon(Icons.lock),
                ),

                const SizedBox(
                  height: 10.0,
                ),

                // Forget password?
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forget password?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 8, 5, 5),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25.0),

                // Sign in button
                MyButton(
                  onTap: widget.signUserIn,
                ),

                const SizedBox(height: 25),

                // Or continue with
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 45, 42, 42),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Color.fromARGB(255, 45, 42, 42),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 45, 42, 42),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // google + facebook
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(imagePath: 'images/Google.png'),
                    SizedBox(
                      width: 10.0,
                    ),
                    SquareTile(imagePath: 'images/facebook.png')
                  ],
                ),

                const SizedBox(height: 20),

                // Sign up
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 1, 1, 1),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Register now",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 14, 1, 187),
                        fontSize: 17,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ),
    );

  }
}
