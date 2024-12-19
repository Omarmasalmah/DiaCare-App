import 'package:flutter/material.dart';

class DosageInstructionsPage extends StatelessWidget {
  const DosageInstructionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dosage Instructions'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Understand Your Insulin Types
            const Text(
              '1. Understand Your Insulin Types',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '- Basal Insulin (Long-Acting): Used to maintain consistent blood sugar levels throughout the day and night. Examples include Lantus, Toujeo, and Levemir. This insulin works slowly over many hours and is usually taken once or twice daily.',
            ),
            const Text(
              '- Bolus Insulin (Short- or Rapid-Acting): Used to control blood sugar spikes after meals. Examples include Humalog, NovoRapid, and Apidra. Typically taken 15–30 minutes before eating, it acts quickly and is essential for managing post-meal blood sugar levels.',
            ),
            const SizedBox(height: 20),

            // Section 2: Timing
            const Text(
              '2. Timing of Insulin Doses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '- Long-Acting Insulin: Take it at the same time every day to ensure continuous blood sugar control. For example, schedule it in the morning or at bedtime. Consistency is key to prevent fluctuations.',
            ),
            const Text(
              '- Rapid-Acting Insulin: Administer 15–30 minutes before meals to align with your food’s digestion process. For those using insulin pumps, this can also be adjusted based on your meal size and timing.',
            ),
            const SizedBox(height: 20),

            // Section 3: Dosage Calculation
            const Text(
              '3. Dosage Calculation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '- Carb-to-Insulin Ratio (CIR): This determines how much insulin you need to cover the carbohydrates in your meal. For example, if your ratio is 1:10, you need 1 unit of insulin for every 10 grams of carbs.',
            ),
            const Text(
              '- Correction Factor (CF): Also called Insulin Sensitivity Factor (ISF), this helps correct high blood sugar levels. For instance, if your correction factor is 1:50, it means 1 unit of insulin will lower your blood sugar by 50 mg/dL.',
            ),
            const Text(
              '- Always consult your healthcare provider to determine personalized CIR and CF values based on your needs.',
            ),
            const SizedBox(height: 20),

            // Section 4: Injection Instructions
            const Text(
              '4. Injection Instructions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '- Choose an injection site, such as the abdomen (best for rapid absorption), thighs, buttocks, or upper arms. Rotate the injection site regularly to avoid lipohypertrophy (lumps or fat deposits).',
            ),
            const Text(
              '- Clean the site with an alcohol swab and ensure the skin is dry before injecting.',
            ),
            const Text(
              '- Insert the needle at a 90° angle for most areas. For thinner areas like the arm, a 45° angle might be used.',
            ),
            const Text(
              '- Inject the insulin slowly and steadily, then count to 10 before removing the needle to ensure full delivery. Safely dispose of the needle in a sharps container.',
            ),
            const SizedBox(height: 20),

            // Section 5: Monitor Blood Sugar
            const Text(
              '5. Monitor Blood Sugar Levels',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '- Check your blood sugar levels regularly, including before meals, two hours after meals, and before bedtime.',
            ),
            const Text(
              '- Use a Continuous Glucose Monitor (CGM) if available, as it provides real-time readings and trends. This helps to adjust insulin doses as needed.',
            ),
            const Text(
              '- Keep a log of your readings to share with your healthcare provider for better management of your diabetes.',
            ),
            const SizedBox(height: 20),

            // Section 6: Manage Hypoglycemia
            const Text(
              '6. Manage Hypoglycemia (Low Blood Sugar)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '- Symptoms: Feeling shaky, dizzy, hungry, sweaty, or experiencing a rapid heartbeat. Severe cases might lead to confusion or unconsciousness.',
            ),
            const Text(
              '- Treatment: Consume 15–20 grams of fast-acting carbs, such as glucose tablets, fruit juice, or regular soda. Recheck your blood sugar after 15 minutes and repeat treatment if needed.',
            ),
            const Text(
              '- Always carry glucose tablets or a sugary snack, especially during physical activities or long trips.',
            ),
            const SizedBox(height: 20),

            // Section 7: Emergency Guidelines
            const Text(
              '7. Emergency Guidelines',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '- Severe Hypoglycemia: If the person is unconscious or unable to swallow, administer glucagon if available and seek immediate medical attention.',
            ),
            const Text(
              '- Diabetic Ketoacidosis (DKA): Symptoms include extreme thirst, frequent urination, nausea, vomiting, and abdominal pain. Seek emergency care immediately as DKA can be life-threatening.',
            ),
            const SizedBox(height: 20),

            // Section 8: Lifestyle Recommendations
            const Text(
              '8. Lifestyle Recommendations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '- Maintain a balanced diet with consistent meal times to avoid drastic blood sugar fluctuations.',
            ),
            const Text(
              '- Stay active, as exercise improves insulin sensitivity. However, monitor your blood sugar before and after exercise to prevent hypoglycemia.',
            ),
            const Text(
              '- Keep stress levels under control, as stress can affect blood sugar levels. Techniques like yoga, meditation, or deep breathing can help.',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
