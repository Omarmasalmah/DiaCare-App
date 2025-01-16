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
        // Central Chart
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            children: [
              PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: glucoseAverage,
                      color: Colors.blue,
                      radius: 50,
                      title: '${glucoseAverage.toStringAsFixed(1)} mg/dL',
                      titleStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 300 - glucoseAverage,
                      color: Colors.grey[200],
                      radius: 50,
                      title: '',
                    ),
                  ],
                  centerSpaceRadius: 40,
                  startDegreeOffset: -90,
                ),
              ),
              const Center(
                child: Text(
                  "Average\nGlucose",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),

        // Surrounding Metrics
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 50,
          runSpacing: 30,
          children: [
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
            _buildMetricCircle(
              title: "Other",
              value: "${someOtherValue.toStringAsFixed(1)}%",
              color: Colors.purple,
              icon: Icons.show_chart,
            ),
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



// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class CustomChartPage extends StatelessWidget {
//   final double glucoseAverage = 200.0; // Replace with your calculated average
//   final double burnedCalories = 1500.0;
//   final double earnedCalories = 1800.0;
//   final int stepsWalked = 10000;
//   final double someOtherValue = 75.0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("Health Dashboard"),
//         centerTitle: true,
//         backgroundColor: Colors.green,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Central Chart
//             SizedBox(
//               width: 200,
//               height: 200,
//               child: Stack(
//                 children: [
//                   PieChart(
//                     PieChartData(
//                       sections: [
//                         PieChartSectionData(
//                           value: glucoseAverage,
//                           color: Colors.blue,
//                           radius: 50,
//                           title: '${glucoseAverage.toStringAsFixed(1)} mg/dL',
//                           titleStyle: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                             color: Colors.white,
//                           ),
//                         ),
//                         PieChartSectionData(
//                           value: 300 - glucoseAverage,
//                           color: Colors.grey[200],
//                           radius: 50,
//                           title: '',
//                         ),
//                       ],
//                       centerSpaceRadius: 40,
//                       startDegreeOffset: -90,
//                     ),
//                   ),
//                   Center(
//                     child: Text(
//                       "Average\nGlucose",
//                       textAlign: TextAlign.center,
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 50),

//             // Surrounding Metrics
//             Wrap(
//               alignment: WrapAlignment.center,
//               spacing: 50,
//               runSpacing: 30,
//               children: [
//                 _buildMetricCircle(
//                   context,
//                   title: "Burned",
//                   value: "${burnedCalories.toStringAsFixed(1)} kcal",
//                   color: Colors.orange,
//                   icon: Icons.local_fire_department,
//                 ),
//                 _buildMetricCircle(
//                   context,
//                   title: "Earned",
//                   value: "${earnedCalories.toStringAsFixed(1)} kcal",
//                   color: Colors.green,
//                   icon: Icons.restaurant_menu,
//                 ),
//                 _buildMetricCircle(
//                   context,
//                   title: "Steps",
//                   value: stepsWalked.toString(),
//                   color: Colors.blue,
//                   icon: Icons.directions_walk,
//                 ),
//                 _buildMetricCircle(
//                   context,
//                   title: "Other",
//                   value: "${someOtherValue.toStringAsFixed(1)}%",
//                   color: Colors.purple,
//                   icon: Icons.show_chart,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget for each surrounding metric circle
//   Widget _buildMetricCircle(
//     BuildContext context, {
//     required String title,
//     required String value,
//     required Color color,
//     required IconData icon,
//   }) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 40,
//           backgroundColor: color.withOpacity(0.2),
//           child: Icon(
//             icon,
//             size: 40,
//             color: color,
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           value,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         Text(
//           title,
//           style: TextStyle(
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }
// }
