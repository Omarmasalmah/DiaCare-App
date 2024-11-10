import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HealthTrack'),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFF0F8FF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DailyGlucoseCard(),
            SizedBox(height: 20),
            RemindersSection(),
            SizedBox(height: 20),
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
    );
  }
}

class DailyGlucoseCard extends StatelessWidget {
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
              'Daily Glucose Level',
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
              'Activity Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActivityItem(Icons.directions_walk, 'Steps', steps),
                _buildActivityItem(Icons.fitness_center, 'Exercise', exercise),
                _buildActivityItem(
                    Icons.local_fire_department, 'Calories', calories),
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
              'Recent Meal Log',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: meals.map((meal) => MealLogItem(meal)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class MealLogItem extends StatelessWidget {
  final Map<String, String> meal;

  MealLogItem(this.meal);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meal['name']!,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text('Carbs: ${meal['carbs']}'),
          Text('Time: ${meal['time']}'),
        ],
      ),
    );
  }
}

class RemindersSection extends StatelessWidget {
  final List<Map<String, String>> reminders = [
    {
      'title': 'Medication Time',
      'description': 'Take 2 tablets of Metformin',
      'time': '8:00 AM'
    },
    {
      'title': 'Doctor Appointment',
      'description': 'Appointment with Dr. Smith',
      'time': '2:00 PM'
    },
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
              'Reminders',
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
