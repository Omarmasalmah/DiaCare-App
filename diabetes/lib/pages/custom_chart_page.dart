import 'package:diabetes/pages/ReadingsEntry.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthDashboardWidget extends StatelessWidget {
  final double glucoseAverage;
  final double burnedCalories;
  final double earnedCalories;
  final int stepsWalked;
  final double someOtherValue;

  const HealthDashboardWidget({
    Key? key,
    required this.glucoseAverage,
    required this.burnedCalories,
    required this.earnedCalories,
    required this.stepsWalked,
    required this.someOtherValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        // Surrounding Metrics
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 50,
          runSpacing: 10,
          children: [
            //  Glucose Average
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DiabetesPage()), // Navigate to DiabetesPage
                );
              },
              child: Container(
                width: 200,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(
                      255, 226, 244, 222), // Background color
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Outer border
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(
                            255, 41, 187, 25), // Circle border color
                      ),
                    ),
                    // Inner circle
                    Container(
                      width: 80,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 255, 255,
                            255), // Inner circle background color
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${glucoseAverage.toStringAsFixed(1)}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Text color
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Title at the bottom
                    Positioned(
                      bottom: 10,
                      child: const Text(
                        "Glucose HbA1c %",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              Color.fromARGB(255, 0, 0, 0), // Title text color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _buildMetricCircle(
              title: "Burned",
              value: "${burnedCalories.toStringAsFixed(1)} kcal",
              color: Colors.orange,
              icon: Icons.local_fire_department,
            ),
            _buildMetricCircle(
              title: "Earned",
              value: "${earnedCalories.toStringAsFixed(1)} kcal",
              color: Colors.green,
              icon: Icons.restaurant_menu,
            ),
            _buildMetricCircle(
              title: "Steps",
              value: stepsWalked.toString(),
              color: Colors.blue,
              icon: Icons.directions_walk,
            ),
            // _buildMetricCircle(
            //   title: "Other",
            //   value: "${someOtherValue.toStringAsFixed(1)}%",
            //   color: Colors.purple,
            //   icon: Icons.show_chart,
            // ),
          ],
        ),
      ],
    );
  }

  // Widget for each surrounding metric circle
  Widget _buildMetricCircle({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(
            icon,
            size: 40,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
