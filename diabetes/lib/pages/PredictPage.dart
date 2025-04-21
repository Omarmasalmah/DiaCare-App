import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PredictPage extends StatefulWidget {
  const PredictPage({Key? key}) : super(key: key);

  @override
  State<PredictPage> createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  // Base URL of your Flask server
  final String _baseUrl = 'http://10.0.2.2:5000';

  // Binary features as booleans
  bool irritability = false;
  bool alopecia = false;
  bool itching = false;
  bool muscleStiffness = false;
  bool polydipsia = false;
  bool weakness = false;
  bool polyphagia = false;
  bool delayedHealing = false;
  bool polyuria = false;
  bool visualBlurring = false;
  bool gender = false; // false => female, true => male
  bool suddenWeightLoss = false;
  bool partialParesis = false;

  // Age (numeric input)
  final TextEditingController ageController = TextEditingController();

  // Prediction results
  String _predictionResult = '';
  double _riskValue = 0.0; // 0..100

  /// Make POST request to your Flask /predict endpoint
  Future<void> _makePrediction() async {
    final String url = '$_baseUrl/predict';

    final Map<String, dynamic> requestData = {
      "irritability": irritability ? 1 : 0,
      "alopecia": alopecia ? 1 : 0,
      "itching": itching ? 1 : 0,
      "muscle_stiffness": muscleStiffness ? 1 : 0,
      "polydipsia": polydipsia ? 1 : 0,
      "weakness": weakness ? 1 : 0,
      "polyphagia": polyphagia ? 1 : 0,
      "delayed_healing": delayedHealing ? 1 : 0,
      "polyuria": polyuria ? 1 : 0,
      "visual_blurring": visualBlurring ? 1 : 0,
      "gender": gender ? 1 : 0,
      "sudden_weight_loss": suddenWeightLoss ? 1 : 0,
      "partial_paresis": partialParesis ? 1 : 0,
      "age": double.tryParse(ageController.text) ?? 0.0,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        // Convert [0..1] => [0..100]
        double prob = (jsonBody['risk_probability'] ?? 0.0).toDouble();
        double percentage = prob * 100.0;

        // Determine local “Low/Medium/High” label
        String localLabel;
        if (percentage < 33) {
          localLabel = 'Low';
        } else if (percentage < 66) {
          localLabel = 'Medium';
        } else {
          localLabel = 'High';
        }

        setState(() {
          _riskValue = percentage;
          _predictionResult = '$localLabel Risk';
        });
      } else {
        setState(() {
          _predictionResult = 'Server Error: ${response.statusCode}';
          _riskValue = 0.0;
        });
      }
    } catch (e) {
      setState(() {
        _predictionResult = 'Error: $e';
        _riskValue = 0.0;
      });
    }
  }

  /// Clears all fields and resets the UI
  void _clearFields() {
    setState(() {
      // Reset booleans
      irritability = false;
      alopecia = false;
      itching = false;
      muscleStiffness = false;
      polydipsia = false;
      weakness = false;
      polyphagia = false;
      delayedHealing = false;
      polyuria = false;
      visualBlurring = false;
      gender = false;
      suddenWeightLoss = false;
      partialParesis = false;

      // Clear age
      ageController.clear();

      // Reset gauge and label
      _riskValue = 0.0;
      _predictionResult = '';
    });
  }

  /// A helper to build a single Switch question in a card-like style
  Widget _buildSwitchQuestion({
    required String question,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: SwitchListTile(
        title: Text(question),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Diabetes Prediction'),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Age input in a card
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 3)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Please enter your age:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 3)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select your gender:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            gender = true; // Male selected
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              gender ? Colors.deepPurple : Colors.grey.shade300,
                          foregroundColor: gender ? Colors.white : Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Male'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            gender = false; // Female selected
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !gender
                              ? Colors.deepPurple
                              : Colors.grey.shade300,
                          foregroundColor:
                              !gender ? Colors.white : Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Female'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Switch-based questions
            _buildSwitchQuestion(
              question: 'Have you experienced sudden weight loss?',
              value: suddenWeightLoss,
              onChanged: (val) => setState(() => suddenWeightLoss = val),
            ),
            _buildSwitchQuestion(
              question: 'Are you experiencing irritability?',
              value: irritability,
              onChanged: (val) => setState(() => irritability = val),
            ),
            _buildSwitchQuestion(
              question: 'Do you have alopecia (hair loss)?',
              value: alopecia,
              onChanged: (val) => setState(() => alopecia = val),
            ),
            _buildSwitchQuestion(
              question: 'Are you experiencing itching?',
              value: itching,
              onChanged: (val) => setState(() => itching = val),
            ),
            _buildSwitchQuestion(
              question: 'Do you have muscle stiffness?',
              value: muscleStiffness,
              onChanged: (val) => setState(() => muscleStiffness = val),
            ),
            _buildSwitchQuestion(
              question: 'Have you noticed polydipsia (increased thirst)?',
              value: polydipsia,
              onChanged: (val) => setState(() => polydipsia = val),
            ),
            _buildSwitchQuestion(
              question: 'Do you feel weakness?',
              value: weakness,
              onChanged: (val) => setState(() => weakness = val),
            ),
            _buildSwitchQuestion(
              question: 'Are you experiencing polyphagia (increased hunger)?',
              value: polyphagia,
              onChanged: (val) => setState(() => polyphagia = val),
            ),
            _buildSwitchQuestion(
              question: 'Are your wounds delayed in healing?',
              value: delayedHealing,
              onChanged: (val) => setState(() => delayedHealing = val),
            ),
            _buildSwitchQuestion(
              question: 'Do you have polyuria (frequent urination)?',
              value: polyuria,
              onChanged: (val) => setState(() => polyuria = val),
            ),
            _buildSwitchQuestion(
              question: 'Are you experiencing visual blurring?',
              value: visualBlurring,
              onChanged: (val) => setState(() => visualBlurring = val),
            ),

            _buildSwitchQuestion(
              question: 'Do you have partial paresis (muscle weakness)?',
              value: partialParesis,
              onChanged: (val) => setState(() => partialParesis = val),
            ),

            const SizedBox(height: 20),

            // Row for "Predict" and "Clear" buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _makePrediction,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Predict',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _clearFields,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Clear',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            // Gauge and result
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 3)
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Risk Percentage',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 100,
                        ranges: <GaugeRange>[
                          GaugeRange(
                              startValue: 0, endValue: 33, color: Colors.green),
                          GaugeRange(
                              startValue: 33,
                              endValue: 66,
                              color: Colors.orange),
                          GaugeRange(
                              startValue: 66, endValue: 100, color: Colors.red),
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(value: _riskValue),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            widget: Text(
                              '${_riskValue.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            angle: 90,
                            positionFactor: 0.75,
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Diagnosis: $_predictionResult',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
