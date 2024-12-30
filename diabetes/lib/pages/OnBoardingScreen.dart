import 'package:diabetes/pages/login.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "images/welcome.png",
      "title": "Welcome to DiaCare",
      "description":
          "Take control of your health with DiaCare! Our app provides personalized tools to help you manage diabetes effectively. Enjoy easy tracking, health insights, and reminders, all in one convenient and user-friendly platform."
    },
    {
      "image": "images/track.png",
      "title": "Track Glucose & Health",
      "description":
          "Monitor your blood glucose levels with precision and ease. Stay informed with long-term trend graphs, log your meals, and keep track of your physical activities to achieve your health goals efficiently."
    },
    {
      "image": "images/remind.png",
      "title": "Set Reminders",
      "description":
          "Never miss a dose or appointment again! Receive timely reminders for your medications, insulin doses, and scheduled doctor visits to ensure seamless health management."
    },
    {
      "image": "images/newdoctor.png",
      "title": "Connect with Your Doctor",
      "description":
          "Stay in touch with your healthcare provider anytime, anywhere. Get professional advice, share your progress, and receive tailored recommendations to improve your treatment outcomes."
    },
    {
      "image": "images/newsport.png",
      "title": "Fitness & Well-being",
      "description":
          "Adopt a healthier lifestyle with DiaCare! Track your workouts, monitor fitness goals, and maintain an active routine to enhance your physical and mental well-being."
    },
  ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color.fromARGB(255, 60, 185, 60),
//               Color.fromARGB(255, 64, 137, 173),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: Stack(
//                 children: [
//                   PageView.builder(
//                     controller: _pageController,
//                     itemCount: onboardingData.length,
//                     onPageChanged: (index) {
//                       setState(() {
//                         _currentPage = index;
//                       });
//                     },
//                     itemBuilder: (context, index) {
//                       return OnboardingContent(
//                         image: onboardingData[index]["image"]!,
//                         title: onboardingData[index]["title"]!,
//                         description: onboardingData[index]["description"]!,
//                       );
//                     },
//                   ),
//                   Positioned(
//                     bottom: 20,
//                     left: 0,
//                     right: 0,
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: List.generate(
//                             onboardingData.length,
//                             (index) =>
//                                 AnimatedDot(isActive: index == _currentPage),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             if (_currentPage > 0)
//                               TextButton(
//                                 onPressed: () {
//                                   _pageController.previousPage(
//                                     duration: const Duration(milliseconds: 500),
//                                     curve: Curves.ease,
//                                   );
//                                 },
//                                 child: const Text(
//                                   "Back",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             if (_currentPage < onboardingData.length - 1)
//                               Expanded(
//                                 child: Align(
//                                   alignment: Alignment.centerRight,
//                                   child: TextButton(
//                                     onPressed: () {
//                                       _pageController.nextPage(
//                                         duration:
//                                             const Duration(milliseconds: 500),
//                                         curve: Curves.ease,
//                                       );
//                                     },
//                                     child: const Text(
//                                       "Next",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             if (_currentPage == onboardingData.length - 1)
//                               Positioned(
//                                 bottom:
//                                     40, // Adjust this value to change vertical placement
//                                 left: 0,
//                                 right: 0,
//                                 child: Center(
//                                   child: TextButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const LogIn()),
//                                       );
//                                     },
//                                     style: TextButton.styleFrom(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 40,
//                                         vertical: 15,
//                                       ),
//                                       backgroundColor: Colors
//                                           .transparent, // Ensure no background color
//                                     ),
//                                     child: const Text(
//                                       "Get Started",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 60, 185, 60),
              Color.fromARGB(255, 64, 137, 173),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return OnboardingContent(
                        image: onboardingData[index]["image"]!,
                        title: onboardingData[index]["title"]!,
                        description: onboardingData[index]["description"]!,
                      );
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            onboardingData.length,
                            (index) =>
                                AnimatedDot(isActive: index == _currentPage),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentPage > 0)
                              TextButton(
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                },
                                child: const Text(
                                  "Back",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            if (_currentPage < onboardingData.length - 1)
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      _pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease,
                                      );
                                    },
                                    child: const Text(
                                      "Next",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_currentPage == onboardingData.length - 1)
                    Positioned(
                      bottom:
                          40, // Adjust this value to change vertical placement
                      left: 0,
                      right: 0,
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LogIn()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            backgroundColor: Colors
                                .transparent, // Ensure no background color
                          ),
                          child: const Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingContent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 300,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 30),
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class AnimatedDot extends StatelessWidget {
  final bool isActive;

  const AnimatedDot({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10,
      width: isActive ? 20 : 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white70,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
