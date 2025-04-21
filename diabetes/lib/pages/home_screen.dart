import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/pages/DiabetesYogaListPage.dart';
import 'package:diabetes/pages/DoctorFeeds.dart';
import 'package:diabetes/pages/ReadingsEntry.dart';
import 'package:diabetes/pages/UserListPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diabetes/NavBar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async'; // Import dart:async for StreamSubscription
// import pedometer: ^4.0.2
import 'package:pedometer/pedometer.dart';
import 'package:diabetes/main.dart';
import 'package:diabetes/NotificationService.dart';
import 'package:diabetes/pages/custom_chart_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:diabetes/pages/Google_map.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  // final double glucoseAverage = 120.0; // Replace with your calculated average
  final double burnedCalories = 822;
  final double earnedCalories = 1635;
  final int stepsWalked = 0;
  final double someOtherValue = 75.0;
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? glucoseAverage; // Variable to store glucoseAverage dynamically
  double? a1c; // Variable to store calculated A1C dynamically

  int _steps = 0; // Variable to store the step count
  late StreamSubscription<StepCount> _stepCountSubscription;

  List<Map<String, dynamic>> timelineData =
      []; // To store the data for the chart

  @override
  void initState() {
    super.initState();
    requestActivityPermission();
    _startStepCounting();
    _fetchChartData(); // Fetch chart data from Firebase
    _fetchAverageAndA1C(); // Fetch glucose average and A1C
  }

  Future<void> requestActivityPermission() async {
    var status = await Permission.activityRecognition.request();
    if (status.isDenied) {
      print("❌ Permission denied.");
    } else if (status.isGranted) {
      print("✅ Permission granted.");
    }
  }

  Future<void> _fetchAverageAndA1C() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final CollectionReference glucoseEntries =
            FirebaseFirestore.instance.collection('glucose_entries');
        final DateTime now = DateTime.now();
        final DateTime lastMonth = now.subtract(const Duration(days: 30));

        final QuerySnapshot snapshot = await glucoseEntries
            .where('userId', isEqualTo: user.uid)
            // .where('timestamp', isGreaterThanOrEqualTo: lastMonth)
            .get();

        print('Number of glucose entries fetched: ${snapshot.docs.length}');
        if (snapshot.docs.isEmpty) {
          setState(() {
            glucoseAverage = 0.0;
            a1c = 0.0;
          });
          print('No entries found.');
          return;
        }

        final List<double> glucoseValues = [];
        for (var doc in snapshot.docs) {
          try {
            String reading = doc['value'] as String;
            // print('Original Reading: "$reading"');

            // Normalize the reading
            reading = reading
                .trim()
                .replaceAll(
                    RegExp(r'\s+'), ' ') // Replace multiple spaces with single
                .replaceAll(
                    RegExp(r'[^\x20-\x7E]'), ''); // Remove non-ASCII characters
            // print('Normalized Reading: "$reading"');

            // Extract the numeric value
            final RegExp regex =
                RegExp(r'^\d+'); // Match digits at the start of the string
            final Match? match = regex.firstMatch(reading);

            if (match != null) {
              final double value = double.parse(match.group(0)!);
              glucoseValues.add(value);
              // print('Parsed value: $value');
            } else {
              print('No numeric value found in reading: "$reading"');
            }
          } catch (e) {
            print('Error processing document: $e');
          }
        }

        print('Parsed glucose values: $glucoseValues');
        if (glucoseValues.isEmpty) {
          setState(() {
            glucoseAverage = 0.0;
            a1c = 0.0;
          });
          return;
        }

        final double avgBG =
            glucoseValues.reduce((a, b) => a + b) / glucoseValues.length;
        final double estimatedA1C = (avgBG + 46.7) / 28.7;

        setState(() {
          glucoseAverage = avgBG;
          a1c = estimatedA1C;
        });

        print('Average Blood Glucose (mg/dL): $avgBG');
        print('Estimated A1C (%): $estimatedA1C');
      } catch (e) {
        print('An error occurred: $e');
      }
    }
  }

  // Fetch chart data for the current user
  void _fetchChartData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('glucose_entries')
          .where('userId', isEqualTo: user.uid)
          .get();

      setState(() {
        timelineData = snapshot.docs.map((doc) {
          return {
            "value": doc["value"],
            "date": doc["date"],
          };
        }).toList();
      });
    }
  }

  // Method to start step counting
  void _startStepCounting() {
    // Listen to the pedometer step count stream
    _stepCountSubscription = Pedometer.stepCountStream.listen(
      (StepCount stepCount) {
        // Update the step count synchronously
        setState(() {
          _steps = stepCount.steps; // Update the steps count
        });
      },
      onError: (error) {
        print('Error in step count stream: $error');
      },
    );
  }

  // Cancel the subscription to stop listening to the stream when the widget is disposed.
  @override
  void dispose() {
    _stepCountSubscription.cancel();
    super.dispose();
  }

  void _sendSOS(BuildContext context) async {
    final BuildContext rootContext =
        context; // Store a stable context reference
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(rootContext).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    try {
      QuerySnapshot contactsSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('contacts')
          .get();

      List<String> emailList =
          contactsSnapshot.docs.map((doc) => doc['contact'] as String).toList();

      if (emailList.isEmpty) {
        ScaffoldMessenger.of(rootContext).showSnackBar(
          const SnackBar(content: Text("No emergency contacts found!")),
        );
        return;
      }

      final Email email = Email(
        body:
            "🚨 SOS Alert! 🚨\n\nThis is an emergency alert from your contact.",
        subject: "🚨 EMERGENCY ALERT 🚨",
        recipients: emailList,
        isHTML: false,
      );

      await FlutterEmailSender.send(email);

      ScaffoldMessenger.of(rootContext).showSnackBar(
        const SnackBar(content: Text("SOS Alert Sent Successfully!")),
      );
    } catch (e) {
      print("Error sending SOS: $e");
      // ScaffoldMessenger.of(rootContext).showSnackBar(
      //   SnackBar(content: Text("Error sending SOS: $e")),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call daily reminders and user activity monitoring when the home screen loads
    /*  NotificationService.showDailyReminder(
      'Remember to log your blood sugar levels!',
      1,
      DateTime(19, 29), // Reminder at 8:00 AM daily
    );*/

    // monitorUserActivity(); // Check if the user has logged their data today

    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('HealthTrack',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        centerTitle: true,
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Color.fromARGB(255, 41, 175, 45)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.facebookMessenger,
              color: Colors.white,
            ),
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
      backgroundColor: const Color.fromARGB(255, 226, 244, 222),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DailyGlucoseCard(timelineData: timelineData), // Pass data here
            HealthDashboardWidget(
              glucoseAverage: a1c ?? 0.0,
              burnedCalories: widget.burnedCalories,
              earnedCalories: widget.earnedCalories,
              stepsWalked: _steps,
              someOtherValue: widget.someOtherValue,
            ),

            SizedBox(height: 20),
            const SizedBox(height: 20),
            RemindersSection(),
            const SizedBox(height: 20),
            ActivitySummaryCard(
              steps: '$_steps', // Use the live step count here
              exercise: '45 min',
              calories: '300 kcal',
            ),
            const SizedBox(height: 20),
            MealLogSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle SOS button action
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("SOS"),
                content:
                    const Text("Are you sure you want to send an SOS alert?"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: const Text("Send SOS"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      _sendSOS(context); // Call function to send SOS
                    },
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.warning, size: 30),
        shape: const CircleBorder(),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 6.0,
        shape: const CircularNotchedRectangle(),
        color: const Color.fromARGB(255, 0, 0, 0),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 34),
                onPressed: () {
                  // Navigate to the home screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const HomeScreen()), // Replace HomeScreen with your actual home screen widget
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.feed, color: Colors.white, size: 34),
                onPressed: () {
                  // Navigate to the readings entry screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const DoctorFeeds()), // Replace ReadingsEntry with your actual readings entry screen widget
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.location_pin,
                    color: Colors.white, size: 34),
                onPressed: () {
                  // Navigate to the home screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GoogleMaps()), // Replace HomeScreen with your actual home screen widget
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.fitness_center,
                    color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to the custom chart screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const DiabetesYogaListPage()), // Replace CustomChartPage with your actual custom chart screen widget
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DailyGlucoseCard extends StatelessWidget {
  final List<Map<String, dynamic>> timelineData;

  const DailyGlucoseCard({super.key, required this.timelineData});

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color.fromARGB(255, 213, 232, 249),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily Glucose Level',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Times New Roman',
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200, // Set desired height
                child: timelineData.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : LineChart(
                        LineChartData(
                          minY: _getMinY(),
                          maxY: _getMaxY(),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: (_getMaxY() - _getMinY()) / 5,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.withOpacity(0.2),
                              strokeWidth: 1,
                            ),
                          ),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                interval: (_getMaxY() - _getMinY()) / 5,
                                getTitlesWidget: (value, meta) => Text(
                                    '${value.toInt()}',
                                    style:
                                        const TextStyle(color: Colors.black)),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                getTitlesWidget: (value, meta) {
                                  if (timelineData.isEmpty) return Container();

                                  final index = value.toInt();
                                  if (index >= 0 &&
                                      index < timelineData.length) {
                                    final date = timelineData[index]["date"];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text(
                                        date ?? "",
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 123, 122, 122),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false, // Hide borders
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: timelineData.map((data) {
                                final index =
                                    timelineData.indexOf(data).toDouble();
                                final glucoseValue = double.parse(
                                    data["value"]!.replaceAll(" mg/dL", ""));
                                return FlSpot(index, glucoseValue);
                              }).toList(),
                              isCurved: true,
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    const Color.fromARGB(255, 5, 176, 238)
                                        .withOpacity(0.4),
                                    const Color.fromARGB(0, 1, 1, 5),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getMinY() {
    if (timelineData.isEmpty) return 0; // Default min value when no data
    return timelineData
            .map((data) =>
                double.parse(data["value"]?.replaceAll(" mg/dL", "") ?? "0"))
            .reduce((a, b) => a < b ? a : b) -
        10; // Add padding
  }

  double _getMaxY() {
    if (timelineData.isEmpty) return 300; // Default max value when no data
    return timelineData
            .map((data) =>
                double.parse(data["value"]?.replaceAll(" mg/dL", "") ?? "0"))
            .reduce((a, b) => a > b ? a : b) +
        10; // Add padding
  }
}

class ActivitySummaryCard extends StatelessWidget {
  final String steps;
  final String exercise;
  final String calories;

  const ActivitySummaryCard({
    super.key,
    required this.steps,
    required this.exercise,
    required this.calories,
  });

  Future<VideoPlayerController?> _initializeVideo(String videoUrl) async {
    try {
      VideoPlayerController videoController =
          VideoPlayerController.network(videoUrl);
      await videoController.initialize();
      return videoController;
    } catch (e) {
      print("Error initializing video: $e");
      return null;
    }
  }

  Future<void> _openDocument(String filePath) async {
    final Uri uri = Uri.parse(filePath); // Convert to URI
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not open file: $filePath");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Could not open document.")),
      // );
    }
  }

  Future<String> _fetchDoctorName(String? userId) async {
    if (userId == null) return "Unknown Doctor"; // Handle missing userId

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users') // Replace with your users collection name
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc['name'] ??
            "Doctor Name Missing"; // Return the doctor’s name
      } else {
        return "Doctor Not Found"; // Handle case if user doesn't exist
      }
    } catch (e) {
      print("Error fetching doctor name: $e");
      return "Error Fetching Name"; // Return error message if fetching fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorFeeds()),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Doctor Feeds',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('createdAt', descending: true) // Get latest post
                    .limit(1) // Fetch only one post
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Error loading feed: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("No recent posts available.",
                        style: TextStyle(fontSize: 14, color: Colors.grey));
                  }

                  final latestPost =
                      snapshot.data!.docs.first.data() as Map<String, dynamic>;
                  final String postText = latestPost['text'] ?? 'No content';
                  final String? imageUrl = latestPost['image'];
                  final String? videoUrl = latestPost['video'];
                  final String? documentUrl = latestPost['document'];
                  final String userId = latestPost['userId'];

                  return FutureBuilder<String>(
                    future: _fetchDoctorName(userId), // Fetch doctor's name
                    builder: (context, nameSnapshot) {
                      String doctorName = nameSnapshot.data ?? "Unknown Doctor";

                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Doctor's Name & Profile
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    child: Text(
                                      doctorName[
                                          0], // First letter of the doctor's name
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Dr. $doctorName",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Post Content
                              Text(
                                postText,
                                style: const TextStyle(fontSize: 16),
                              ),

                              // Display Image if Available
                              if (imageUrl != null && imageUrl.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(imageUrl,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover),
                                  ),
                                ),

                              // Display Video if Available
                              if (videoUrl != null && videoUrl.isNotEmpty)
                                FutureBuilder<VideoPlayerController?>(
                                  future: _initializeVideo(videoUrl),
                                  builder: (context, videoSnapshot) {
                                    if (videoSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (!videoSnapshot.hasData ||
                                        videoSnapshot.data == null) {
                                      return const Text("Error loading video");
                                    }
                                    VideoPlayerController videoController =
                                        videoSnapshot.data!;
                                    return Column(
                                      children: [
                                        AspectRatio(
                                          aspectRatio:
                                              videoController.value.aspectRatio,
                                          child: VideoPlayer(videoController),
                                        ),
                                        VideoProgressIndicator(videoController,
                                            allowScrubbing: true),
                                      ],
                                    );
                                  },
                                ),

                              // Display Document if Available
                              if (documentUrl != null && documentUrl.isNotEmpty)
                                ListTile(
                                  leading: const Icon(Icons.insert_drive_file,
                                      color: Colors.orange),
                                  title: Text(
                                    documentUrl.split('/').last,
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                  onTap: () => _openDocument(documentUrl),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  MealLogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Meal Log',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
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
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text("Error loading meals: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("No meals logged yet",
                          style: TextStyle(fontSize: 16, color: Colors.grey)));
                }

                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final meal = data['selectedFoods']?.toString() ?? 'Unknown';
                    final calories =
                        data['caloriesValue']?.toString() ?? 'Unknown';
                    final time = data['timestamp'] != null
                        ? (data['timestamp'] as Timestamp)
                            .toDate()
                            .toLocal()
                            .toString()
                        : 'Unknown';

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.teal,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Calories: $calories",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                Expanded(
                                  // ✅ Prevents overflow
                                  child: Text(
                                    time,
                                    textAlign:
                                        TextAlign.right, // Aligns text to right
                                    overflow: TextOverflow
                                        .ellipsis, // ✅ Prevents overflow
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RemindersSection extends StatelessWidget {
  final List<Map<String, String>> reminders = [
    {'title': 'Blood Sugar Test', 'time': '08:00 AM'},
    {'title': 'Exercise Reminder', 'time': '10:30 AM'},
    {'title': 'Medications', 'time': '01:00 PM'},
  ];

  RemindersSection({super.key});

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
            const Text(
              'Reminders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: reminders.map((reminder) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(reminder['title']!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(reminder['time']!,
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
