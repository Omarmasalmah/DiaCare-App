import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insulin Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const InsulinCalculatorScreen(),
    );
  }
}

class InsulinCalculatorScreen extends StatefulWidget {
  const InsulinCalculatorScreen({super.key});

  @override
  State<InsulinCalculatorScreen> createState() =>
      _InsulinCalculatorScreenState();
}

class _InsulinCalculatorScreenState extends State<InsulinCalculatorScreen> {
  String searchQuery = ''; // To store the search input
  List<Map<String, String>> filteredCategories =
      []; // To store filtered categories
  final List<Map<String, String>> categories = [
    {'label': 'Cold Drinks', 'image': 'assets/images/cold_drinks.jpg'},
    {'label': 'Hot Drinks', 'image': 'assets/images/hot_drinks.jpg'},
    {'label': 'Breakfast', 'image': 'assets/images/breakfast.jpg'},
    {'label': 'Breads', 'image': 'assets/images/breads.png'},
    {'label': 'Lunch', 'image': 'assets/images/lunch.jpg'},
    {'label': 'Sweets and Snacks', 'image': 'assets/images/candies.jpg'},
    {'label': 'Soups', 'image': 'assets/images/soups.jpg'},
    {'label': 'Salads and Appetizers', 'image': 'assets/images/salad.jpg'},
    {'label': 'Dairy Products', 'image': 'assets/images/dairy.jpg'},
    {'label': 'Fruits and Vegetables', 'image': 'assets/images/fruits.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    filteredCategories = categories; // Initially show all categories
  }

  final List<Map<String, dynamic>> foodItems = [
    // *********************************************************************************Fruits and Vegetables
// ****************************************************************************************Fruits and Vegetables
    {
      'name': 'Pineapple',
      'size': '1 cup (165 g)',
      'carbs': 12,
      'calories': 82,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/ananas.jpg'
    },
    {
      'name': 'Apple',
      'size': '1 medium (182 g)',
      'carbs': 14,
      'calories': 95,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/apple.jpg'
    },
    {
      'name': 'Avocado',
      'size': '1/2 medium (70 g)',
      'carbs': 8,
      'calories': 114,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/Avo.jpg'
    },
    {
      'name': 'Banana',
      'size': '1 medium (118 g)',
      'carbs': 27,
      'calories': 105,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/Banana.jpg'
    },
    {
      'name': 'Pomelo',
      'size': '1 cup (145 g)',
      'carbs': 10,
      'calories': 72,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/bomaleh.jpg'
    },
    {
      'name': 'Corn',
      'size': '1 cup (154 g)',
      'carbs': 21,
      'calories': 132,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/corn.jpg'
    },
    {
      'name': 'Pear',
      'size': '1 medium (178 g)',
      'carbs': 15,
      'calories': 101,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/egas.jpg'
    },
    {
      'name': 'Strawberry',
      'size': '1 cup (152 g)',
      'carbs': 8,
      'calories': 49,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/farawleh.jpg'
    },
    {
      'name': 'Bell Pepper',
      'size': '1 medium (120 g)',
      'carbs': 4,
      'calories': 25,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/foleflah.jpg'
    },
    {
      'name': 'Carrot',
      'size': '1 medium (61 g)',
      'carbs': 10,
      'calories': 25,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/jazara.jpg'
    },
    {
      'name': 'Persimmon',
      'size': '1 medium (168 g)',
      'carbs': 18,
      'calories': 118,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/kaka.jpg'
    },
    {
      'name': 'Clementine',
      'size': '1 medium (74 g)',
      'carbs': 12,
      'calories': 35,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/kalamntenah.jpg'
    },
    {
      'name': 'Cherries',
      'size': '1 cup (154 g)',
      'carbs': 13,
      'calories': 87,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/karaz.jpg'
    },
    {
      'name': 'Chestnut',
      'size': '10 kernels (84 g)',
      'carbs': 24,
      'calories': 170,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/kastanah.jpg'
    },
    {
      'name': 'Kiwi',
      'size': '1 medium (69 g)',
      'carbs': 15,
      'calories': 42,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/kewe.jpg'
    },
    {
      'name': 'Cucumber',
      'size': '1 medium (120 g)',
      'carbs': 3,
      'calories': 16,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/khear.jpg'
    },
    {
      'name': 'Plum',
      'size': '1 medium (66 g)',
      'carbs': 11,
      'calories': 30,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/khokh.jpg'
    },
    {
      'name': 'Mango',
      'size': '1 cup (165 g)',
      'carbs': 23,
      'calories': 99,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/manga.jpg'
    },
    {
      'name': 'Watermelon',
      'size': '1 cup (152 g)',
      'carbs': 8,
      'calories': 46,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/melon.jpg'
    },
    {
      'name': 'Apricot',
      'size': '3 small (70 g)',
      'carbs': 3,
      'calories': 17,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/mshmsh.jpg'
    },
    {
      'name': 'Orange',
      'size': '1 medium (131 g)',
      'carbs': 15,
      'calories': 62,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/Orange.jpg'
    },
    {
      'name': 'Pomegranate',
      'size': '1/2 cup (87 g)',
      'carbs': 19,
      'calories': 72,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/Roman.jpg'
    },
    {
      'name': 'Cantaloupe',
      'size': '1 cup (156 g)',
      'carbs': 7,
      'calories': 54,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/shemam.jpg'
    },
    {
      'name': 'Sweet Potato',
      'size': '1 medium (130 g)',
      'carbs': 24,
      'calories': 112,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/sweetpotatp.jpg'
    },
    {
      'name': 'Dates',
      'size': '1 piece',
      'carbs': 25,
      'calories': 30,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/tamer.jpg'
    },
    {
      'name': 'Medjool Dates',
      'size': '1 piece',
      'carbs': 33,
      'calories': 55,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/Medjool_Dates.jpg'
    },
    {
      'name': 'Tomato',
      'size': '1 medium (123 g)',
      'carbs': 4,
      'calories': 22,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/tomato.jpg'
    },
    {
      'name': 'Blackberry',
      'size': '1 cup (144 g)',
      'carbs': 10,
      'calories': 62,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/tot.jpg'
    },
    {
      'name': 'Grapefruit',
      'size': '1/2 medium (123 g)',
      'carbs': 8,
      'calories': 52,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/grepfrout.jpg'
    },
    {
      'name': 'Guava',
      'size': '1 medium (55 g)',
      'carbs': 5,
      'calories': 38,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/jawafeh.jpg'
    },
    {
      'name': 'Grape',
      'size': '1 cup (151 g)',
      'carbs': 16,
      'calories': 104,
      'category': 'Fruits and Vegetables',
      'image': 'assets/images/FruitsandVegetables/grape.jpg'
    },

    // Natural Juices  // Natural Juices
    // Natural Juices
    {
      'name': 'Natural Apple Juice',
      'size': '250 ml',
      'carbs': 27,
      'calories': 110,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/natural_apple_juice.jpg',
    },
    {
      'name': 'Natural Strawberry Juice',
      'size': '250 ml',
      'carbs': 22,
      'calories': 100,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/natural_farawlah_juice.jpg',
    },
    {
      'name': 'Natural Watermelon Juice',
      'size': '250 ml',
      'carbs': 18,
      'calories': 70,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/natural_batekh_juice.jpg',
    },
    {
      'name': 'Natural Pomegranate Juice',
      'size': '250 ml',
      'carbs': 24,
      'calories': 100,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/natural_roman_juice.jpg',
    },
    {
      'name': 'Natural Mango Juice',
      'size': '250 ml',
      'carbs': 30,
      'calories': 120,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/natural_manga_juice.jpg',
    },
    {
      'name': 'Natural Orange Juice',
      'size': '250 ml',
      'carbs': 25,
      'calories': 95,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/natural_orange_juice.jpg',
    },

// Processed Juices
    {
      'name': 'Cappy Apple',
      'size': '330 ml',
      'carbs': 25,
      'calories': 110,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/cappyapple330.jpg',
    },
    {
      'name': 'Cappy Strawberry and Banana',
      'size': '330 ml',
      'carbs': 28,
      'calories': 120,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/cappy-farawlhmozz330.jpg',
    },
    {
      'name': 'Cappy Grapes',
      'size': '330 ml',
      'carbs': 26,
      'calories': 115,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/cappygrapes330.jpg',
    },
    {
      'name': 'Cappy Grapefruit',
      'size': '330 ml',
      'carbs': 20,
      'calories': 85,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/cappy-grepfrot.jpg',
    },
    {
      'name': 'Cappy Cherry',
      'size': '330 ml',
      'carbs': 30,
      'calories': 125,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/cappy-karraz330.jpg',
    },
    {
      'name': 'Cappy Patience and kiwi',
      'size': '330 ml',
      'carbs': 22,
      'calories': 90,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/cappy-koktel330.jpg',
    },
    {
      'name': 'Cappy Lemon',
      'size': '330 ml',
      'carbs': 18,
      'calories': 75,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/cappy-lemon330.jpg',
    },
    {
      'name': 'Cappy Mango',
      'size': '330 ml',
      'carbs': 30,
      'calories': 120,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/cappy-mango330.jpg',
    },
    {
      'name': 'Cappy Orange',
      'size': '330 ml',
      'carbs': 22,
      'calories': 88,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/cappy-orange330.jpg',
    },
    {
      'name': 'Cappy Tamarind',
      'size': '330 ml',
      'carbs': 28,
      'calories': 120,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/cappy-tamer330.jpg',
    },
    {
      'name': 'Berry Juice',
      'size': '330 ml',
      'carbs': 28,
      'calories': 112,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/tot_juice330.jpg',
    },

// Soft Drinks
    {
      'name': '7Up 250ml',
      'size': '250 ml',
      'carbs': 10,
      'calories': 40,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/7up250.png',
    },
    {
      'name': '7Up 330ml',
      'size': '330 ml',
      'carbs': 12,
      'calories': 50,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/7up330.jpg',
    },
    {
      'name': 'Coca-Cola 250ml',
      'size': '250 ml',
      'carbs': 27,
      'calories': 108,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/cola250.png',
    },
    {
      'name': 'Coca-Cola 330ml',
      'size': '330 ml',
      'carbs': 36,
      'calories': 144,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/cola330.jpg',
    },
    {
      'name': 'Fanta Grape',
      'size': '330 ml',
      'carbs': 34,
      'calories': 136,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/Fanta grape can final_2.jpg',
    },
    {
      'name': 'Fanta Apple 250ml',
      'size': '250 ml',
      'carbs': 26,
      'calories': 104,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/fanta_apple250.png',
    },
    {
      'name': 'Fanta Apple 330ml',
      'size': '330 ml',
      'carbs': 32,
      'calories': 128,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/fanta_apple330.png',
    },
    {
      'name': 'Fanta Strawberry 250ml',
      'size': '250 ml',
      'carbs': 30,
      'calories': 120,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/fanta_farawlah250.png',
    },
    {
      'name': 'Fanta Strawberry 330ml',
      'size': '330 ml',
      'carbs': 36,
      'calories': 144,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/fanta_farawlah330.png',
    },
    {
      'name': 'Fanta Orange 250ml',
      'size': '250 ml',
      'carbs': 28,
      'calories': 112,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/fanta250.png',
    },
    {
      'name': 'Fanta Orange 330ml',
      'size': '330 ml',
      'carbs': 34,
      'calories': 136,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/fanta330.png',
    },

    {
      'name': 'Fanta As',
      'size': '250 ml',
      'carbs': 30,
      'calories': 120, // Estimated
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/fanta-as.jpg',
    },
    {
      'name': 'Fanta Cherry 330ml',
      'size': '330 ml',
      'carbs': 36,
      'calories': 144, // Estimated
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/fanta-karaz330.jpg',
    },

// Energy Drinks
    {
      'name': 'RedBull',
      'size': '250 ml',
      'carbs': 27,
      'calories': 108,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/redbull.png',
    },
    {
      'name': 'XL Energy',
      'size': '250 ml',
      'carbs': 30,
      'calories': 120,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/xl.png',
    },

// Other Drinks

    {
      'name': 'Natural Cocktail',
      'size': '330 ml',
      'carbs': 25,
      'calories': 100,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/Kok.jpg',
    },
// ****************************************************************************************Cold Drinks - Milkshakes
    {
      'name': 'Chocolate Milkshake',
      'size': '330 ml',
      'carbs': 42,
      'calories': 250,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/chocolate_milkshake.jpg',
    },
    {
      'name': 'Lotus Milkshake',
      'size': '330 ml',
      'carbs': 40,
      'calories': 230,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/Lotus_Milkshake.jpg',
    },
    {
      'name': 'Vanilla Milkshake',
      'size': '330 ml',
      'carbs': 38,
      'calories': 230,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/vanilla_milkshake.jpg',
    },
    {
      'name': 'Strawberry Milkshake',
      'size': '330 ml',
      'carbs': 40,
      'calories': 240,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/strawberry_milkshake.jpg',
    },
    {
      'name': 'Banana Milkshake',
      'size': '330 ml',
      'carbs': 44,
      'calories': 260,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/banana_milkshake.jpg',
    },
    {
      'name': 'Mango Milkshake',
      'size': '330 ml',
      'carbs': 45,
      'calories': 270,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/mango_milkshake.jpg',
    },
    {
      'name': 'Oreo Milkshake',
      'size': '330 ml',
      'carbs': 48,
      'calories': 290,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/oreo_milkshake.jpg',
    },
    {
      'name': 'Caramel Milkshake',
      'size': '330 ml',
      'carbs': 50,
      'calories': 300,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/caramel_milkshake.jpg',
    },
    {
      'name': 'Coffee Milkshake',
      'size': '330 ml',
      'carbs': 30,
      'calories': 200,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/coffee_milkshake.jpg',
    },
    {
      'name': 'Nutella Milkshake',
      'size': '330 ml',
      'carbs': 46,
      'calories': 310,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/nutella_milkshake.jpg',
    },
    {
      'name': 'Snickers Milkshake',
      'size': '330 ml',
      'carbs': 52,
      'calories': 320,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/snickers_milkshake.jpg',
    },
    {
      'name': 'Mars Milkshake',
      'size': '330 ml',
      'carbs': 50,
      'calories': 310,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/mars_milkshake.jpg',
    },
    {
      'name': 'Kinder Milkshake',
      'size': '330 ml',
      'carbs': 45,
      'calories': 280,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/kinder_milkshake.jpg',
    },
    {
      'name': 'Twix Milkshake',
      'size': '330 ml',
      'carbs': 50,
      'calories': 300,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/twix_milkshake.jpg',
    },
    {
      'name': 'KitKat Milkshake',
      'size': '330 ml',
      'carbs': 48,
      'calories': 290,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/kitkat_milkshake.jpg',
    },
    {
      'name': 'Bounty Milkshake',
      'size': '330 ml',
      'carbs': 42,
      'calories': 280,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/bounty_milkshake.jpg',
    },
    {
      'name': 'Ferrero Rocher Milkshake',
      'size': '330 ml',
      'carbs': 55,
      'calories': 340,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/ferrero_milkshake.jpg',
    },
    {
      'name': 'Maltesers Milkshake',
      'size': '330 ml',
      'carbs': 47,
      'calories': 295,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/maltesers_milkshake.jpg',
    },
    {
      'name': 'Lotus Milkshake',
      'size': '330 ml',
      'carbs': 49,
      'calories': 320,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/lotus_milkshake.jpg',
    },
    {
      'name': 'Raspberry Milkshake',
      'size': '330 ml',
      'carbs': 35,
      'calories': 230,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/raspberry_milkshake.jpg',
    },

    {
      'name': 'Iced Caramel Macchiato',
      'size': '16 oz (473 ml)',
      'carbs': 35,
      'calories': 250,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/iced_caramel_macchiato.jpg',
    },
    {
      'name': 'Iced Vanilla Latte',
      'size': '16 oz (473 ml)',
      'carbs': 33,
      'calories': 240,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/iced_vanilla_latte.jpg',
    },
    {
      'name': 'Iced White Chocolate Mocha',
      'size': '16 oz (473 ml)',
      'carbs': 55,
      'calories': 370,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/iced_white_mocha.jpg',
    },
    {
      'name': 'Iced Mocha',
      'size': '16 oz (473 ml)',
      'carbs': 45,
      'calories': 320,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/iced_mocha.jpg',
    },
    {
      'name': 'Iced Americano',
      'size': '16 oz (473 ml)',
      'carbs': 2,
      'calories': 15,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/iced_americano.jpg',
    },
    {
      'name': 'Cold Brew Coffee',
      'size': '16 oz (473 ml)',
      'carbs': 3,
      'calories': 20,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/cold_brew.jpg',
    },
    {
      'name': 'Iced Cappuccino',
      'size': '16 oz (473 ml)',
      'carbs': 18,
      'calories': 120,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/iced_cappuccino.jpg',
    },
    {
      'name': 'Iced Matcha Latte',
      'size': '16 oz (473 ml)',
      'carbs': 29,
      'calories': 240,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/iced_matcha_latte.jpg',
    },
    {
      'name': 'Iced Chai Latte',
      'size': '16 oz (473 ml)',
      'carbs': 42,
      'calories': 280,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/iced_chai_latte.jpg',
    },
    {
      'name': 'Iced Flat White',
      'size': '12 oz (354 ml)',
      'carbs': 12,
      'calories': 150,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/iced_flat_white.png',
    },
    {
      'name': 'Mango Smoothie',
      'size': '16 oz (473 ml)',
      'carbs': 45,
      'calories': 220,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/mango_smoothie.jpg',
    },
    {
      'name': 'Mint Lemon Smoothie',
      'size': '16 oz (473 ml)',
      'carbs': 25,
      'calories': 150,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/mint_lemon_smoothie.jpg',
    },
    {
      'name': 'Blueberry Smoothie',
      'size': '16 oz (473 ml)',
      'carbs': 38,
      'calories': 190,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/blueberry_smoothie.jpg',
    },
    {
      'name': 'Mixed Berry Smoothie',
      'size': '16 oz (473 ml)',
      'carbs': 50,
      'calories': 210,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/mixed_berry_smoothie.jpg',
    },
    {
      'name': 'Strawberry Smoothie',
      'size': '16 oz (473 ml)',
      'carbs': 40,
      'calories': 180,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/strawberry_smoothie.jpg',
    },
    {
      'name': 'Pineapple Smoothie',
      'size': '16 oz (473 ml)',
      'carbs': 42,
      'calories': 200,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/pineapple_smoothie.jpg',
    },
    {
      'name': 'Kiwi Smoothie',
      'size': '16 oz (473 ml)',
      'carbs': 35,
      'calories': 170,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/kiwi_smoothie.jpg',
    },
    {
      'name': 'Raspberry Smoothie',
      'size': '16 oz (473 ml)',
      'carbs': 37,
      'calories': 180,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/raspberry_smoothie.jpg',
    },
    {
      'name': 'Coconut Smoothie',
      'size': '16 oz (473 ml)',
      'carbs': 30,
      'calories': 190,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/coconut_smoothie.jpg',
    },
    {
      'name': 'Banana Lemon Ginger Smoothie',
      'size': '16 oz (473 ml)',
      'carbs': 20,
      'calories': 100,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/lemon_ginger_smoothie.jpg',
    },
    {
      'name': 'Avocado Smoothie',
      'size': '16 oz (473 ml)',
      'carbs': 25,
      'calories': 240,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/avocado_smoothie.jpg',
    },
    {
      'name': 'Watermelon Smoothie',
      'size': '16 oz (473 ml)',
      'carbs': 30,
      'calories': 150,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/watermelon_smoothie.jpg',
    },
    {
      'name': 'Grape Smoothie',
      'size': '16 oz (473 ml)',
      'carbs': 48,
      'calories': 220,
      'category': 'Cold Drinks',
      'image': 'assets/images/ColdDrinks/grape_smoothie.jpg',
    },
/*/***///**/*/
/***********************
 * 
 * 
 * 
 */
// Hot Drinks
    {
      'name': 'Small Sugar Spoon',
      'size': '1 small spoon (4 g)',
      'carbs': 4,
      'calories': 16,
      'category': 'Hot Drinks',
      'image': 'assets/images/hotdrinks/small_sugar_spoon.jpg',
    },
    {
      'name': 'Large Sugar Spoon',
      'size': '1 large spoon (8 g)',
      'carbs': 8,
      'calories': 32,
      'category': 'Hot Drinks',
      'image': 'assets/images/hotdrinks/large_sugar_spoon.jpg',
    },

    {
      'name': 'Cappuccino',
      'size': '1 cup',
      'carbs': 12,
      'calories': 60, // Approximation without sugar
      'category': 'Hot Drinks',
      'image': 'assets/images/hotdrinks/cappuccino.jpg',
    },
    {
      'name': 'Coffee',
      'size': '1 cup',
      'carbs': 0,
      'calories': 5,
      'category': 'Hot Drinks',
      'image': 'assets/images/hotdrinks/coffee.jpg',
    },
    {
      'name': 'Green Tea',
      'size': '1 cup',
      'carbs': 0,
      'calories': 2,
      'category': 'Hot Drinks',
      'image': 'assets/images/hotdrinks/green_tea.jpg',
    },
    {
      'name': 'Karak Tea',
      'size': '1 cup',
      'carbs': 10,
      'calories': 90,
      'category': 'Hot Drinks',
      'image': 'assets/images/hotdrinks/Karak_tea.jpg',
    },

    {
      'name': 'Nescafe',
      'size': '1 cup',
      'carbs': 8,
      'calories': 50, // Without sugar
      'category': 'Hot Drinks',
      'image': 'assets/images/hotdrinks/nescafe.png',
    },
    {
      'name': 'Tea',
      'size': '1 cup',
      'carbs': 0,
      'calories': 5, // Without sugar
      'category': 'Hot Drinks',
      'image': 'assets/images/hotdrinks/tea.jpg',
    },
    {
      'name': 'Milk Tea',
      'size': '1 cup (330 ml)',
      'carbs': 10,
      'calories': 80, // Without sugar
      'category': 'Hot Drinks',
      'image': 'assets/images/hotdrinks/tea_milk.jpg',
    },
    {
      'name': 'Yanson',
      'size': '1 cup (330 ml)',
      'carbs': 0,
      'calories': 10, // Without sugar
      'category': 'Hot Drinks',
      'image': 'assets/images/hotdrinks/Yanson.jpg',
    },
    {
      'name': 'Zangabel',
      'size': '1 cup (330 ml)',
      'carbs': 0,
      'calories': 15, // Without sugar
      'category': 'Hot Drinks',
      'image': 'assets/images/hotdrinks/zangabel.jpg',
    },
    {
      'name': 'Sahlab',
      'size': '1 cup (250 ml)',
      'carbs': 40, // Approximate
      'calories': 200, // Approximate
      'category': 'Hot Drinks',
      'image': 'assets/images/HotDrinks/sahlab.jpg',
    },

// *********************************
//
//
//******************************************************* More Hot Drinks
    {
      'name': 'Hot Chocolate',
      'size': '330 ml',
      'carbs': 40,
      'calories': 250,
      'category': 'Hot Drinks',
      'image': 'assets/images/HotDrinks/hot_chocolate.jpg',
    },
    {
      'name': 'Hot Kinder',
      'size': '330 ml',
      'carbs': 45,
      'calories': 280,
      'category': 'Hot Drinks',
      'image': 'assets/images/HotDrinks/hot_kinder.jpg',
    },
    {
      'name': 'French Vanilla',
      'size': '330 ml',
      'carbs': 35,
      'calories': 200,
      'category': 'Hot Drinks',
      'image': 'assets/images/HotDrinks/french_vanilla.jpg',
    },
    {
      'name': 'Caramel Latte',
      'size': '330 ml',
      'carbs': 38,
      'calories': 240,
      'category': 'Hot Drinks',
      'image': 'assets/images/HotDrinks/caramel_latte.jpg',
    },
    {
      'name': 'Hazelnut Latte',
      'size': '330 ml',
      'carbs': 36,
      'calories': 230,
      'category': 'Hot Drinks',
      'image': 'assets/images/HotDrinks/hazelnut_latte.jpg',
    },
    {
      'name': 'White Chocolate Mocha',
      'size': '330 ml',
      'carbs': 50,
      'calories': 300,
      'category': 'Hot Drinks',
      'image': 'assets/images/HotDrinks/white_chocolate_mocha.jpg',
    },
    {
      'name': 'Cappuccino',
      'size': '330 ml',
      'carbs': 12,
      'calories': 80,
      'category': 'Hot Drinks',
      'image': 'assets/images/HotDrinks/cappuccino.jpg',
    },
    {
      'name': 'Espresso Macchiato',
      'size': '200 ml',
      'carbs': 5,
      'calories': 30,
      'category': 'Hot Drinks',
      'image': 'assets/images/HotDrinks/espresso_macchiato.jpg',
    },
    {
      'name': 'Chai Latte',
      'size': '330 ml',
      'carbs': 40,
      'calories': 220,
      'category': 'Hot Drinks',
      'image': 'assets/images/HotDrinks/chai_latte.jpg',
    },
    {
      'name': 'Hot Mocha',
      'size': '110 ml',
      'carbs': 17,
      'calories': 90,
      'category': 'Hot Drinks',
      'image': 'assets/images/HotDrinks/hot_mocha.jpg',
    },
    {
      'name': 'Hot Cinnamon Latte',
      'size': '330 ml',
      'carbs': 40,
      'calories': 220,
      'category': 'Hot Drinks',
      'image': 'assets/images/HotDrinks/hot_cinnamon_latte.jpg',
    },
    {
      'name': 'Hot Lotus',
      'size': '330 ml',
      'carbs': 50,
      'calories': 290,
      'category': 'Hot Drinks',
      'image': 'assets/images/HotDrinks/hot_lotus.jpg',
    },
/***
 * 
 * 
 * 
 */
// Soups
    {
      'name': 'Lentil Soup',
      'size': '1 cup (250 ml)',
      'carbs': 18,
      'calories': 190, // Estimated
      'category': 'Soups',
      'image': 'assets/images/Soups/adas.jpg',
    },
    {
      'name': 'Broccoli Soup',
      'size': '1 cup (250 ml)',
      'carbs': 12,
      'calories': 150, // Estimated
      'category': 'Soups',
      'image': 'assets/images/Soups/brokley.jpg',
    },
    {
      'name': 'Corn Soup',
      'size': '1 cup (250 ml)',
      'carbs': 15,
      'calories': 180, // Estimated
      'category': 'Soups',
      'image': 'assets/images/Soups/corn.jpg',
    },
    {
      'name': 'Freekeh Soup',
      'size': '1 cup (250 ml)',
      'carbs': 20,
      'calories': 200, // Estimated
      'category': 'Soups',
      'image': 'assets/images/Soups/Farekah.jpg',
    },
    {
      'name': 'Vegetable Soup',
      'size': '1 cup (250 ml)',
      'carbs': 10,
      'calories': 120, // Estimated
      'category': 'Soups',
      'image': 'assets/images/Soups/Khodra.jpg',
    },
    {
      'name': 'Mushroom Soup',
      'size': '1 cup (250 ml)',
      'carbs': 14,
      'calories': 160, // Estimated
      'category': 'Soups',
      'image': 'assets/images/Soups/Mashrom.jpg',
    },
    {
      'name': 'Oatmeal Soup',
      'size': '1 cup (250 ml)',
      'carbs': 16,
      'calories': 210, // Estimated
      'category': 'Soups',
      'image': 'assets/images/Soups/shofan.jpg',
    },

//////////////////////////// Breads
////**********
    ///
    ///
    /// */
    {
      'name': 'Barata Bread',
      'carbs': 45, // Example carbs, adjust as needed
      'calories': 200, // Example calories, adjust as needed
      'size': '1 piece',
      'category': 'Breads',
      'image': 'assets/images/breads/barata.jpg',
    },
    {
      'name': 'Bagel',
      'carbs': 55,
      'calories': 260,
      'size': '1 piece',
      'category': 'Breads',
      'image': 'assets/images/breads/begal.jpg',
    },
    {
      'name': 'Burger Bread',
      'carbs': 30,
      'calories': 150,
      'size': '1 piece',
      'category': 'Breads',
      'image': 'assets/images/breads/burger_bread.jpg',
    },
    {
      'name': 'French Bread',
      'carbs': 50,
      'calories': 240,
      'size': '1 piece',
      'category': 'Breads',
      'image': 'assets/images/breads/French.jpg',
    },
    {
      'name': 'Hamam Bread',
      'carbs': 35,
      'calories': 180,
      'size': '1 piece',
      'category': 'Breads',
      'image': 'assets/images/breads/hamam.png',
    },
    {
      'name': 'Kemag Bread',
      'carbs': 40,
      'calories': 190,
      'size': '1 piece',
      'category': 'Breads',
      'image': 'assets/images/breads/kemag.jpg',
    },
    {
      'name': 'Kemag Asmar',
      'carbs': 50,
      'calories': 220,
      'size': '1 piece',
      'category': 'Breads',
      'image': 'assets/images/breads/kemag_asmar.jpg',
    },
    {
      'name': 'Khamer Bread',
      'carbs': 25,
      'calories': 120,
      'size': '1 piece',
      'category': 'Breads',
      'image': 'assets/images/breads/khamer_bread.jpg',
    },
    {
      'name': 'Lobnani Bread',
      'carbs': 35,
      'calories': 160,
      'size': '1 piece',
      'category': 'Breads',
      'image': 'assets/images/breads/lobnani.jpg',
    },
    {
      'name': 'Shrak Bread',
      'carbs': 20,
      'calories': 100,
      'size': '1 piece',
      'category': 'Breads',
      'image': 'assets/images/breads/shrak.jpg',
    },
    {
      'name': 'Taboon Bread',
      'carbs': 40,
      'calories': 180,
      'size': '1 piece',
      'category': 'Breads',
      'image': 'assets/images/breads/tabon.jpg',
    },
    {
      'name': 'Tames Bread',
      'carbs': 30,
      'calories': 140,
      'size': '1 piece',
      'category': 'Breads',
      'image': 'assets/images/breads/tames.jpg',
    },
    {
      'name': 'Toast Bread',
      'carbs': 15,
      'calories': 80,
      'size': '1 slice',
      'category': 'Breads',
      'image': 'assets/images/breads/toast.jpg',
    },
    {
      'name': 'Toast Asmar',
      'carbs': 12,
      'calories': 70,
      'size': '1 slice',
      'category': 'Breads',
      'image': 'assets/images/breads/toast_asmar.jpg',
    },
////////////////////// Dairy Products
    ///Dairy Products
    ///
    {
      'name': 'Greek Yogurt',
      'size': '170 g',
      'carbs': 7,
      'calories': 120,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/greek_yogurt.jpg',
    },
    {
      'name': 'Low-Fat Cottage Cheese',
      'size': '40 g',
      'carbs': 1,
      'calories': 40,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/low_fat_cottage_cheese.jpg',
    },
    {
      'name': 'Full-Fat Cottage Cheese',
      'size': '40 g',
      'carbs': 1,
      'calories': 60,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/full_fat_cottage_cheese.jpg',
    },
    {
      'name': 'Low-Fat Milk',
      'size': '250 ml',
      'carbs': 12,
      'calories': 100,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/low_fat_milk.jpg',
    },
    {
      'name': 'Low-Fat Yogurt',
      'size': '245 g',
      'carbs': 17,
      'calories': 130,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/low_fat_yogurt.jpg',
    },
    {
      'name': 'Full-Fat Milk',
      'size': '250 ml',
      'carbs': 12,
      'calories': 150,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/full_fat_milk.jpg',
    },
    {
      'name': 'Full-Fat Yogurt',
      'size': '170 g',
      'carbs': 12,
      'calories': 120,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/full_fat_yogurt.jpg',
    },
    {
      'name': 'Skimmed Milk',
      'size': '250 ml',
      'carbs': 12,
      'calories': 80,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/skimmed_milk.jpg',
    },
    {
      'name': 'Skimmed Yogurt',
      'size': '170 g',
      'carbs': 13,
      'calories': 90,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/skimmed_yogurt.jpg',
    },
    {
      'name': 'Coconut Milk',
      'size': '250 ml',
      'carbs': 7,
      'calories': 60,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/coconut_milk.jpg',
    },
    {
      'name': 'Almond Milk',
      'size': '250 ml',
      'carbs': 5,
      'calories': 30,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/almond_milk.jpg',
    },
    {
      'name': 'Cheddar Cheese',
      'size': '1 slice (28 g)',
      'carbs': 1,
      'calories': 113, // Approximate
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/cheddar_cheese.jpg',
    },
    {
      'name': 'Mozzarella Cheese',
      'size': '1 slice (28 g)',
      'carbs': 1,
      'calories': 85, // Approximate
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/mozzarella_cheese.jpg',
    },
    {
      'name': 'Parmesan Cheese',
      'size': '1 tablespoon (5 g)',
      'carbs': 0.2,
      'calories': 22, // Approximate
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/parmesan_cheese.jpg',
    },
    {
      'name': 'Feta Cheese',
      'size': '1 cube (28 g)',
      'carbs': 1.2,
      'calories': 75, // Approximate
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/feta_cheese.jpg',
    },
    {
      'name': 'Cream Cheese',
      'size': '2 tablespoons (30 g)',
      'carbs': 1,
      'calories': 100, // Approximate
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/cream_cheese.jpg',
    },
    {
      'name': 'Swiss Cheese',
      'size': '1 slice (28 g)',
      'carbs': 1.5,
      'calories': 111,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/swiss_cheese.jpg',
    },

    {
      'name': 'Goat Cheese',
      'size': '1 tablespoon (14 g)',
      'carbs': 0.6,
      'calories': 35,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/goat_cheese.jpg',
    },
    {
      'name': 'Ricotta Cheese',
      'size': '1/4 cup (62 g)',
      'carbs': 3,
      'calories': 100,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/ricotta_cheese.jpg',
    },
    {
      'name': 'Brie Cheese',
      'size': '1 slice (28 g)',
      'carbs': 0.5,
      'calories': 95,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/brie_cheese.png',
    },
    {
      'name': 'Provolone Cheese',
      'size': '1 slice (28 g)',
      'carbs': 0.6,
      'calories': 98,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/provolone_cheese.jpg',
    },
    {
      'name': 'Paneer (Indian Cottage Cheese)',
      'size': '1 cube (28 g)',
      'carbs': 1.2,
      'calories': 82,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/paneer.jpg',
    },
    {
      'name': 'Halloumi Cheese',
      'size': '1 slice (30 g)',
      'carbs': 0.8,
      'calories': 85,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/halloumi_cheese.jpg',
    },

    {
      'name': 'Queso Fresco (Fresh Cheese)',
      'size': '1 slice (28 g)',
      'carbs': 1.1,
      'calories': 70,
      'category': 'Dairy Products',
      'image': 'assets/images/Diary/queso_fresco.jpg',
    },

    //////////////////////////
    ////////////////
    ///
    ///
    /// Salads and Appetizers
    {
      'name': 'Zaatar Manakeesh',
      'size': '100 g',
      'carbs': 52,
      'calories': 250, // Estimated based on typical values
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/zaatar_manakeesh.jpg',
    },
    {
      'name': 'Cheese Manakeesh',
      'size': '100 g',
      'carbs': 52,
      'calories': 280, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/cheese_manakeesh.jpg',
    },
    {
      'name': 'Meat Pie',
      'size': '50 g',
      'carbs': 18,
      'calories': 130, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/meat_pie.png',
    },
    {
      'name': 'Zaatar Pie',
      'size': '45 g',
      'carbs': 18,
      'calories': 130, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/Zaatar_Pie.jpg',
    },
    {
      'name': 'Cheese Pie',
      'size': '45 g',
      'carbs': 18,
      'calories': 140, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/cheese_pie.jpg',
    },
    {
      'name': 'Spinach Pie',
      'size': '50 g',
      'carbs': 18,
      'calories': 120, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/spinach_pie.jpg',
    },
    {
      'name': 'Vegetable Sambosa',
      'size': '1 small piece (40 g)',
      'carbs': 12,
      'calories': 100, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/vegetable_samosa.jpg',
    },
    {
      'name': 'Meat Sambousek',
      'size': '1 piece (80 g)',
      'carbs': 22,
      'calories': 180, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/meat_sambousek.jpg',
    },
    {
      'name': 'Plain Croissant',
      'size': '1 piece (100 g)',
      'carbs': 42,
      'calories': 400, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/plain_croissant.jpg',
    },
    {
      'name': 'Pancake',
      'size': '38 g',
      'carbs': 14,
      'calories': 110, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/Pancake.jpg',
    },
    {
      'name': 'Baba Ghanoush',
      'size': '15 g',
      'carbs': 1,
      'calories': 25, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/baba_ghanoush.jpg',
    },
    {
      'name': 'Cucumber with Yogurt and Mint',
      'size': '230 g',
      'carbs': 15,
      'calories': 150, // Estimated
      'category': 'Salads and Appetizers',
      'image':
          'assets/images/SaladsAndAppetizers/cucumber_with_yogurt_and_mint.jpg',
    },
    {
      'name': 'Falafel',
      'size': '2 pieces (60 g)',
      'carbs': 11,
      'calories': 160, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/falafel.jpg',
    },
    {
      'name': 'Eggplant Fatteh',
      'size': '17 g',
      'carbs': 5,
      'calories': 80, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/eggplant_fatteh.jpg',
    },
    {
      'name': 'Chickpea Fatteh',
      'size': '220 g',
      'carbs': 35,
      'calories': 300, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/chickpea_fatteh.jpg',
    },
    {
      'name': 'Foul Mudammas',
      'size': '100 g',
      'carbs': 10,
      'calories': 150, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/foul_mudammas.jpg',
    },
    {
      'name': 'Hummus with Tahini',
      'size': '1 tablespoon (30 g)',
      'carbs': 4,
      'calories': 70, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/hummus_with_tahini.jpg',
    },
    {
      'name': 'Eggplant Salad',
      'size': '200 g',
      'carbs': 10,
      'calories': 190, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/eggplant_salad.jpg',
    },
    {
      'name': 'Tabbouleh',
      'size': '160 g',
      'carbs': 17,
      'calories': 120, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/tabbouleh.jpg',
    },
    {
      'name': 'Ketchup',
      'size': '1 tablespoon (15 g)',
      'carbs': 4, // Approximate
      'calories': 15, // Approximate
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/ketchup.jpg',
    },
    {
      'name': 'Mayonnaise',
      'size': '1 tablespoon (15 g)',
      'carbs': 0, // Approximate
      'calories': 100, // Approximate
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/mayonnaise.jpg',
    },
    {
      'name': 'Mustard',
      'size': '1 teaspoon (5 g)',
      'carbs': 0.3, // Approximate
      'calories': 3, // Approximate
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/mustard.jpg',
    },

    {
      'name': 'Coleslaw Salad',
      'size': '180 g',
      'carbs': 12,
      'calories': 200, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/coleslaw_salad.jpg',
    },
    {
      'name': 'Arab Salad',
      'size': '200 g',
      'carbs': 6,
      'calories': 80, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/arabSalad.jpg',
    },
    {
      'name': 'Beet Salad',
      'size': '150 g',
      'carbs': 9,
      'calories': 100, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/banger.jpg',
    },
    {
      'name': 'Kibbeh',
      'size': '100 g',
      'carbs': 15,
      'calories': 250, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/Coba.jpg',
    },
    {
      'name': 'Greek Salad',
      'size': '200 g',
      'carbs': 4,
      'calories': 90, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/graceSalad.jpg',
    },
    {
      'name': 'Arugula Salad',
      'size': '100 g',
      'carbs': 3,
      'calories': 40, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/Jarjer.jpg',
    },
    {
      'name': 'Macaroni Salad',
      'size': '150 g',
      'carbs': 25,
      'calories': 300, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/makaroneh_salad.jpg',
    },
    {
      'name': 'Mutabal',
      'size': '150 g',
      'carbs': 5,
      'calories': 100, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/motabal.jpg',
    },
    {
      'name': 'Mozzarella Sticks',
      'size': '100 g',
      'carbs': 18,
      'calories': 280, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/motzarela.jpg',
    },
    {
      'name': 'Spring Rolls',
      'size': '100 g',
      'carbs': 12,
      'calories': 150, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/rolat.jpg',
    },
    {
      'name': 'Caesar Salad',
      'size': '250 g',
      'carbs': 10,
      'calories': 200, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/sezar_salad.jpg',
    },
    {
      'name': 'Tuna Salad',
      'size': '200 g',
      'carbs': 5,
      'calories': 150, // Estimated
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/tuna_salad.jpg',
    },
    {
      'name': 'Mashed Potatoes',
      'size': '1 cup (200 g)',
      'carbs': 35, // Approximate
      'calories': 180, // Approximate
      'category': 'Salads and Appetizers',
      'image':
          'assets/images/SaladsAndAppetizers/potetoMahros.jpg', // Image path
    },
    {
      'name': 'Sfeeha (Meat Pastry)',
      'size': '2 pieces (150 g)',
      'carbs': 28, // Approximate
      'calories': 300, // Approximate
      'category': 'Salads and Appetizers',
      'image': 'assets/images/SaladsAndAppetizers/sofeha.jpg', // Image path
    },

    /////////////////////
    //////////////////////////////
    ///////////////////////////////////////////////////////// Sweets and Snacks
    {
      'name': 'Vanilla Ice Cream',
      'size': '1/2 cup (70 g)',
      'carbs': 16,
      'calories': 140, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/vanilla_ice_cream.jpg',
    },
    {
      'name': 'Strawberry Ice Cream',
      'size': '1/2 cup (70 g)',
      'carbs': 30,
      'calories': 200, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/strawberry_ice_cream.jpg',
    },
    {
      'name': 'Mango Ice Cream',
      'size': '1/2 cup (70 g)',
      'carbs': 30,
      'calories': 200, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/mango_ice_cream.jpg',
    },
    {
      'name': 'Chocolate Ice Cream',
      'size': '1/2 cup (70 g)',
      'carbs': 20,
      'calories': 160, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/chocolate_ice_cream.jpg',
    },
    {
      'name': 'Ice Cream Biscuit',
      'size': '1 piece (4 g)',
      'carbs': 3.2,
      'calories': 20, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/ice_cream_biscuit.jpg',
    },
    {
      'name': 'Waffles',
      'size': '1 piece (75 g)',
      'carbs': 24.7,
      'calories': 300, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/waffles.jpg',
    },
    {
      'name': 'Vanilla Cake',
      'size': '1 slice (67 g)',
      'carbs': 38,
      'calories': 280, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/vanilla_cake.jpg',
    },
    {
      'name': 'Oreo Cookies',
      'size': '3 pieces (25 g)',
      'carbs': 25,
      'calories': 150, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/oreo_cookies.jpg',
    },
    {
      'name': 'Chocolate Brownie',
      'size': '1 piece (60 g)',
      'carbs': 36, // Approximate
      'calories': 250, // Approximate
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/chocolate_brownie.jpg',
    },

    {
      'name': 'Muffin',
      'size': '1 piece (75 g)',
      'carbs': 41,
      'calories': 320, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/muffin.jpg',
    },
    {
      'name': 'Fruit Cake',
      'size': '1 slice (43 g)',
      'carbs': 26.5,
      'calories': 190, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/fruit_cake.jpg',
    },
    {
      'name': 'Donuts with Jam',
      'size': '1 piece (53 g)',
      'carbs': 34,
      'calories': 260, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/jam_donuts.jpg',
    },
    {
      'name': 'Donuts with Sugar',
      'size': '1 piece (53 g)',
      'carbs': 36,
      'calories': 250, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/sugar_donuts.jpg',
    },
    {
      'name': 'Plain Donuts',
      'size': '1 piece (51 g)',
      'carbs': 23,
      'calories': 200, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/plain_donuts.jpg',
    },
    {
      'name': 'Digestive Biscuits with Chocolate',
      'size': '1 piece (34 g)',
      'carbs': 11.3,
      'calories': 120, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/chocolate_digestive_biscuits.jpg',
    },
    {
      'name': 'Digestive Biscuits',
      'size': '2 pieces (18 g)',
      'carbs': 18,
      'calories': 90, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/digestive_biscuits.jpg',
    },
    {
      'name': 'Date Biscuits',
      'size': '1 small piece (20 g)',
      'carbs': 12,
      'calories': 80, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/date_biscuits.jpg',
    },
    {
      'name': 'Danish Pastries',
      'size': '1 piece (71 g)',
      'carbs': 34,
      'calories': 310, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/danish_pastries.jpg',
    },
    {
      'name': 'Croissant',
      'size': '1 piece (75 g)',
      'carbs': 32,
      'calories': 300, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/croissant.jpg',
    },
    {
      'name': 'Cream Crackers',
      'size': '1 piece (15 g)',
      'carbs': 10,
      'calories': 60, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/cream_crackers.png',
    },
    {
      'name': 'Sponge Chocolate Cake',
      'size': '1 slice (61 g)',
      'carbs': 25.6,
      'calories': 300, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/sponge_chocolate_cake.jpg',
    },
    {
      'name': 'Biscuits with Chocolate Chips',
      'size': '1 piece (30 g)',
      'carbs': 20,
      'calories': 120, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/chocolate_chip_biscuits.jpg',
    },
    {
      'name': 'Chocolate Covered Biscuits',
      'size': '1 piece (99 g)',
      'carbs': 67.4,
      'calories': 480, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/chocolate_biscuits.jpg',
    },
    {
      'name': 'Cheesecake',
      'size': '1 slice (80 g)',
      'carbs': 20.4,
      'calories': 250, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/cheesecake.jpg',
    },
    {
      'name': 'Strawberry Cheesecake',
      'size': '1 slice (120 g)',
      'carbs': 38, // Approximate
      'calories': 380, // Approximate
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/strawberry_cheesecake.jpg',
    },
    {
      'name': 'Blueberry Cheesecake',
      'size': '1 slice (120 g)',
      'carbs': 36, // Approximate
      'calories': 370, // Approximate
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/blueberry_cheesecake.jpg',
    },
    {
      'name': 'Chocolate Cheesecake',
      'size': '1 slice (120 g)',
      'carbs': 40, // Approximate
      'calories': 400, // Approximate
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/chocolate_cheesecake.jpg',
    },
    {
      'name': 'Salted Caramel Cheesecake',
      'size': '1 slice (120 g)',
      'carbs': 42, // Approximate
      'calories': 410, // Approximate
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/salted_caramel_cheesecake.jpg',
    },
    {
      'name': 'Carrot Cake',
      'size': '1 slice (173 g)',
      'carbs': 73,
      'calories': 400, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/carrot_cake.jpg',
    },
    {
      'name': 'Black Forest Cake with Fruits',
      'size': '1 slice (249 g)',
      'carbs': 54,
      'calories': 500, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/black_forest_cake.jpg',
    },
    {
      'name': 'Apple Pie 9 Inch',
      'size': '1/8 pie (155 g)',
      'carbs': 57.5,
      'calories': 350, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/apple_pie_9_inch.jpg',
    },
    {
      'name': 'Baklava',
      'size': '1 small piece (30 g)',
      'carbs': 17.5,
      'calories': 120, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/baklava.jpg',
    },
    {
      'name': 'Barazek (Sesame Cake with Honey and Pistachios)',
      'size': '2 small pieces (30 g)',
      'carbs': 12,
      'calories': 100, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/barazek.jpg',
    },
    {
      'name': 'BasBosa',
      'size': '1 piece (25 g)',
      'carbs': 15,
      'calories': 90, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/BasBosa.jpg',
    },
    {
      'name': 'Kunafa with Cheese',
      'size': '1 square (100 g)',
      'carbs': 25,
      'calories': 360, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/kunafa_with_cheese.jpg',
    },
    {
      'name': 'Falooda',
      'size': '1/2 cup (135 g)',
      'carbs': 21.3,
      'calories': 350, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/Falooda.jpg',
    },
    {
      'name': 'Maamoul with Dates',
      'size': '1 piece (50 g)',
      'carbs': 28,
      'calories': 220, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/maamoul_with_dates.png',
    },
    {
      'name': 'Ghazl El Banat (with Pistachios)',
      'size': '1 cup (50 g)',
      'carbs': 43,
      'calories': 200, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/cotton_candy.jpg',
    },
    {
      'name': 'Ghraiba',
      'size': '1 piece (20 g)',
      'carbs': 10,
      'calories': 80, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/Ghraiba.jpg',
    },
    {
      'name': 'Halawa',
      'size': '2 squares (25 g)',
      'carbs': 14,
      'calories': 100, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/halawa.jpg',
    },
    {
      'name': 'Cheese Sweet',
      'size': '55 g',
      'carbs': 20,
      'calories': 180, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/cheese_sweet.jpg',
    },
    {
      'name': 'Qamar El Din (Dried Apricot)',
      'size': '1/3 cup (34 g)',
      'carbs': 28,
      'calories': 120, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/qamar_el_din.jpg',
    },

    {
      'name': 'Karabej',
      'size': '1 piece (35 g)',
      'carbs': 15,
      'calories': 100, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/Karabej.jpg',
    },
    {
      'name': 'Qatayef with Cream',
      'size': '1 medium piece (126 g)',
      'carbs': 35,
      'calories': 250, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/qatayef_with_cream.jpg',
    },
    {
      'name': 'Loqemat (Aoama)',
      'size': '3 medium pieces',
      'carbs': 15,
      'calories': 60, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/Loqemat.jpg',
    },
    {
      'name': 'Macaroon',
      'size': '1 piece (50 g)',
      'carbs': 20,
      'calories': 160, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/Macaroon.jpg',
    },
    {
      'name': 'Meshabak',
      'size': '1 piece (175 g)',
      'carbs': 40,
      'calories': 350, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/meshabak.jpg',
    },

    {
      'name': 'Mohalabia',
      'size': '1/2 cup (130 g)',
      'carbs': 20,
      'calories': 200, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/Mohalabia.jpg',
    },
    {
      'name': 'Nouga',
      'size': '1 piece (28 g)',
      'carbs': 26,
      'calories': 220, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/nougat.jpg',
    },
    {
      'name': 'Othmaliah',
      'size': '1 piece (120 g)',
      'carbs': 45,
      'calories': 350, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/Othmaliah.jpg',
    },
    {
      'name': 'Holqom',
      'size': '1 square (22 g)',
      'carbs': 16,
      'calories': 90, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/Holqom.jpg',
    },
    {
      'name': 'Rice with Milk',
      'size': '1/2 cup (130 g)',
      'carbs': 25,
      'calories': 150, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/rice_with_milk.jpg',
    },
    {
      'name': 'Safouf',
      'size': '1 piece (60 g)',
      'carbs': 40,
      'calories': 180, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/safouf.jpg',
    },
    {
      'name': 'Om Ali',
      'size': '1/2 cup (102 g)',
      'carbs': 27,
      'calories': 180, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/om_ali_cup.jpg',
    },
    {
      'name': 'Maamoul with Walnuts',
      'size': '1 piece (50 g)',
      'carbs': 20,
      'calories': 200, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/maamoul_with_walnuts.jpg',
    },
    {
      'name': 'Znood El Sett',
      'size': '1 piece (80 g)',
      'carbs': 20,
      'calories': 220, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/znood_el_sett.jpg',
    },
    {
      'name': 'Walnuts Qatayef',
      'size': '1 medium piece (126 g)',
      'carbs': 35,
      'calories': 300, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/Walnuts_qatayef.png',
    },
    {
      'name': 'Apricot Jam',
      'size': '1 tablespoon (15 g)',
      'carbs': 13,
      'calories': 50, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/apricot_jam.jpg',
    },
    {
      'name': 'Fig Jam',
      'size': '1 tablespoon (17 g)',
      'carbs': 15,
      'calories': 60, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/fig_jam.jpg',
    },
    {
      'name': 'Honey',
      'size': '1 tablespoon (20 g)',
      'carbs': 17,
      'calories': 60, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/honey.jpg',
    },
    {
      'name': 'Strawberry Jam',
      'size': '1 tablespoon (20 g)',
      'carbs': 13.6,
      'calories': 50, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/strawberry_jam.jpg',
    },
    {
      'name': 'Sugar',
      'size': '1 tablespoon (13 g)',
      'carbs': 15,
      'calories': 60, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/sugar.jpg',
    },
    // Additional items for Sweets and Snacks
    {
      'name': 'Potato Chips - Pringles',
      'size': '13 chips (25 g)',
      'carbs': 12,
      'calories': 110, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/pringles_chips.jpg',
    },
    {
      'name': 'Popcorn (Large Size - Regular)',
      'size': '11 cups',
      'carbs': 85,
      'calories': 500, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/large_popcorn.jpg',
    },
    {
      'name': 'Popcorn (Medium Size - Regular)',
      'size': '8 cups',
      'carbs': 60,
      'calories': 350, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/medium_popcorn.jpg',
    },
    {
      'name': 'Popcorn (Small Size - Regular)',
      'size': '5 cups',
      'carbs': 39,
      'calories': 200, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/small_popcorn.jpg',
    },
    // Additional items for Sweets and Snacks

    {
      'name': 'Cadbury Fingers with Milk',
      'size': '1 regular piece (37 g)',
      'carbs': 21,
      'calories': 180, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/cadbury_fingers.jpg',
    },
    {
      'name': 'Ferrero Rocher',
      'size': '3 balls (37 g)',
      'carbs': 18,
      'calories': 225, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/ferrero_rocher.jpg',
    },
    {
      'name': 'KitKat',
      'size': '4 fingers (42 g)',
      'carbs': 26,
      'calories': 220, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/kitkat.jpg',
    },
    {
      'name': 'M&M\'s with Chocolate and Pistachios',
      'size': '1/2 cup (128 g)',
      'carbs': 25,
      'calories': 500, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/mms_pistachios.jpg',
    },
    {
      'name': 'Maltesers',
      'size': '1 bag (37 g)',
      'carbs': 20,
      'calories': 170, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/maltesers.png',
    },
    {
      'name': 'Mars',
      'size': '1 regular piece (58 g)',
      'carbs': 30,
      'calories': 250, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/mars.png',
    },
    {
      'name': 'Nutella',
      'size': '1 large spoon (15 g)',
      'carbs': 15,
      'calories': 100, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/nutella.jpg',
    },
    {
      'name': 'Smartees',
      'size': '1 piece (38 g)',
      'carbs': 22,
      'calories': 190, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/smartees.jpg',
    },
    {
      'name': 'Snickers',
      'size': '1 regular piece (50 g)',
      'carbs': 25.7,
      'calories': 240, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/snickers.jpg',
    },
    {
      'name': 'Toblerone',
      'size': '3 pieces (38 g)',
      'carbs': 15,
      'calories': 200, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/toblerone.jpg',
    },
    {
      'name': 'Twix',
      'size': '2 regular piece (50 g)',
      'carbs': 26,
      'calories': 240, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/twix.jpg',
    },
    {
      'name': 'Oreo',
      'size': '3 cookies (29 g)',
      'carbs': 21,
      'calories': 140, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/oreo.jpg',
    },
    {
      'name': 'Mr. Chips',
      'size': '1 bag (70 g)',
      'carbs': 38,
      'calories': 330, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/mr_chips.jpg',
    },
    {
      'name': 'Cheetos',
      'size': '1 bag (50 g)',
      'carbs': 30,
      'calories': 280, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/cheetos.jpg',
    },
    {
      'name': 'Doritos',
      'size': '1 bag (50 g)',
      'carbs': 27,
      'calories': 250, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/doritos.jpg',
    },
    {
      'name': 'Lays Classic',
      'size': '1 bag (28 g)',
      'carbs': 15,
      'calories': 150, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/lays_classic.jpg',
    },
    {
      'name': 'Pringles Original',
      'size': '1 small can (40 g)',
      'carbs': 21,
      'calories': 200, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/pringles_original.jpg',
    },
    {
      'name': 'Nutella & Go',
      'size': '1 pack (50 g)',
      'carbs': 29,
      'calories': 260, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/nutella_go.jpg',
    },
    {
      'name': 'Bounty',
      'size': '2 bars (57 g)',
      'carbs': 32,
      'calories': 280, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/bounty.png',
    },
    {
      'name': 'Reese’s Peanut Butter Cups',
      'size': '2 cups (42 g)',
      'carbs': 21,
      'calories': 210, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/reeses.jpg',
    },
    {
      'name': 'Chocolate Chip Cookies',
      'size': '2 cookies (28 g)',
      'carbs': 22,
      'calories': 140, // Approximate
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/chocolate_chip_cookies.jpg',
    },
    {
      'name': 'Oatmeal Raisin Cookies',
      'size': '2 cookies (28 g)',
      'carbs': 20,
      'calories': 130, // Approximate
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/oatmeal_raisin_cookies.jpg',
    },
    {
      'name': 'Butter Cookies',
      'size': '3 cookies (30 g)',
      'carbs': 17,
      'calories': 150, // Approximate
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/butter_cookies.jpg',
    },
    {
      'name': 'Sugar Cookies',
      'size': '1 cookie (25 g)',
      'carbs': 18,
      'calories': 120, // Approximate
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/sugar_cookies.jpg',
    },
    {
      'name': 'Peanut Butter Biscotti',
      'size': '1 cookie (30 g)',
      'carbs': 16,
      'calories': 160, // Approximate
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/peanut_butter_cookies.jpg',
    },
    {
      'name': 'Macadamia Nut Biscotti',
      'size': '1 cookie (28 g)',
      'carbs': 18,
      'calories': 150, // Approximate
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/macadamia_nut_cookies.jpg',
    },
    {
      'name': 'Double Chocolate Cookies',
      'size': '1 cookie (30 g)',
      'carbs': 20,
      'calories': 160, // Approximate
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/double_chocolate_cookies.jpg',
    },
    {
      'name': 'Almond Biscotti',
      'size': '2 cookies (30 g)',
      'carbs': 15,
      'calories': 150, // Approximate
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/almond_cookies.jpg',
    },
    {
      'name': 'Coconut Biscotti',
      'size': '2 cookies (30 g)',
      'carbs': 18,
      'calories': 140, // Approximate
      'category': 'Sweets and Snacks',
      'image': 'assets/images/candies/coconut_cookies.jpg',
    },
    {
      'name': 'Boiled Lupin ',
      'size': '1/2 cup (80 g, 6 tbsp)',
      'carbs': 15,
      'calories': 120, // Estimated
      'category': 'Sweets and Snacks',
      'image': 'assets/images/lunch/boiled_lupin_beans.jpg',
    },

    ///
    ///
    /////////////////////LUNCH
    ///
    {
      'name': 'Egyptian Rice',
      'size': '100 g (cooked)',
      'carbs': 29,
      'calories': 135, // Average of 130-140 kcal
      'category': 'Lunch',
      'image':
          'assets/images/lunch/egyptian_rice.jpg', // Adjust image path if needed
    },
    {
      'name': 'American Rice (Long Grain)',
      'size': '100 g (cooked)',
      'carbs': 25, // Average of 24-26 g
      'calories': 115, // Average of 110-120 kcal
      'category': 'Lunch',
      'image':
          'assets/images/lunch/american_rice.jpg', // Adjust image path if needed
    },
    {
      'name': 'Chicken Breast Piece',
      'size': '1 piece (150 g)',
      'carbs': 0,
      'calories': 165, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/chicken_breast.jpg',
    },
    {
      'name': 'Chicken Thigh Piece',
      'size': '1 piece (130 g)',
      'carbs': 0,
      'calories': 210, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/chicken_thigh.jpg',
    },
    {
      'name': 'Lamb meat',
      'size': '(150 g)',
      'carbs': 0,
      'calories': 340, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/lamb_piece.jpg',
    },
    {
      'name': 'Veal Meat',
      'size': '(150 g)',
      'carbs': 0,
      'calories': 260, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/veal_piece.jpg',
    },
    {
      'name': 'Salmon',
      'size': '1 fillet (150 g)',
      'carbs': 0,
      'calories': 250, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/salmon.jpg',
    },
    {
      'name': 'Tuna Steak',
      'size': '1 steak (150 g)',
      'carbs': 0,
      'calories': 220, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/tuna_steak.jpg',
    },
    {
      'name': 'Fried Shrimp',
      'size': '1 serving (150 g)',
      'carbs': 10, // Approximate (breading adds carbs)
      'calories': 250, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/fried_shrimp.jpg',
    },
    {
      'name': 'Grilled Shrimp',
      'size': '1 serving (150 g)',
      'carbs': 0,
      'calories': 160, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/grilled_shrimp.jpg',
    },
    {
      'name': 'Grilled Calamari',
      'size': '1 serving (150 g)',
      'carbs': 0,
      'calories': 200, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/grilled_calamari.jpg',
    },
    {
      'name': 'Fried Calamari',
      'size': '1 serving (150 g)',
      'carbs': 12, // Approximate (breading adds carbs)
      'calories': 280, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/fried_calamari.jpg',
    },

    {
      'name': 'Tilapia',
      'size': '1 fillet (150 g)',
      'carbs': 0,
      'calories': 140, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/tilapia.jpg',
    },
    {
      'name': 'Cod',
      'size': '1 fillet (150 g)',
      'carbs': 0,
      'calories': 120, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/cod.jpg',
    },
    {
      'name': 'Sea Bass',
      'size': '1 fillet (150 g)',
      'carbs': 0,
      'calories': 160, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/sea_bass.jpg',
    },

    {
      'name': 'Bulgur with Tomato',
      'size': '1/2 cup (80 g)',
      'carbs': 20,
      'calories': 100, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/bulgur_with_tomato.jpg',
    },
    {
      'name': 'Chicken Shawarma Sandwich',
      'size': '1 sandwich (314 g)',
      'carbs': 30,
      'calories': 450, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/chicken_shawarma_sandwich.jpg',
    },
    {
      'name': 'Beef Shawarma Sandwich',
      'size': '1 sandwich (320 g)',
      'carbs': 35,
      'calories': 500, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/beef_shawarma_sandwich.jpg',
    },
    {
      'name': 'Shish Barak',
      'size': '1 cup (250 g)',
      'carbs': 30,
      'calories': 350, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/shish_barak.jpg',
    },
    {
      'name': 'Shish Tawook Sandwich',
      'size': '1 sandwich (187 g)',
      'carbs': 35,
      'calories': 400, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/shish_tawook_sandwich.jpg',
    },
    {
      'name': 'Chicken Makbos',
      'size': '100 g',
      'carbs': 10,
      'calories': 120, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/chicken_maqluba.jpg',
    },
    {
      'name': 'Asida',
      'size': '2 tablespoons (30 g)',
      'carbs': 15,
      'calories': 120, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/asida.jpg',
    },
    {
      'name': 'Freekeh',
      'size': '1 cup (243 g)',
      'carbs': 33,
      'calories': 350, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/freekeh.jpg',
    },
    {
      'name': 'Jareesh',
      'size': '1 cup (250 g)',
      'carbs': 12.5,
      'calories': 100, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/jareesh.jpg',
    },

    {
      'name': 'Kafta Sandwich',
      'size': '1 sandwich (200 g)',
      'carbs': 35,
      'calories': 400, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/kafta_sandwich.jpg',
    },
    {
      'name': 'Kebbeh Bil Sanieh',
      'size': '1 tray (300 g)',
      'carbs': 35,
      'calories': 450, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/kebbeh_bil_sanieh.jpg',
    },
    {
      'name': 'Kebbeh Bil Laban',
      'size': '1 cup (250 g)',
      'carbs': 25,
      'calories': 300, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/kebbeh_bil_laban.jpg',
    },
    {
      'name': 'Koshary',
      'size': '1 cup (140 g)',
      'carbs': 45,
      'calories': 350, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/koshary.jpg',
    },
    {
      'name': 'Spaghetti with Tomato Sauce',
      'size': '1 serving (200 g)',
      'carbs': 42, // Approximate
      'calories': 320, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/spaghetti_tomato.jpg',
    },
    {
      'name': 'Fettuccine Alfredo',
      'size': '1 serving (200 g)',
      'carbs': 38, // Approximate
      'calories': 480, // Approximate (creamy sauce)
      'category': 'Lunch',
      'image': 'assets/images/lunch/fettuccine_alfredo.jpg',
    },
    {
      'name': 'Penne Arrabbiata',
      'size': '1 serving (200 g)',
      'carbs': 44, // Approximate
      'calories': 350, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/penne_arrabbiata.jpg',
    },
    {
      'name': 'Lasagna',
      'size': '1 piece (250 g)',
      'carbs': 40, // Approximate
      'calories': 450, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/lasagna.jpg',
    },
    {
      'name': 'Pasta Primavera',
      'size': '1 serving (200 g)',
      'carbs': 36, // Approximate
      'calories': 280, // Approximate (vegetable-based)
      'category': 'Lunch',
      'image': 'assets/images/lunch/pasta_primavera.jpg',
    },
    {
      'name': 'Mac and Cheese',
      'size': '1 serving (200 g)',
      'carbs': 45, // Approximate
      'calories': 500, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/mac_and_cheese.jpg',
    },
    {
      'name': 'Pasta Carbonara',
      'size': '1 serving (200 g)',
      'carbs': 36, // Approximate
      'calories': 460, // Approximate (creamy with bacon)
      'category': 'Lunch',
      'image': 'assets/images/lunch/carbonara.jpg',
    },
    {
      'name': 'Seafood Pasta',
      'size': '1 serving (200 g)',
      'carbs': 34, // Approximate
      'calories': 400, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/seafood_pasta.jpg',
    },
    {
      'name': 'Pasta with Pesto Sauce',
      'size': '1 serving (200 g)',
      'carbs': 40, // Approximate
      'calories': 350, // Approximate
      'category': 'Lunch',
      'image': 'assets/images/lunch/pesto_pasta.jpg',
    },
    {
      'name': 'Liver Sandwich with Tahini',
      'size': '1 sandwich (187 g)',
      'carbs': 44,
      'calories': 400, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/liver_sandwich.jpg',
    },
    {
      'name': 'Macaroni with Bechamel',
      'size': '1/2 cup (125 g)',
      'carbs': 17,
      'calories': 200, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/macaroni_bechamel.png',
    },
    {
      'name': 'Mjaddara',
      'size': '1 cup (203 g)',
      'carbs': 38,
      'calories': 300, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/mjaddara.jpg',
    },
    {
      'name': 'Chicken Musakhan Roll',
      'size': '1 roll (230 g)',
      'carbs': 45,
      'calories': 400, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/chicken_musakhan_roll.jpg',
    },

    {
      'name': 'Stuffed Cabbage Rolls',
      'size': '3 pieces (150 g)',
      'carbs': 22.5,
      'calories': 180, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/stuffed_cabbage.jpg',
    },
    {
      'name': 'Stuffed Eggplant',
      'size': '2 pieces (370 g)',
      'carbs': 40,
      'calories': 300, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/stuffed_eggplant.jpg',
    },
    {
      'name': 'Stuffed Grape Leaves',
      'size': '6 pieces (70 g)',
      'carbs': 15,
      'calories': 120, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/stuffed_grape_leaves.jpg',
    },
    {
      'name': 'Stuffed Zucchini',
      'size': '3 medium pieces (450 g)',
      'carbs': 35,
      'calories': 280, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/stuffed_zucchini.jpg',
    },
    {
      'name': 'Lupin Beans',
      'size': '1/2 cup (80 g, 6 tbsp)',
      'carbs': 15,
      'calories': 120, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/boiled_lupin_beans.jpg',
    },
    {
      'name': 'Boiled Chickpeas',
      'size': '1/2 cup (80 g, 6 tbsp)',
      'carbs': 15,
      'calories': 130, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/boiled_chickpeas.jpg',
    },
    {
      'name': 'Boiled Fava Beans',
      'size': '1/2 cup (80 g, 6 tbsp)',
      'carbs': 15,
      'calories': 120, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/boiled_fava_beans.jpg',
    },
    {
      'name': 'Lentils',
      'size': '1/2 cup (100 g, 6 tbsp)',
      'carbs': 15,
      'calories': 140, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/lentils.jpg',
    },
    {
      'name': 'Boiled Green Beans',
      'size': '1/2 cup (80 g, 6 tbsp)',
      'carbs': 15,
      'calories': 110, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/boiled_green_beans.jpg',
    },
    {
      'name': 'Red Beans',
      'size': '1/2 cup (75 g, 6 tbsp)',
      'carbs': 15,
      'calories': 110, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/red_beans.jpg',
    },

    {
      'name': 'Meat Burger with Cheese',
      'size': '1 sandwich (124 g)',
      'carbs': 32,
      'calories': 320, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/meat_burger_cheese.jpg',
    },
    {
      'name': 'Chicken Nuggets',
      'size': '6 pieces (114 g)',
      'carbs': 17,
      'calories': 300, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/chicken_nuggets.jpg',
    },
    {
      'name': 'Small Fries',
      'size': '1 small pack (110 g)',
      'carbs': 42,
      'calories': 320, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/small_fries.jpg',
    },
    {
      'name': 'Medium Fries',
      'size': '1 medium pack (220 g)',
      'carbs': 84,
      'calories': 450, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/medium_fries.jpg',
    },
    {
      'name': 'Large Fries',
      'size': '1 large pack (259 g)',
      'carbs': 100,
      'calories': 600, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/large_fries.jpg',
    },
    {
      'name': 'Crust Pizza',
      'size': '1 slice (91 g)',
      'carbs': 27,
      'calories': 300, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/Crust_pizza.jpg',
    },
    {
      'name': 'Thin Crust Pizza',
      'size': '1 slice (5 g)',
      'carbs': 22,
      'calories': 150, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/thin_crust_pizza.jpg',
    },
    {
      'name': 'Fried Chicken',
      'size': '1 piece (105 g)',
      'carbs': 8,
      'calories': 250, // Estimated
      'category': 'Lunch',
      'image': 'assets/images/lunch/fried_chicken.jpg',
    },
    {
      'name': 'moussaka',
      'size': '1 cup (160 g)',
      'carbs': 24,
      'calories': 150, // Estimated
      'category': 'Lunch',
      'image':
          'assets/images/lunch/moussaka.jpg', // Adjust image path if needed
    },
//****
//
//
// */
// ****************************************************************************************Breakfast
    {
      'name': 'Boiled Eggs',
      'size': '1 large egg (50 g)',
      'carbs': 0.6,
      'calories': 68, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/boiled_eggs.png',
    },
    {
      'name': 'Scrambled Eggs',
      'size': '2 large eggs (100 g)',
      'carbs': 1.5,
      'calories': 150, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/scrambled_eggs.jpg',
    },
    {
      'name': 'Fried Eggs',
      'size': '1 large egg (50 g)',
      'carbs': 0.6,
      'calories': 90, // Approximate, includes oil
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/fried_eggs.jpg',
    },
    {
      'name': 'Omelette',
      'size': '2 large eggs (100 g)',
      'carbs': 1.2,
      'calories': 154, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/omelette.jpg',
    },
    {
      'name': 'Pastry with Cheese',
      'size': '1 piece (70 g)',
      'carbs': 20,
      'calories': 220, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/cheese_pastry.jpg',
    },
    {
      'name': 'Pastrami Slices',
      'size': '2 slices (28 g)',
      'carbs': 0,
      'calories': 60, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/pastrami_slices.jpg',
    },
    {
      'name': 'Mortadella',
      'size': '2 slices (28 g)',
      'carbs': 1,
      'calories': 90, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/mortadella.jpg',
    },
    {
      'name': 'French Toast',
      'size': '1 slice (65 g)',
      'carbs': 20,
      'calories': 190, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/french_toast.jpg',
    },
    {
      'name': 'Croissant with Butter',
      'size': '1 croissant (70 g)',
      'carbs': 25,
      'calories': 300, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/croissant_butter.jpg',
    },
    {
      'name': 'Bagel with Cream Cheese',
      'size': '1 bagel (100 g)',
      'carbs': 48,
      'calories': 290, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/bagel_cream_cheese.jpg',
    },
    {
      'name': 'Pancakes with Syrup',
      'size': '2 pancakes (100 g)',
      'carbs': 35,
      'calories': 280, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/pancakes_syrup.jpg',
    },
    {
      'name': 'Foul Medames',
      'size': '1 cup (250 g)',
      'carbs': 40,
      'calories': 330, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/SaladsAndAppetizers/foul_mudammas.jpg',
    },
    {
      'name': 'Manakish Zaatar',
      'size': '1 piece (80 g)',
      'carbs': 30,
      'calories': 250, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/SaladsAndAppetizers/zaatar_manakeesh.jpg',
    },
    {
      'name': 'Falafel',
      'size': '3 pieces (90 g)',
      'carbs': 15,
      'calories': 180, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/SaladsAndAppetizers/falafel.jpg',
    },
    {
      'name': 'Labneh with Olive Oil',
      'size': '2 tablespoons (50 g)',
      'carbs': 4,
      'calories': 150, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/labneh_olive_oil.jpg',
    },
    {
      'name': 'Cheddar Cheese',
      'size': '1 slice (28 g)',
      'carbs': 1,
      'calories': 113, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Diary/cheddar_cheese.jpg',
    },
    {
      'name': 'Mozzarella Cheese',
      'size': '1 slice (28 g)',
      'carbs': 1,
      'calories': 85, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Diary/mozzarella_cheese.jpg',
    },
    {
      'name': 'Parmesan Cheese',
      'size': '1 tablespoon (5 g)',
      'carbs': 0.2,
      'calories': 22, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Diary/parmesan_cheese.jpg',
    },
    {
      'name': 'Feta Cheese',
      'size': '1 cube (28 g)',
      'carbs': 1.2,
      'calories': 75, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Diary/feta_cheese.jpg',
    },
    {
      'name': 'Cream Cheese',
      'size': '2 tablespoons (30 g)',
      'carbs': 1,
      'calories': 100, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Diary/cream_cheese.jpg',
    },
    {
      'name': 'Swiss Cheese',
      'size': '1 slice (28 g)',
      'carbs': 1.5,
      'calories': 111,
      'category': 'Breakfast',
      'image': 'assets/images/Diary/swiss_cheese.jpg',
    },

    {
      'name': 'Goat Cheese',
      'size': '1 tablespoon (14 g)',
      'carbs': 0.6,
      'calories': 35,
      'category': 'Breakfast',
      'image': 'assets/images/Diary/goat_cheese.jpg',
    },
    {
      'name': 'Ricotta Cheese',
      'size': '1/4 cup (62 g)',
      'carbs': 3,
      'calories': 100,
      'category': 'Breakfast',
      'image': 'assets/images/Diary/ricotta_cheese.jpg',
    },
    {
      'name': 'Brie Cheese',
      'size': '1 slice (28 g)',
      'carbs': 0.5,
      'calories': 95,
      'category': 'Breakfast',
      'image': 'assets/images/Diary/brie_cheese.png',
    },
    {
      'name': 'Provolone Cheese',
      'size': '1 slice (28 g)',
      'carbs': 0.6,
      'calories': 98,
      'category': 'Breakfast',
      'image': 'assets/images/Diary/provolone_cheese.jpg',
    },
    {
      'name': 'Paneer (Indian Cottage Cheese)',
      'size': '1 cube (28 g)',
      'carbs': 1.2,
      'calories': 82,
      'category': 'Breakfast',
      'image': 'assets/images/Diary/paneer.jpg',
    },
    {
      'name': 'Halloumi Cheese',
      'size': '1 slice (30 g)',
      'carbs': 0.8,
      'calories': 85,
      'category': 'Breakfast',
      'image': 'assets/images/Diary/halloumi_cheese.jpg',
    },

    {
      'name': 'Queso Fresco (Fresh Cheese)',
      'size': '1 slice (28 g)',
      'carbs': 1.1,
      'calories': 70,
      'category': 'Breakfast',
      'image': 'assets/images/Diary/queso_fresco.jpg',
    },
    {
      'name': 'Low-Fat Cottage Cheese',
      'size': '40 g',
      'carbs': 1,
      'calories': 40,
      'category': 'Breakfast',
      'image': 'assets/images/Diary/low_fat_cottage_cheese.jpg',
    },
    {
      'name': 'Full-Fat Cottage Cheese',
      'size': '40 g',
      'carbs': 1,
      'calories': 60,
      'category': 'Breakfast',
      'image': 'assets/images/Diary/full_fat_cottage_cheese.jpg',
    },
    {
      'name': 'Cheese Manakeesh',
      'size': '100 g',
      'carbs': 52,
      'calories': 280, // Estimated
      'category': 'Breakfast',
      'image': 'assets/images/SaladsAndAppetizers/cheese_manakeesh.jpg',
    },

    {
      'name': 'Zaatar Pie',
      'size': '45 g',
      'carbs': 18,
      'calories': 130, // Estimated
      'category': 'Breakfast',
      'image': 'assets/images/SaladsAndAppetizers/Zaatar_Pie.jpg',
    },
    {
      'name': 'Cheese Pie',
      'size': '45 g',
      'carbs': 18,
      'calories': 140, // Estimated
      'category': 'Breakfast',
      'image': 'assets/images/SaladsAndAppetizers/cheese_pie.jpg',
    },
    {
      'name': 'Spinach Pie',
      'size': '50 g',
      'carbs': 18,
      'calories': 120, // Estimated
      'category': 'Breakfast',
      'image': 'assets/images/SaladsAndAppetizers/spinach_pie.jpg',
    },
    {
      'name': 'Baba Ghanoush',
      'size': '15 g',
      'carbs': 1,
      'calories': 25, // Estimated
      'category': 'Breakfast',
      'image': 'assets/images/SaladsAndAppetizers/baba_ghanoush.jpg',
    },

    {
      'name': 'Eggplant Fatteh',
      'size': '17 g',
      'carbs': 5,
      'calories': 80, // Estimated
      'category': 'Breakfast',
      'image': 'assets/images/SaladsAndAppetizers/eggplant_fatteh.jpg',
    },

    {
      'name': 'Hummus with Tahini',
      'size': '1 tablespoon (30 g)',
      'carbs': 4,
      'calories': 70, // Estimated
      'category': 'Breakfast',
      'image': 'assets/images/SaladsAndAppetizers/hummus_with_tahini.jpg',
    },

    {
      'name': 'Mutabal',
      'size': '150 g',
      'carbs': 5,
      'calories': 100, // Estimated
      'category': 'Breakfast',
      'image': 'assets/images/SaladsAndAppetizers/motabal.jpg',
    },

    {
      'name': 'Sfeeha (Meat Pastry)',
      'size': '2 pieces (150 g)',
      'carbs': 28, // Approximate
      'calories': 300, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/SaladsAndAppetizers/sofeha.jpg', // Image path
    },
// ****************************************************************************************Breakfast
    {
      'name': 'Labneh',
      'size': '2 tablespoons (50 g)',
      'carbs': 4,
      'calories': 130, // Approximate
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/plain_labneh.jpg',
    },
    {
      'name': 'Labneh',
      'size': '2 tablespoons (50 g)',
      'carbs': 4,
      'calories': 130, // Approximate
      'category': 'Dairy Products',
      'image': 'assets/images/Breakfast/plain_labneh.jpg',
    },
    {
      'name': 'Peanut Butter',
      'size': '1 tablespoon (16 g)',
      'carbs': 3,
      'calories': 90,
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/peanut_butter.png',
    },
    {
      'name': 'Strawberry Jam',
      'size': '1 tablespoon (20 g)',
      'carbs': 13,
      'calories': 55,
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/strawberry_jam.jpg',
    },
    {
      'name': 'Apricot Jam',
      'size': '1 tablespoon (20 g)',
      'carbs': 12,
      'calories': 50,
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/apricot_jam.jpg',
    },
    {
      'name': 'Honey',
      'size': '1 tablespoon (21 g)',
      'carbs': 17,
      'calories': 64,
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/honey.jpg',
    },
    {
      'name': 'Olive Oil',
      'size': '1 tablespoon (14 g)',
      'carbs': 0,
      'calories': 120,
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/olive_oil.png',
    },
    {
      'name': 'Thyme (Zaatar)',
      'size': '1 tablespoon (15 g)',
      'carbs': 4,
      'calories': 25,
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/thyme.jpg',
    },
    {
      'name': 'Chocolate Spread',
      'size': '1 tablespoon (15 g)',
      'carbs': 8,
      'calories': 80,
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/chocolate_spread.jpg',
    },
    {
      'name': 'Butter',
      'size': '1 tablespoon (14 g)',
      'carbs': 0,
      'calories': 102,
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/butter.jpg',
    },
    {
      'name': 'Butter',
      'size': '1 tablespoon (14 g)',
      'carbs': 0,
      'calories': 102,
      'category': 'Dairy Products',
      'image': 'assets/images/Breakfast/butter.jpg',
    },
    {
      'name': 'Cream Cheese Spread',
      'size': '2 tablespoons (30 g)',
      'carbs': 1,
      'calories': 100,
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/cream_cheese_spread.jpg',
    },
    {
      'name': 'Grape Jam',
      'size': '1 tablespoon (20 g)',
      'carbs': 13,
      'calories': 50,
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/grape_jam.jpg',
    },
    {
      'name': 'Orange Marmalade',
      'size': '1 tablespoon (20 g)',
      'carbs': 12,
      'calories': 49,
      'category': 'Breakfast',
      'image': 'assets/images/Breakfast/orange_marmalade.jpg',
    },
  ];

  final List<Map<String, dynamic>> selectedFoods = [];
  String selectedRatio = '10:1'; // Default carb-to-insulin ratio
  double totalCarbs = 0.0;
  double totalInsulin = 0.0;
  double totalCalories = 0.0;
  bool showResults = false; // Initially hide results

  void addToHistory() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not authenticated.")),
        );
        return;
      }

      // Convert selectedFoods list to a string
      final String selectedFoodsString = selectedFoods
          .map((food) => '${food['name']} (Quantity: ${food['quantity']})')
          .join(', ');

      await FirebaseFirestore.instance.collection('Doses').add({
        'userId': userId,
        'insulinValue': totalInsulin,
        'caloriesValue': totalCalories,
        'selectedFoods': selectedFoodsString,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data added to history successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding data to history: $e")),
      );
    }
  }

  void calculateInsulin() {
    final ratio = int.parse(selectedRatio.split(':')[0]);
    totalCarbs = selectedFoods.fold(0.0, (sum, food) {
      final carbs = food['carbs'] as int;
      final quantity = food['quantity'] as int;
      final sugar = food.containsKey('sugar') ? food['sugar'] as int : 0;
      return sum + (carbs + sugar * 4) * quantity;
    });
    totalCalories = selectedFoods.fold(0.0, (sum, food) {
      final calories = food['calories'] ?? 0;
      final quantity = food['quantity'] as int;
      return sum + (calories * quantity);
    });
    totalInsulin = totalCarbs / ratio;

    setState(() {
      showResults = true; // Show results after calculation
    });
  }

  void clearSelectedItems() {
    setState(() {
      selectedFoods.clear();
      totalCarbs = 0.0;
      totalInsulin = 0.0;
      totalCalories = 0.0;
      showResults = false; // Hide results
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredCategories = categories
          .where((category) =>
              category['label']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void addToSelectedFoods(Map<String, dynamic> food, int quantity, int sugar) {
    setState(() {
      selectedFoods.add({
        ...food,
        'quantity': quantity,
        if (food['category'] == 'Hot Drinks') 'sugar': sugar,
      });
    });
  }

  void showCategoryDialog(String category) {
    List<Map<String, dynamic>> categoryItems =
        foodItems.where((item) => item['category'] == category).toList();
    String searchQuery = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filteredItems = categoryItems
                .where((item) => item['name']
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
                .toList();

            return AlertDialog(
              title: Column(
                children: [
                  Text(category),
                  TextField(
                    onChanged: (value) {
                      setDialogState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search Items',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                height: 300,
                width: 300,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final food = filteredItems[index];
                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Distribute space evenly
                        children: [
                          Expanded(
                            flex: 2, // Allocate space for the image
                            child: Image.asset(
                              food['image'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            child: Text(
                              food['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Text(
                            'Size: ${food['size'] ?? "N/A"}', // Add size info
                            style: const TextStyle(fontSize: 10),
                          ),
                          Text(
                            'Carbs: ${food['carbs']}g', // Add carbs info
                            style: const TextStyle(fontSize: 10),
                          ),
                          Text(
                            'Calories: ${food['calories'] ?? "N/A"}', // Add calories info
                            style: const TextStyle(fontSize: 10),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: () {
                              showFoodSelectionDialog(food);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Insulin Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
            onPressed: clearSelectedItems,
            icon: const Icon(Icons.clear),
            tooltip: 'Clear All Items',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Carb-to-Insulin Ratio: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedRatio,
                  items: [
                    '6:1',
                    '7:1',
                    '8:1',
                    '9:1',
                    '10:1',
                    '11:1',
                    '12:1',
                    '13:1',
                    '14:1',
                    '15:1',
                    '16:1',
                    '17:1',
                    '18:1',
                    '19:1',
                    '20:1'
                  ]
                      .map((ratio) => DropdownMenuItem(
                            value: ratio,
                            child: Text(ratio),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRatio = value!;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline),
                  tooltip: 'What is Carb-to-Insulin Ratio?',
                  onPressed: () {
                    showCarbToInsulinRatioExplanation(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),
            Expanded(
              flex: selectedFoods.isEmpty
                  ? 3
                  : 2, // Larger space for categories initially
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      onChanged:
                          updateSearchQuery, // Call the search function on input change
                      decoration: InputDecoration(
                        labelText: 'Search Categories',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 20, // Horizontal spacing between buttons
                        runSpacing: 20, // Vertical spacing between rows
                        alignment: WrapAlignment.center,
                        children: [
                          for (var category in filteredCategories)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () =>
                                  showCategoryDialog(category['label']!),
                              child: SizedBox(
                                width: 120, // Adjust button width
                                height: 160, // Adjust button height
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      category['image']!,
                                      width: 120, // Larger image width
                                      height: 100, // Larger image height
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      category['label']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16), // Enlarge text
                                    ),
                                  ],
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

            Expanded(
              flex: selectedFoods.isEmpty
                  ? 0
                  : 1, // Dynamically grow with selected items
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: const Color.fromARGB(
                    255, 147, 225, 188), // Background color for selected items
                padding: const EdgeInsets.all(8.0),
                child: selectedFoods.isEmpty
                    ? const Center(
                        child: Text(
                            "No items selected")) // Placeholder text for empty state
                    : ListView.builder(
                        itemCount: selectedFoods.length,
                        itemBuilder: (context, index) {
                          final food = selectedFoods[index];
                          return ListTile(
                            tileColor: Colors.grey[
                                200], // Background color for each list item
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8.0), // Rounded corners
                            ),
                            title: Text(food['name']), // Display the food name
                            subtitle: Text(
                              'Quantity: ${food['quantity']}, '
                              'Carbs: ${(food['carbs'] * food['quantity']) + (food.containsKey('sugar') ? food['sugar'] * 4 : 0)}g, '
                              'Calories: ${(food['calories'] ?? 0) * food['quantity']} kcal',
                            ), // Display quantity, carbs, and calories
                            trailing: IconButton(
                              icon: const Icon(Icons
                                  .delete), // Trash can icon for removing items
                              onPressed: () {
                                setState(() {
                                  selectedFoods.removeAt(
                                      index); // Remove the selected item
                                });
                              },
                            ),
                          );
                        },
                      ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: calculateInsulin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                  child: const Text(
                    'Calculate Totals',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: addToHistory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                  child: const Text(
                    'Add to your history',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ElevatedButton(
                  onPressed: clearSelectedItems,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                  child: const Text(
                    'Clear',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),

// Results Section
            Visibility(
              visible: showResults, // Show only after calculation
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total Carbs: ${totalCarbs.toStringAsFixed(2)}g\n'
                  'Total Insulin: ${totalInsulin.toStringAsFixed(2)} units\n'
                  'Total Calories: ${totalCalories.toStringAsFixed(2)} kcal\n',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCarbToInsulinRatioExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('What is Carb-to-Insulin Ratio?'),
          content: const Text(
            'Carb-to-Insulin Ratio (CIR) is a value that helps determine the amount of insulin required to cover a certain amount of carbohydrates in a meal. '
            'For example, a CIR of 10:1 means you need 1 unit of insulin for every 10 grams of carbohydrates consumed.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void showFoodSelectionDialog(Map<String, dynamic> food) {
    int quantity = 1;
    int sugar = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Add ${food['name']}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Quantity:'),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () {
                              if (quantity > 1) {
                                setDialogState(() {
                                  quantity--;
                                });
                              }
                            },
                          ),
                          Text(quantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: () {
                              setDialogState(() {
                                quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    addToSelectedFoods(food, quantity, sugar);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
