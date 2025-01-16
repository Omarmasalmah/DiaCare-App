import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/generated/l10n.dart';
import 'package:diabetes/pages/LocaleProvider.dart';
import 'package:diabetes/pages/ReadingsEntry.dart';
import 'package:diabetes/pages/UserListPage.dart';
import 'package:diabetes/pages/custom_chart_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diabetes/NavBar.dart';
import 'package:diabetes/pages/ChatPage.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final double glucoseAverage = 120.0; // Replace with your calculated average
  final double burnedCalories = 1500.0;
  final double earnedCalories = 1800.0;
  final int stepsWalked = 10000;
  final double someOtherValue = 75.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('HealthTrack'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () {
              // Navigate to the chat screen or handle the chat action
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        UserListPage()), // Replace ChatScreen with your actual chat screen widget
              );
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFF0F8FF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            HealthDashboardWidget(
              glucoseAverage: glucoseAverage,
              burnedCalories: burnedCalories,
              earnedCalories: earnedCalories,
              stepsWalked: stepsWalked,
              someOtherValue: someOtherValue,
            ),
            SizedBox(height: 20),
            DailyGlucoseCard(),
            SizedBox(height: 20),
            RemindersSection(),
            SizedBox(height: 20),
            // Add HealthDashboardWidget here

            ActivitySummaryCard(
              steps: '8,500',
              exercise: '45 min',
              calories: '300 kcal',
            ),
            SizedBox(height: 20),
            MealLogSection(),
            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle SOS button action
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("SOS"),
                content: Text("SOS button pressed!"),
                actions: <Widget>[
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.warning),
      ),
    );
  }
}

class DailyGlucoseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DiabetesPage()), // Navigate to DiabetesPage
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).translate("dailyGlucoseLevel"),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                // child: Image.network(
                //   'https://example.com/glucose_chart.png', // Replace with the URL of your image or use an AssetImage if local
                //   height: 150,
                //   width: double.infinity,
                //   fit: BoxFit.cover,
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivitySummaryCard extends StatelessWidget {
  final String steps;
  final String exercise;
  final String calories;

  ActivitySummaryCard({
    required this.steps,
    required this.exercise,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).translate("activitySummary"),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActivityItem(Icons.directions_walk,
                    S.of(context).translate("steps"), steps),
                _buildActivityItem(Icons.fitness_center,
                    S.of(context).translate("exercise"), exercise),
                _buildActivityItem(Icons.local_fire_department,
                    S.of(context).translate("calories"), calories),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class MealLogSection extends StatelessWidget {
  final List<Map<String, String>> meals = [
    {'name': 'Breakfast', 'carbs': '45g', 'time': '08:00 AM'},
    {'name': 'Lunch', 'carbs': '60g', 'time': '12:30 PM'},
    {'name': 'Dinner', 'carbs': '70g', 'time': '07:15 PM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).translate("recentMealLog"),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Doses')
                  .where('userId',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('timestamp', descending: true)
                  .limit(3)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text("Error loading meals : ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No meals logged yet"));
                }

                final meals = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final meal = data['selectedFoods']?.toString() ?? 'Unknown';
                  final calories = data['caloriesValue'] != null
                      ? '${data['caloriesValue']}'
                      : 'Unknown';
                  final time = data['timestamp'] != null
                      ? (data['timestamp'] as Timestamp)
                          .toDate()
                          .toLocal()
                          .toString()
                      : 'Unknown';
                  return Text(
                      'Meal: $meal\nCalories: $calories\nTime: $time\n');
                }).toList();

                return Column(
                  children: meals,
                );
              },
            ),
            // Column(
            //   children: meals.map((meal) => MealLogItem(meal)).toList(),
            // ),
          ],
        ),
      ),
    );
  }
}

// class MealLogItem extends StatelessWidget {
//   final Map<String, String> meal;

//   MealLogItem(this.meal);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             meal['name']!,
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           Text('Carbs: ${meal['carbs']}'),
//           Text('Time: ${meal['time']}'),
//         ],
//       ),
//     );
//   }
// }

// class MealLogItem extends StatelessWidget {
//   final Map<String, dynamic> meal;

//   MealLogItem(this.meal);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(meal['selectedFoods']),
//       subtitle: Text('Calories: ${meal['caloriesValue']}'),
//       trailing: Text(meal['timestamp'].toDate().toString()),
//     );
//   }
// }

class RemindersSection extends StatelessWidget {
  final List<Map<String, String>> reminders = [
    // {
    //   'title': 'Medication Time',
    //   'description': 'Take 2 tablets of Metformin',
    //   'time': '8:00 AM'
    // },
    // {
    //   'title': 'Doctor Appointment',
    //   'description': 'Appointment with Dr. Smith',
    //   'time': '2:00 PM'
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).translate("reminders"),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children:
                  reminders.map((reminder) => ReminderItem(reminder)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ReminderItem extends StatelessWidget {
  final Map<String, String> reminder;

  ReminderItem(this.reminder);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reminder['title']!,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(reminder['description']!),
          Text(reminder['time']!),
        ],
      ),
    );
  }
}
