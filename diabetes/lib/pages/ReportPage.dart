import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class ReportPage extends StatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;

  const ReportPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> recentExercises = [];
  List<Map<String, dynamic>> recentMeals = [];
  // List<Map<String, dynamic>> recentMedications = [];

  double? glucoseAverage; // Variable to store glucoseAverage dynamically
  double? a1c; // Variable to store calculated A1C dynamically
  int? days; // Variable to store measured days dynamically

  final ScrollController _exercisesScrollController = ScrollController();
  final ScrollController _mealsScrollController = ScrollController();

  @override
  void dispose() {
    _exercisesScrollController.dispose();
    _mealsScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchRecentExercises();
    _fetchRecentMeals();
    _fetchAverageAndA1C();
  }

  Future<void> _fetchAverageAndA1C() async {
    try {
      final CollectionReference glucoseEntries =
          FirebaseFirestore.instance.collection('glucose_entries');
      final DateTime now = DateTime.now();
      final DateFormat dateFormat =
          DateFormat('d MMM yyyy'); // Define the date format

      final QuerySnapshot snapshot =
          await glucoseEntries.where('userId', isEqualTo: widget.userId).get();

      print('Number of glucose entries fetched: ${snapshot.docs.length}');
      if (snapshot.docs.isEmpty) {
        setState(() {
          glucoseAverage = 0.0;
          a1c = 0.0;
          days = 0;
        });
        print('No entries found.');
        return;
      }

      final List<double> glucoseValues = [];
      DateTime? firstReadingDate;

      for (var doc in snapshot.docs) {
        try {
          String reading = doc['value'] as String;
          String dateString = doc['date'] as String; // Extract the date string

          DateTime readingDate =
              dateFormat.parse(dateString); // Convert to DateTime

          if (firstReadingDate == null ||
              readingDate.isBefore(firstReadingDate)) {
            firstReadingDate = readingDate;
          }

          reading = reading
              .trim()
              .replaceAll(
                  RegExp(r'\s+'), ' ') // Replace multiple spaces with single
              .replaceAll(
                  RegExp(r'[^\x20-\x7E]'), ''); // Remove non-ASCII characters

          final RegExp regex =
              RegExp(r'^\d+'); // Match digits at the start of the string
          final Match? match = regex.firstMatch(reading);

          if (match != null) {
            final double value = double.parse(match.group(0)!);
            glucoseValues.add(value);
          } else {
            print('No numeric value found in reading: "$reading"');
          }
        } catch (e) {
          print('Error processing document: $e');
        }
      }

      print('Parsed glucose values: $glucoseValues');

      if (glucoseValues.isEmpty || firstReadingDate == null) {
        setState(() {
          glucoseAverage = 0.0;
          a1c = 0.0;
          days = 0;
        });
        return;
      }

      final double avgBG =
          glucoseValues.reduce((a, b) => a + b) / glucoseValues.length;
      final double estimatedA1C = (avgBG + 46.7) / 28.7;

      int measuredDays =
          now.difference(firstReadingDate).inDays + 1; // Include first day

      setState(() {
        glucoseAverage = avgBG;
        a1c = estimatedA1C;
        days = measuredDays;
      });

      print('Measured For: $measuredDays days');
      print('Average Blood Glucose (mg/dL): $avgBG');
      print('Estimated A1C (%): $estimatedA1C');
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> _fetchRecentMeals() async {
    try {
      QuerySnapshot mealSnapshot = await FirebaseFirestore.instance
          .collection('Doses')
          .where('userId', isEqualTo: widget.userId)
          // .orderBy('timestamp', descending: true) // Ensure meals are sorted
          .limit(3)
          .get();

      List<Map<String, dynamic>> meals = mealSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        return {
          'insulinValue': data['insulinValue'] != null
              ? double.parse(data['insulinValue'].toString()).toStringAsFixed(2)
              : '0.00',
          'mealName': data['selectedFoods'] ?? 'Unknown Meal',
          'calories': data['caloriesValue'] != null
              ? double.parse(data['caloriesValue'].toString())
                  .toStringAsFixed(2)
              : '0.00',
          'timestamp': data['timestamp'] is Timestamp
              ? _formatTimestamp(data['timestamp'])
              : 'Invalid Timestamp',
        };
      }).toList();

      setState(() {
        recentMeals = meals;
      });
    } catch (e) {
      debugPrint("Error fetching meals: $e");
    }
  }

  // Fetch User Data from Firestore
  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        // Calculate Age
        int age = _calculateAge(data['birthdate']);

        setState(() {
          userData = {
            'name': data['name'] ?? 'Unknown',
            'birthdate': data['birthdate'] ?? 'Unknown',
            'age': age,
            'phoneNumber': data['phoneNumber'] ?? 'N/A',
            'diabetesType': data['diabetesType'] ?? 'N/A',
            'weight': data['weight']?.toString() ?? 'N/A',
          };
        });
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  // Fetch Last 3 Exercises from Firestore (Sorted by Timestamp)
  Future<void> _fetchRecentExercises() async {
    try {
      QuerySnapshot exerciseSnapshot = await FirebaseFirestore.instance
          .collection('exercises')
          .where('userId', isEqualTo: widget.userId)
          // .orderBy('timestamp', descending: true)
          .limit(3)
          .get();

      List<Map<String, dynamic>> exercises = exerciseSnapshot.docs.map((doc) {
        // Convert caloriesBurned to double and format to 2 decimal places
        String formattedCalories = doc['caloriesBurned'] != null
            ? double.parse(doc['caloriesBurned'].toString()).toStringAsFixed(2)
            : '0.00';

        return {
          'exerciseName': doc['exerciseName'] ?? 'Unknown Exercise',
          'caloriesBurned': formattedCalories,
          'timestamp': _formatTimestamp(doc['timestamp']),
        };
      }).toList();

      setState(() {
        recentExercises = exercises;
      });
    } catch (e) {
      debugPrint("Error fetching exercises: $e");
    }
  }

  // Calculate Age from Birthdate String (Format: 'YYYY-MM-DD')
  int _calculateAge(String birthdate) {
    try {
      DateTime dob = DateFormat('yyyy-MM-dd').parse(birthdate);
      DateTime today = DateTime.now();
      int age = today.year - dob.year;
      if (today.month < dob.month ||
          (today.month == dob.month && today.day < dob.day)) {
        age--; // Adjust if the birthday hasn't occurred yet this year
      }
      return age;
    } catch (e) {
      debugPrint("Error parsing birthdate: $e");
      return 0; // Default to 0 if parsing fails
    }
  }

  // Format Timestamp to Readable Date
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate());
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            const Text("Patient Report", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Patient Details",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildInfoRow("Name", userData!['name']),
                      _buildInfoRow("Birthdate", userData!['birthdate']),
                      _buildInfoRow("Age", userData!['age'].toString()),
                      _buildInfoRow("Phone", userData!['phoneNumber']),
                      _buildInfoRow("Diabetes Type", userData!['diabetesType']),
                      _buildInfoRow("Weight", "${userData!['weight']} kg"),
                      _buildInfoRow(
                          "Average BG", glucoseAverage!.toStringAsFixed(2)),
                      _buildInfoRow("Estimated A1C", a1c!.toStringAsFixed(2)),
                      _buildInfoRow("Measured Days", days.toString()),

                      const SizedBox(height: 20),

                      // **Scrollable Recent Exercises Section**
                      Text(
                        "Recent Exercises",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      recentExercises.isEmpty
                          ? const Text("No exercises found.")
                          : SizedBox(
                              height: 200,
                              child: Scrollbar(
                                controller:
                                    _exercisesScrollController, // Attach ScrollController
                                thumbVisibility: true, // Visible scrollbar
                                child: SingleChildScrollView(
                                  controller:
                                      _exercisesScrollController, // Attach Controller
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: recentExercises.map((exercise) {
                                      return _buildExerciseCard(exercise);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),

                      const SizedBox(height: 20),

                      // **Scrollable Recent Meals Section**
                      Text(
                        "Recent Doses & Meals",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      recentMeals.isEmpty
                          ? const Text("No meals found.")
                          : SizedBox(
                              height: 200,
                              child: Scrollbar(
                                controller:
                                    _mealsScrollController, // Attach ScrollController
                                thumbVisibility: true, // Visible scrollbar
                                child: SingleChildScrollView(
                                  controller:
                                      _mealsScrollController, // Attach Controller
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: recentMeals.map((meal) {
                                      return _buildMealCard(meal);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // Helper Widget to Build Info Rows
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  // Helper Widget to Build Exercise Card
  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.fitness_center, color: Colors.teal),
        title: Text(
          exercise['exerciseName'],
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Calories Burned: ${exercise['caloriesBurned']}"),
        trailing: Text(
          exercise['timestamp'],
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.fastfood, color: Colors.orange),
        title: Text(
          meal['mealName'],
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Calories: ${meal['calories']} kcal"),
            Text(
                "Insulin Dose: ${meal['insulinValue'] ?? 'N/A'} units"), // New field
          ],
        ),
        trailing: Text(
          meal['timestamp'],
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }
}
