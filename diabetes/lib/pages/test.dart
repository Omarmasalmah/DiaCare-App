import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class BloodPressurePage extends StatefulWidget {
  @override
  _BloodPressurePageState createState() => _BloodPressurePageState();
}

class _BloodPressurePageState extends State<BloodPressurePage> {
  int _systolicValue = 120;
  int _diastolicValue = 80;
  int _pulseValue = 70;
  String _selectedMedication = "None";

  final List<String> medications = ["None", "Aspirin", "Beta Blocker", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Blood Pressure", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Systolic and Diastolic Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Systolic Picker
                  Text(
                    "Systolic (mmHg)",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: NumberPicker(
                      value: _systolicValue,
                      minValue: 90,
                      maxValue: 200,
                      step: 1,
                      itemHeight: 50,
                      axis: Axis.vertical,
                      textStyle: TextStyle(color: Colors.grey),
                      selectedTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _systolicValue = value;
                        });
                      },
                    ),
                  ),
                  Divider(color: Colors.grey),
                  // Diastolic Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Diastolic (mmHg)",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        "$_diastolicValue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Pulse and Medication Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pulse Row
                  Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Pulse",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "$_pulseValue",
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _pulseValue = int.tryParse(value) ?? _pulseValue;
                            });
                          },
                        ),
                      ),
                      Text(
                        " bpm",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),

                  // Medication Dropdown Row
                  Row(
                    children: [
                      Icon(Icons.medication, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Medication",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Spacer(),
                      DropdownButton<String>(
                        dropdownColor: Colors.grey[900],
                        value: _selectedMedication,
                        style: TextStyle(color: Colors.white),
                        items: medications.map((String medication) {
                          return DropdownMenuItem<String>(
                            value: medication,
                            child: Text(medication),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMedication = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Notes Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.notes, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Notes",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
