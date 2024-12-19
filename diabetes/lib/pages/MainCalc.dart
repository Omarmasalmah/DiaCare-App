import 'package:flutter/material.dart';
import 'dosage_instructions.dart'; // Import the Dosage Instructions page
import 'calc.dart';

class MainCalc extends StatelessWidget {
  const MainCalc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back.jpg'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Main Title
                const Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Text(
                    'Insulin Dose Calculator and Meal Recording ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Buttons
                SizedBox(
                  width: 300, // Button width
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DosageInstructionsPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: const Color.fromARGB(255, 182, 255, 193),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/inso.png', // Replace with your image
                          width: 70,
                          height: 70,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Dosage Instructions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25), // Spacing between buttons
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const InsulinCalculatorScreen(), // Ensure InsulinCalculatorScreen is defined in calc.dart
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: const Color.fromARGB(255, 182, 255, 193),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/list.png',
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Food Lists & Calculator',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // Third Button: Recording & Calculation
                SizedBox(
                  width: 300, // Button width
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: const Color.fromARGB(255, 182, 255, 193),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/recordAndCalc.png', // Replace with your image
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Meal Records & History',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainCalc(),
  ));
}
