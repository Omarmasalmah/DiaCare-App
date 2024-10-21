import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hint;
  final bool obscure;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.obscure,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 10, 5, 5)),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
            ),
          ),
        );
  }
}