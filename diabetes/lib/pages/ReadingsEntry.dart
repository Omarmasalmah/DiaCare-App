import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/pages/DiabetesYogaListPage.dart';
import 'package:diabetes/pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:numberpicker/numberpicker.dart';

class DiabetesPage extends StatefulWidget {
  const DiabetesPage({super.key});

  @override
  _DiabetesPageState createState() => _DiabetesPageState();
}

class _DiabetesPageState extends State<DiabetesPage> {
  // List to store timeline data, including status and time
  List<Map<String, dynamic>> timelineData = []; // Start with an empty list
  double _averageGlucose = 0; // Default average glucose value

  double _getMinY() {
    if (timelineData.isEmpty) return 0; // Default min value when no data
    return timelineData.map((data) {
          final rawValue = data["value"].toString();
          final numericValue =
              rawValue.replaceAll(" mg/dL", ""); // Remove the unit
          return double.parse(numericValue);
        }).reduce((a, b) => a < b ? a : b) -
        10; // Add padding
  }

  double _getMaxY() {
    if (timelineData.isEmpty) return 300; // Default max value when no data
    return timelineData.map((data) {
          final rawValue = data["value"].toString();
          final numericValue =
              rawValue.replaceAll(" mg/dL", ""); // Remove the unit
          return double.parse(numericValue);
        }).reduce((a, b) => a > b ? a : b) +
        10; // Add padding
  }

  int _selectedValue = 120; // Default selected glucose value
  String _selectedStatus = "fasting"; // Default status

  // Map to associate statuses with icons
  final Map<String, IconData> statusIcons = {
    "fasting": Icons.breakfast_dining,
    "pre-meal": Icons.ramen_dining,
    "post-meal": Icons.fastfood,
    "before sleep": Icons.nights_stay,
    "general": Icons.local_hospital,
  };

  @override
  void initState() {
    super.initState();
    _fetchGlucoseEntries();
  }

  void _addNewValue() {
    String formattedDate = "";
    String formattedTime = "";
    showDialog(
      context: context,
      builder: (context) {
        int localSelectedValue =
            _selectedValue; // Temporary local variable for glucose value
        String localSelectedStatus =
            _selectedStatus; // Temporary local variable for status
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 227, 223, 223),
              title: const Text("Add New Entry",
                  style: TextStyle(color: Colors.black)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Select Glucose Value",
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                    const SizedBox(height: 16),
                    NumberPicker(
                      selectedTextStyle:
                          const TextStyle(color: Colors.black, fontSize: 30),
                      value: localSelectedValue, // Use local variable
                      minValue: 0,
                      maxValue: 300,
                      step: 1,
                      itemHeight: 50,
                      onChanged: (value) {
                        setDialogState(() {
                          localSelectedValue = value; // Update locally
                        });
                      },
                      textStyle: const TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 120, 125, 120),
                      ),
                    ),
                    Text("Selected: $localSelectedValue mg/dL",
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black)),
                    const SizedBox(height: 16),
                    const Text("Select Status",
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: statusIcons.entries.map((entry) {
                          final isSelected = localSelectedStatus == entry.key;
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                localSelectedStatus = entry.key;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isSelected
                                        ? const Color.fromARGB(255, 40, 185, 57)
                                        : Colors
                                            .white, // Set to white when not selected
                                    child: Icon(
                                      entry.value,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(entry.key,
                                      style: TextStyle(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.grey)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      final currentDate = DateTime.now();
                      formattedDate =
                          "${currentDate.day} ${_monthName(currentDate.month)} ${currentDate.year}";
                      formattedTime =
                          "${currentDate.hour}:${currentDate.minute.toString().padLeft(2, '0')} ${currentDate.hour >= 12 ? 'PM' : 'AM'}";

                      _selectedValue =
                          localSelectedValue; // Update global value
                      _selectedStatus =
                          localSelectedStatus; // Update global status
                      timelineData.add({
                        "value": "$_selectedValue mg/dL",
                        "date": formattedDate,
                        "time": formattedTime,
                        "status": _selectedStatus,
                        "icon": statusIcons[_selectedStatus],
                      });
                    });
                    // Save to Firestore
                    try {
                      final user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        await FirebaseFirestore.instance
                            .collection('glucose_entries')
                            .add({
                          "value": "$_selectedValue mg/dL",
                          "date": formattedDate,
                          "time": formattedTime,
                          "status": _selectedStatus,
                          //"icon": statusIcons[_selectedStatus],
                          "userId": user.uid, // Add the current user's UID
                        });

                        print("Data saved successfully");
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error saving data: $e")),
                        );
                      }
                    }

                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 40, 185, 57),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _fetchGlucoseEntries() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('glucose_entries')
            .where('userId', isEqualTo: user.uid)
            .get();

