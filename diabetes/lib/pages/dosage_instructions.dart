import 'package:flutter/material.dart';

class DosageInstructionsPage extends StatelessWidget {
  const DosageInstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dosage Instructions',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // White back button
          onPressed: () {
            Navigator.of(context).pop(); // Handle back navigation
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE8F5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                context,
                icon: Icons.info_outline,
                title: 'Understand Your Insulin Types',
                content: [
                  '- Basal Insulin (Long-Acting): Used to maintain consistent blood sugar levels throughout the day and night. Examples include Lantus, Toujeo, and Levemir.',
                  '- Bolus Insulin (Short- or Rapid-Acting): Used to control blood sugar spikes after meals. Examples include Humalog, NovoRapid, and Apidra.',
                ],
              ),
              _buildSection(
                context,
                icon: Icons.access_time,
                title: 'Timing of Insulin Doses',
                content: [
                  '- Long-Acting Insulin: Take it at the same time every day to ensure continuous blood sugar control.',
                  '- Rapid-Acting Insulin: Administer 15–30 minutes before meals to align with your food’s digestion process.',
                ],
              ),
              _buildSection(
                context,
                icon: Icons.calculate,
                title: 'Dosage Calculation',
                content: [
                  '- Carb-to-Insulin Ratio (CIR): Determines how much insulin you need to cover the carbohydrates in your meal.',
                  '- Correction Factor (CF): Helps correct high blood sugar levels.',
                  '- Always consult your healthcare provider for personalized CIR and CF values.',
                ],
              ),
              _buildSection(
                context,
                icon: Icons.medical_services,
                title: 'Injection Instructions',
                content: [
                  '- Choose an injection site, such as the abdomen, thighs, buttocks, or upper arms.',
                  '- Clean the site with an alcohol swab and ensure it is dry before injecting.',
                  '- Insert the needle at a 90° angle (or 45° for thinner areas).',
                ],
              ),
              _buildSection(
                context,
                icon: Icons.monitor,
                title: 'Monitor Blood Sugar Levels',
                content: [
                  '- Check your blood sugar levels regularly, including before meals and bedtime.',
                  '- Use a Continuous Glucose Monitor (CGM) if available.',
                  '- Keep a log of your readings to share with your healthcare provider.',
                ],
              ),
              _buildSection(
                context,
                icon: Icons.warning,
                title: 'Manage Hypoglycemia',
                content: [
                  '- Symptoms: Feeling shaky, dizzy, or experiencing a rapid heartbeat.',
                  '- Treatment: Consume 15–20 grams of fast-acting carbs and recheck your blood sugar after 15 minutes.',
                  '- Always carry glucose tablets or a sugary snack.',
                ],
              ),
              _buildSection(
                context,
                icon: Icons.emergency,
                title: 'Emergency Guidelines',
                content: [
                  '- Severe Hypoglycemia: Administer glucagon and seek medical attention if unconscious.',
                  '- Diabetic Ketoacidosis (DKA): Symptoms include extreme thirst, nausea, and vomiting. Seek emergency care immediately.',
                ],
              ),
              _buildSection(
                context,
                icon: Icons.health_and_safety,
                title: 'Lifestyle Recommendations',
                content: [
                  '- Maintain a balanced diet with consistent meal times.',
                  '- Stay active, but monitor your blood sugar before and after exercise.',
                  '- Practice stress management techniques like yoga or meditation.',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required IconData icon,
      required String title,
      required List<String> content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.teal, size: 28),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...content.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              )),
        ],
      ),
    );
  }
}
