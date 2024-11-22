import 'package:diabetes/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:numberpicker/numberpicker.dart'; // Add this dependency in pubspec.yaml

class DiabetesPage extends StatefulWidget {
  @override
  _DiabetesPageState createState() => _DiabetesPageState();
}

class _DiabetesPageState extends State<DiabetesPage> {
  // List to store timeline data, now including time
  List<Map<String, dynamic>> timelineData = [
    {
      "value": "120 mg/dL",
      "date": "21 Nov 2024",
      "time": "08:00 AM", // Initial time added
      "icon": Icons.medical_services
    },
    {
      "value": "125 mg/dL",
      "date": "20 Nov 2024",
      "time": "06:30 PM",
      "icon": Icons.fastfood
    },
  ];

  int _selectedValue = 120; // Default selected glucose value

  void _addNewValue() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              Color.fromARGB(255, 227, 223, 223), // Custom box color
          title: Text("Add New Entry",
              style: TextStyle(color: Colors.black)), // Change text color
          content: SingleChildScrollView(
            // Prevent layout constraints
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Select Glucose Value",
                    style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(
                            255, 4, 3, 3))), // Change text color

                SizedBox(height: 16),
                NumberPicker(
                  selectedTextStyle: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 30), // Change selected number color
                  value: _selectedValue,
                  minValue: 70, // Minimum glucose level
                  maxValue: 300, // Maximum glucose level
                  step: 1,
                  itemHeight: 50,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value; // Update the selected value
                    });
                  },
                  textStyle: TextStyle(
                    fontSize: 30,
                    color: const Color.fromARGB(
                        255, 120, 125, 120), // Color of unselected numbers
                  ),
                ),
                Text("Selected: $_selectedValue mg/dL",
                    style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(
                            255, 0, 0, 0))), // Change text color
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel",
                  style: TextStyle(
                      color: const Color.fromARGB(
                          255, 5, 0, 0))), // Change text color
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Get the current date and time
                  final currentDate = DateTime.now();
                  final formattedDate =
                      "${currentDate.day} ${_monthName(currentDate.month)} ${currentDate.year}";
                  final formattedTime =
                      "${currentDate.hour}:${currentDate.minute.toString().padLeft(2, '0')} ${currentDate.hour >= 12 ? 'PM' : 'AM'}";

                  // Add new data to the timeline
                  timelineData.add({
                    "value": "$_selectedValue mg/dL",
                    "date": formattedDate,
                    "time": formattedTime,
                    "icon": Icons.add_chart,
                  });
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 248, 245, 245),
                backgroundColor: Color.fromARGB(255, 40, 185, 57), // Text color
                padding: EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12), // Padding (optional)
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12), // Rounded corners (optional)
                ),
              ),
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  String _monthName(int month) {
    // Helper function to convert month number to name
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
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back icon
          onPressed: () {
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
          // Current and Target Section
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
          // Graph Section
          Container(
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: LineChart(
              LineChartData(
                minY: 70, // Set the minimum value for the y-axis
                maxY: 140,
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    axisNameWidget:
                        Container(), // Disable top titles to remove numbers above
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 1:
                            return Text('21 Feb');
                          case 2:
                            return Text('28 May');
                          case 3:
                            return Text('16 Jul');
                          case 4:
                            return Text('19 Aug');
                          case 5:
                            return Text('24 Aug');
                          case 6:
                            return Text('25 Nov');
                          default:
                            return Text('');
                        }
                      },
                      reservedSize: 32,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      reservedSize: 40,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles:
                            false), // Disable right titles if not needed
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    top: BorderSide(
                        color: Colors.transparent, width: 0), // Hide top border
                    right: BorderSide(
                        color: Colors.transparent,
                        width: 0), // Hide right border
                    left: BorderSide(
                        color: Colors.black,
                        width: 1), // Keep left border visible
                    bottom: BorderSide(
                        color: Colors.black,
                        width: 1), // Keep bottom border visible
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(1, 120),
                      FlSpot(2, 95),
                      FlSpot(3, 106),
                      FlSpot(4, 120),
                      FlSpot(5, 121),
                      FlSpot(6, 135),
                    ],
                    isCurved: true,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
          // Timeline Section
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: timelineData.length,
              itemBuilder: (context, index) {
                final item = timelineData[index];
                return TimelineTile(
                  value: item["value"],
                  date: item["date"],
                  time: item["time"], // Pass time
                  icon: item["icon"],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewValue,
        child: Icon(Icons.add),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromARGB(255, 15, 177, 15),
      ),
    );
  }
}

// Timeline Tile Widget
class TimelineTile extends StatelessWidget {
  final String value;
  final String date;
  final String time; // Add time field
  final IconData icon;

  const TimelineTile(
      {required this.value,
      required this.date,
      required this.time,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Color.fromARGB(
          255, 240, 240, 240), // Custom background color for the card
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 78, 161, 84)),
        title: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$date at $time"), // Display date and time
      ),
    );
  }
}
