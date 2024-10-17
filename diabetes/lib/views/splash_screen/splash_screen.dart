import 'package:flutter/material.dart';
import 'package:diabetes/consts/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: green,
      body: Center(
        child: Column(
          children: [
            Container(),
          ],
        ),
      ),
    );
  }
}