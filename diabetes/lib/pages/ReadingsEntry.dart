import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/consts/colors.dart';
import 'package:diabetes/pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:numberpicker/numberpicker.dart';

class DiabetesPage extends StatefulWidget {
  @override
  _DiabetesPageState createState() => _DiabetesPageState();
}

class _DiabetesPageState extends State<DiabetesPage> {
  // List to store timeline data, including status and time
  List<Map<String, dynamic>> timelineData = []; // Start with an empty list

  double _getMinY() {
    if (timelineData.isEmpty) return 0; // Default min value when no data
    return timelineData
            .map((data) => double.parse(data["value"].replaceAll(" mg/dL", "")))
            .reduce((a, b) => a < b ? a : b) -
        10; // Add padding
  }

  double _getMaxY() {
    if (timelineData.isEmpty) return 300; // Default max value when no data
    return timelineData
            .map((data) => double.parse(data["value"].replaceAll(" mg/dL", "")))
            .reduce((a, b) => a > b ? a : b) +
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
    var formattedDate;
    var formattedTime;
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
              title:
                  Text("Add New Entry", style: TextStyle(color: Colors.black)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Select Glucose Value",
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                    SizedBox(height: 16),
                    NumberPicker(
                      selectedTextStyle:
                          TextStyle(color: Colors.black, fontSize: 30),
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
                      textStyle: TextStyle(
                        fontSize: 30,
                        color: const Color.fromARGB(255, 120, 125, 120),
                      ),
                    ),
                    Text("Selected: $localSelectedValue mg/dL",
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                    SizedBox(height: 16),
                    Text("Select Status",
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                    SizedBox(height: 16),
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
                                  SizedBox(height: 8),
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
                  child: Text("Cancel", style: TextStyle(color: Colors.black)),
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
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Add"),
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
      final snapshot = await FirebaseFirestore.instance
          .collection('glucose_entries')
          .where('userId', isEqualTo: user.uid)
          .get();

      setState(() {
        timelineData = snapshot.docs.map((doc) {
          return {
            "value": doc["value"],
            "date": doc["date"],
            "time": doc["time"],
            "status": doc["status"],
            "icon": statusIcons[doc["status"]],
          };
        }).toList();
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            //Navigator.pushReplacementNamed(context, '/home');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        backgroundColor: const Color.fromARGB(255, 15, 177, 15),
        title: Text("Diabetes Average",
            style: TextStyle(color: Colors.white, fontSize: 24)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 15, 177, 15),
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Current",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    Text("120 mg/dL",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
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
            padding: EdgeInsets.only(left: 28, right: 8, top: 12, bottom: 8),
            child: LineChart(
              LineChartData(
                minY: _getMinY(),
                maxY: _getMaxY(),
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      interval:
                          (_getMaxY() - _getMinY()) / 5, // Dynamic intervals
                      getTitlesWidget: (value, meta) => Text('${value.toInt()}',
                          style: TextStyle(color: Colors.black)),
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
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 123, 122, 122),
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
                      final glucoseValue =
                          double.parse(data["value"].replaceAll(" mg/dL", ""));
                      return FlSpot(index, glucoseValue);
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
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
                    padding: EdgeInsets.all(16),
                    itemCount: timelineData.length,
                    itemBuilder: (context, index) {
                      final item = timelineData[index];
                      return TimelineTile(
                        value: item["value"],
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewValue,
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 15, 177, 15),
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
          child: Container(
            width: 20, // Width for the timeline
            height: 100, // Adjust based on content
          ),
        ),
        const SizedBox(width: 8),
        // Event details
        Expanded(
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8),
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 4),
                        Text("$date at $time",
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 4),
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

    final double circleRadius = 8.0;

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
