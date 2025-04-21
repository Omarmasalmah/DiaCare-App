import 'package:diabetes/pages/ReadingsEntry.dart';
import 'package:diabetes/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'ExerciseDetailPage.dart';

class YogaExercise {
  final String title;
  final String imageUrl;
  final String videoUrl; // New field for the video URL
  final List<String> steps;
  final double met;

  YogaExercise({
    required this.title,
    required this.imageUrl,
    required this.videoUrl, // Pass video URL
    required this.steps,
    required this.met,
  });
}

// Sample List of 10+ Exercises
final List<YogaExercise> exercises = [
  YogaExercise(
    title: "Cobra Pose",
    imageUrl: "images/cobra_pose.jpg",
    videoUrl: "videos/Cobra-Pose.mp4",
    steps: [
      "Lie flat on your stomach with legs extended straight back.",
      "Place palms under your shoulders, fingers pointing forward.",
      "Press the tops of your feet and thighs into the ground.",
      "Inhale and lift your head, chest, and upper abdomen off the floor.",
      "Straighten your arms gradually if comfortable, keeping elbows soft.",
      "Open your chest, roll your shoulders back, and gaze upward.",
      "Hold the pose for 15–30 seconds while breathing deeply.",
      "Exhale slowly and lower your chest, shoulders, and head back down."
    ],
    met: 2.5,
  ),
  YogaExercise(
    title: "Seated Spinal Twist Pose",
    imageUrl: "images/seated_spinal.jpg",
    videoUrl: "videos/Seated-Spinal-Twist.mp4",
    steps: [
      "Sit on the floor with your legs extended straight in front of you.",
      "Bend your right knee and place your right foot on the outside of your left thigh.",
      "Keep your left leg extended or bend it, bringing your left foot close to your right hip.",
      "Place your right hand behind you for support and your left elbow on the outside of your right knee.",
      "Inhale and lengthen your spine, sitting up tall.",
      "Exhale and twist your torso to the right, looking over your right shoulder.",
      "Hold the pose for 20–30 seconds while breathing deeply.",
      "Release the twist and return to the starting position.",
      "Repeat on the other side by switching the leg and hand positions."
    ],
    met: 2.0,
  ),
  YogaExercise(
    title: "Child's Pose",
    imageUrl: "images/child_pose.jpg",
    videoUrl: "videos/Child-Pose.mp4",
    steps: [
      "Start on your hands and knees in a tabletop position.",
      "Spread your knees wide apart while keeping your big toes touching.",
      "Sit your hips back onto your heels.",
      "Stretch your arms forward and rest your forehead on the floor.",
      "Relax your shoulders, jaw, and neck.",
      "Breathe deeply, feeling the stretch in your hips, thighs, and lower back.",
      "Hold the pose for 30 seconds to a few minutes, depending on your comfort.",
      "To release, use your hands to push yourself back into a tabletop position."
    ],
    met: 1.8,
  ),
  YogaExercise(
    title: "Seated Forward Bend",
    imageUrl: "images/seated_forward_bend.jpg",
    videoUrl: "videos/Seated_Forward.mp4",
    steps: [
      "Begin by sitting on the floor with your legs extended straight in front of you.",
      "Keep your spine straight and your toes pointing upward.",
      "Inhale deeply, and as you exhale, slowly lean forward from your hips, not your waist.",
      "Reach for your feet, ankles, or shins, depending on your flexibility. Avoid forcing the stretch.",
      "Allow your hands to rest wherever they reach comfortably.",
      "Keep your back as flat as possible to avoid rounding your spine.",
      "Relax your shoulders, neck, and jaw.",
      "Hold the pose, breathing deeply, for 30 seconds to a few minutes.",
      "To release, inhale and slowly rise back to a seated position with a straight spine."
    ],
    met: 2.3,
  ),
  YogaExercise(
    title: "Bow Pose",
    imageUrl: "images/bow_pose.jpg",
    videoUrl: "videos/Bow-Pose.mp4",
    steps: [
      "Lie on your stomach with your feet hip-width apart and your arms at your sides.",
      "Bend your knees and bring your heels close to your buttocks.",
      "Reach back with your hands and grab your ankles. Ensure your grip is firm.",
      "Inhale and lift your chest off the ground while simultaneously lifting your thighs.",
      "Pull your legs up and back, creating a bow shape with your body.",
      "Keep your gaze forward or slightly upward. Avoid straining your neck.",
      "Hold the pose for 15-20 seconds, breathing deeply and evenly.",
      "Exhale and slowly release by lowering your chest and legs back to the ground.",
      "Rest for a few breaths before repeating if desired."
    ],
    met: 3.0,
  ),
  YogaExercise(
    title: "Cat-Cow Pose",
    imageUrl: "images/cat_cow.jpg",
    videoUrl: "videos/Cat-Cow.mp4",
    steps: [
      "Start on your hands and knees in a tabletop position. Keep your wrists directly under your shoulders and your knees under your hips.",
      "Inhale as you move into Cow Pose (Bitilasana): Drop your belly towards the mat, lift your chin and chest, and gaze upward.",
      "Broaden your shoulder blades and let your lower back gently arch.",
      "Exhale as you move into Cat Pose (Marjaryasana): Pull your belly button to your spine and round your back towards the ceiling.",
      "Tuck your chin to your chest and allow your neck to relax.",
      "Continue to alternate between Cow Pose on the inhale and Cat Pose on the exhale, moving smoothly with your breath.",
      "Repeat for 5-10 rounds, focusing on the gentle stretch and fluid motion.",
      "Finish in a neutral tabletop position, taking a few breaths to center yourself."
    ],
    met: 2.0,
  ),
  YogaExercise(
    title: "Legs Up the Wall Pose",
    imageUrl: "images/legs_up_the_wall.jpg",
    videoUrl: "videos/Triangle-Pose.mp4",
    steps: [
      "Find an empty wall space and sit sideways next to it with one hip touching the wall.",
      "Lie back as you swing your legs up against the wall, keeping your lower back and pelvis resting on the floor.",
      "Adjust your position so that your body forms an L-shape, with your legs vertical and your torso horizontal.",
      "If needed, place a folded blanket or pillow under your hips for extra support.",
      "Relax your arms by your sides, palms facing up, or rest your hands on your belly.",
      "Close your eyes and take slow, deep breaths, allowing your body to relax completely.",
      "Hold the pose for 5-15 minutes, focusing on releasing tension in your legs and back.",
      "To come out, gently bend your knees, roll to one side, and use your hands to push yourself up to a seated position."
    ],
    met: 1.5,
  ),
  YogaExercise(
    title: "Triangle Pose",
    imageUrl: "images/triangle_pose.jpg",
    videoUrl: "videos/Triangle-Pose.mp4",
    steps: [
      "Stand with your feet about 3-4 feet apart, toes pointing forward.",
      "Turn your right foot out 90 degrees so your toes point to the side, and slightly turn your left foot inwards.",
      "Raise your arms parallel to the floor, with palms facing down.",
      "Extend your torso to the right, reaching your right hand toward your right foot.",
      "Place your right hand on your shin, ankle, or the floor (whichever feels comfortable).",
      "Stretch your left arm straight up toward the ceiling, and turn your head to look at your left hand.",
      "Keep your chest open and your legs strong, avoiding any collapsing in the torso.",
      "Hold the pose for 20-30 seconds, then switch sides."
    ],
    met: 2.8,
  ),
  YogaExercise(
    title: "Plank Pose",
    imageUrl: "images/plank_pose.jpg",
    videoUrl: "videos/Plank-Pose.mp4",
    steps: [
      "Start in a tabletop position with your hands directly under your shoulders and your knees under your hips.",
      "Step both feet back, straightening your legs so your body forms a straight line from head to heels.",
      "Engage your core by pulling your navel toward your spine, and keep your back flat.",
      "Spread your fingers wide and press firmly into the floor with your palms.",
      "Avoid letting your hips sag or lifting them too high; maintain a neutral spine.",
      "Keep your gaze slightly forward, ensuring your neck stays aligned with your spine.",
      "Hold the pose for 20-60 seconds, breathing evenly throughout.",
      "To release, lower your knees gently back to the floor."
    ],
    met: 3.5,
  ),
  YogaExercise(
    title: "Boat Pose",
    imageUrl: "images/boat_pose.jpg",
    videoUrl: "videos/Boat-Pose.mp4",
    steps: [
      "Sit on the floor with your legs extended straight in front of you.",
      "Bend your knees slightly and lean back, keeping your back straight.",
      "Lift your feet off the ground so your shins are parallel to the floor.",
      "Straighten your legs, forming a 'V' shape with your body.",
      "Stretch your arms forward, parallel to the floor, palms facing each other.",
      "Engage your core and keep your chest open and your shoulders relaxed.",
      "Hold the pose for 20-30 seconds, breathing deeply.",
      "To release, slowly lower your feet back to the ground and sit upright."
    ],
    met: 3.0,
  ),
  YogaExercise(
    title: "Warrior II Pose",
    imageUrl: "images/warrior_pose.jpg",
    videoUrl: "videos/Warrior-Pose.mp4",
    steps: [
      "Stand with your feet about 3-4 feet apart, toes pointing forward.",
      "Turn your right foot out 90 degrees and your left foot in slightly.",
      "Raise your arms parallel to the floor, with palms facing down.",
      "Bend your right knee so it is directly above your ankle, forming a 90-degree angle.",
      "Keep your left leg straight and your back foot firmly grounded.",
      "Turn your head to gaze over your right hand.",
      "Keep your chest open and your shoulders relaxed.",
      "Hold the pose for 20-30 seconds, then switch sides."
    ],
    met: 3.0,
  ),
  YogaExercise(
    title: "Bridge Pose",
    imageUrl: "images/bridge_pose.jpg",
    videoUrl: "videos/Bridge-Pose.mp4",
    steps: [
      "Lie on your back with your knees bent and feet flat on the floor, hip-width apart.",
      "Place your arms alongside your body, palms facing down.",
      "Press your feet and arms into the floor and lift your hips toward the ceiling.",
      "Roll your shoulders underneath you to open your chest further.",
      "Clasp your hands under your back for added support if comfortable.",
      "Engage your glutes and thighs while keeping your knees aligned with your hips.",
      "Hold the pose for 20-30 seconds, breathing deeply.",
      "To release, slowly lower your hips back to the floor vertebra by vertebra."
    ],
    met: 2.5,
  ),
];

class DiabetesYogaListPage extends StatelessWidget {
  const DiabetesYogaListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yoga Exercises",
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 182, 206, 224),
        child: ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return GestureDetector(
              onTap: () {
                // Navigate to the ExerciseDetailPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ExerciseDetailPage(exercise: exercise),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          exercise.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: Image.asset(
                        exercise.imageUrl,
                        width: 150,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle SOS button action
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("SOS"),
                content: const Text("SOS button pressed!"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.warning, size: 30),
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
                            HomeScreen()), // Replace HomeScreen with your actual home screen widget
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
                            HomeScreen()), // Replace ReadingsEntry with your actual readings entry screen widget
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
                            DiabetesPage()), // Replace HomeScreen with your actual home screen widget
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
