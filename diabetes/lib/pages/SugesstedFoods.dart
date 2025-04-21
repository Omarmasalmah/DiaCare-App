import 'package:flutter/material.dart';

class HealthyMealsPage extends StatelessWidget {
  const HealthyMealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Healthy Meal Choices for Diabetes',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Recommended Meals for Diabetes Patients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FractionColumnWidth(0.25),
                  1: FractionColumnWidth(0.75),
                },
                children: [
                  _buildTableRow('Meal Type', 'Healthy Choices',
                      isHeader: true),
                  _buildTableRow('Breakfast',
                      'Oatmeal, Greek Yogurt, Boiled Eggs, Whole Grain Toast, Avocado, Berries'),
                  _buildTableRow('Lunch',
                      'Grilled Chicken Salad, Quinoa, Steamed Vegetables, Lentil Soup, Whole Wheat Wrap'),
                  _buildTableRow('Dinner',
                      'Baked Salmon, Brown Rice, Steamed Broccoli, Stir-fried Tofu, Vegetable Soup'),
                  _buildTableRow('Snacks',
                      'Nuts, Dark Chocolate, Apple Slices with Peanut Butter, Cottage Cheese, Hummus & Carrots'),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Hydrating Drinks for Diabetes Patients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FractionColumnWidth(0.3),
                  1: FractionColumnWidth(0.7),
                },
                children: [
                  _buildTableRow('Drink', 'Benefits', isHeader: true),
                  _buildTableRow('Water',
                      'Best for hydration, helps regulate blood sugar'),
                  _buildTableRow('Herbal Tea',
                      'Supports digestion and reduces inflammation'),
                  _buildTableRow('Green Tea',
                      'Rich in antioxidants, helps insulin sensitivity'),
                  _buildTableRow('Low-fat Milk',
                      'Provides calcium and protein, avoids excess sugar'),
                  _buildTableRow('Unsweetened Almond Milk',
                      'Low in carbs, good alternative to dairy'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String mealType, String details,
      {bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.teal : Colors.white,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            mealType,
            style: TextStyle(
              fontSize: isHeader ? 16 : 14,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            details,
            style: TextStyle(
              fontSize: isHeader ? 16 : 14,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
