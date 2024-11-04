import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hint;
  final bool obscure;
  final Icon prefixIcon;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.obscure, 
    required this.prefixIcon,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 5, 1, 1)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 211, 5, 5)),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: hint,
                prefixIcon: prefixIcon,
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 107, 116, 99),
                ),
            ),
          ),
        );
  }
}