        setState(() {
          timelineData = snapshot.docs.map((doc) {
            return {
              "value": double.parse(doc["value"].replaceAll(" mg/dL", "")),
              "date": doc["date"],
              "time": doc["time"],
              "status": doc["status"],
              "icon": statusIcons[doc["status"]],
            };
          }).toList();
          _calculateAverageGlucose(timelineData);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching data: $e")),
        );
      }
    }
  }

  /// Calculate average glucose
  void _calculateAverageGlucose(List<Map<String, dynamic>> timelineData) {
    if (timelineData.isNotEmpty) {
      final totalGlucose = timelineData.fold<double>(
        0.0,
        (sum, entry) => sum + (entry["value"] ?? 0.0),
      );

      setState(() {
        _averageGlucose = totalGlucose / timelineData.length;
        print(timelineData.length);
      });
    }
  }

  String _monthName(int month) {
    const monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            //Navigator.pushReplacementNamed(context, '/home');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        backgroundColor: const Color.fromARGB(255, 15, 177, 15),
        title: const Text("Diabetes Average",
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
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Color.fromARGB(255, 41, 175, 45)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Average Glucose",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    Text(
                      "${_averageGlucose.toStringAsFixed(1)} mg/dL",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Target",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    Text("80-130 mg/dL",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            padding:
                const EdgeInsets.only(left: 28, right: 8, top: 12, bottom: 8),
            child: LineChart(
              LineChartData(
                minY: _getMinY(),
                maxY: _getMaxY(),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      interval:
                          (_getMaxY() - _getMinY()) / 5, // Dynamic intervals
                      getTitlesWidget: (value, meta) => Text('${value.toInt()}',
                          style: const TextStyle(color: Colors.black)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (timelineData.isEmpty) return Container();

                        final index = value.toInt();
                        if (index >= 0 && index < timelineData.length) {
                          final date = timelineData[index]["date"];
                          final dateParts = date.split(' ');
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              "${dateParts[0]} ${dateParts[1]}",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 123, 122, 122),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
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
                  show: false, // Hide the borders
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: timelineData.map((data) {
                      final index = timelineData.indexOf(data).toDouble();
                      final rawValue = data["value"].toString();
                      final glucoseValue = double.parse(
                          rawValue.replaceAll(" mg/dL", "")); // Parse to double
                      return FlSpot(index, glucoseValue); // Use double values
                    }).toList(),
                    isCurved: true,
                    barWidth: 3,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Timeline",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: timelineData.length,
                    itemBuilder: (context, index) {
                      final item = timelineData[index];
                      return TimelineTile(
                        value: "${item["value"].toStringAsFixed(1)} mg/dL",
                        date: item["date"],
                        time: item["time"],
                        status: item["status"],
                        icon: item["icon"],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewValue,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 15, 177, 15),
        child: const Icon(Icons.add, size: 32),
        shape: const CircleBorder(),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 9.0,
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
                            const HomeScreen()), // Replace ReadingsEntry with your actual readings entry screen widget
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 34),
                onPressed: () {
                  // Navigate to the home screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const DiabetesPage()), // Replace HomeScreen with your actual home screen widget
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

class TimelineTile extends StatelessWidget {
  final String value;
  final String date;
  final String time;
  final String status;
  final IconData icon;
  final bool isFirst; // To control the starting line
  final bool isLast; // To control the ending line

  const TimelineTile({
    super.key,
    required this.value,
    required this.date,
    required this.time,
    required this.status,
    required this.icon,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom timeline drawing
        CustomPaint(
          painter: TimelinePainter(
            isFirst: isFirst,
            isLast: isLast,
          ),
          child: const SizedBox(
            width: 20, // Width for the timeline
            height: 100, // Adjust based on content
          ),
        ),
        const SizedBox(width: 8),
        // Event details
        Expanded(
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: const Color.fromARGB(255, 240, 240, 240),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Status icon inside the box
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color.fromARGB(255, 78, 161, 84),
                    child: Icon(icon, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  // Event details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(value,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Text("$date at $time",
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text("Status: $status"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TimelinePainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final Color circleColor;

  TimelinePainter({
    this.isFirst = false,
    this.isLast = false,
    this.circleColor = Colors.green, // Default color for the circle
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final circlePaint = Paint()
      ..color = circleColor // Use the provided circle color
      ..style = PaintingStyle.fill;

    const double circleRadius = 8.0;

    // Draw top line
    if (!isFirst) {
      canvas.drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height / 2 - circleRadius),
        linePaint,
      );
    }

    // Draw circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      circleRadius,
      circlePaint,
    );

    // Draw bottom line
    if (!isLast) {
      canvas.drawLine(
        Offset(size.width / 2, size.height / 2 + circleRadius),
        Offset(size.width / 2, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
