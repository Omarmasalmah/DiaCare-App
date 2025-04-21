import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/Cloudinary.dart';
import 'package:diabetes/pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:diabetes/NavBar.dart';
import 'package:diabetes/pages/UserListPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:diabetes/pages/DiabetesYogaListPage.dart';
import 'package:diabetes/pages/DoctorFeeds.dart';
import 'package:diabetes/pages/ReadingsEntry.dart';
import 'package:diabetes/pages/UserListPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diabetes/NavBar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async'; // Import dart:async for StreamSubscription
// import pedometer: ^4.0.2
import 'package:pedometer/pedometer.dart';
import 'package:diabetes/main.dart';
import 'package:diabetes/NotificationService.dart';
import 'package:diabetes/pages/custom_chart_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:diabetes/pages/Google_map.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class DoctorFeeds extends StatefulWidget {
  const DoctorFeeds({super.key});

  @override
  _DoctorFeedsState createState() => _DoctorFeedsState();
}

class _DoctorFeedsState extends State<DoctorFeeds> {
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> _userPosts = [];
  String doctorName = 'Loading . . .';

  @override
  void initState() {
    super.initState();
    fetchDoctorName();
    fetchPosts();
  }

  Future<void> fetchDoctorName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          doctorName = data['name'] ?? 'Loading . . .';
        });
      }
    }
  }

  Future<void> fetchPosts() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> posts = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String userId = data['userId'];

        // Fetch doctor name before building the list
        String doctorName = await _fetchDoctorName(userId);

        posts.add({
          'postId': doc.id,
          'text': data['text'] ?? '',
          'image': data['image'],
          'video': data['video'],
          'document': data['document'],
          'likes': data['likes'] ?? 0,
          'isLiked': data['isLiked'] ?? false,
          'createdAt': data['createdAt'],
          'userId': userId,
          'doctorName': doctorName, // Store doctor name
        });
      }

      setState(() {
        _userPosts = posts;
      });
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  Future<String> _fetchDoctorName(String? userId) async {
    if (userId == null) return "Unknown Doctor";
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        return userDoc['name'] ?? "Doctor Name Missing";
      } else {
        return "Doctor Not Found";
      }
    } catch (e) {
      print("Error fetching doctor name: $e");
      return "Error Fetching Name";
    }
  }

  Future<void> _openDocument(String filePath) async {
    final Uri uri = Uri.file(filePath);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      print("Could not open file: $filePath");
    }
  }

  void _likePost(int index) {
    setState(() {
      _userPosts[index]['isLiked'] = !_userPosts[index]['isLiked'];
      _userPosts[index]['likes'] += _userPosts[index]['isLiked'] ? 1 : -1;
    });
  }

  Future<VideoPlayerController?> _initializeVideo(String videoUrl) async {
    try {
      VideoPlayerController videoController =
          VideoPlayerController.network(videoUrl);
      await videoController.initialize();
      return videoController;
    } catch (e) {
      print("Error initializing video: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const NavBar(),
      appBar: AppBar(
          title:
              const Text('Doctors Feed', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 54, 117, 244)),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 10), // Add padding
        itemCount: _userPosts.length,
        itemBuilder: (context, index) {
          final post = _userPosts[index];
          final imageUrl = post['image'];
          final videoUrl = post['video'];
          final document = post['document'];
          final doctorName = post['doctorName'];
          print("Doctor Name: $doctorName");

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('Users')
                .doc(post['userId'])
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              String doctorPostName = "Unknown Doctor";

              String? doctorProfileImage;

              if (snapshot.hasData && snapshot.data!.exists) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                // doctorPostName = userData['name'] ?? "Unknown Doctor";
                doctorPostName = doctorName;
                doctorProfileImage =
                    userData['profileImage']; // Doctor's profile image
              }

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin:
                    const EdgeInsets.only(bottom: 12), // Space between posts
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Doctor Profile Section
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.teal,
                            radius: 24,
                            backgroundImage: (doctorProfileImage != null &&
                                    doctorProfileImage.isNotEmpty)
                                ? NetworkImage(doctorProfileImage)
                                : null, // Set image if available
                            child: (doctorProfileImage == null ||
                                    doctorProfileImage.isEmpty)
                                ? const Icon(Icons.person,
                                    color: Colors.white,
                                    size: 28) // Default person icon
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Dr. $doctorPostName",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // 🔹 Post Text
                      if (post['text'] != null)
                        Text(
                          post['text'],
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),

                      const SizedBox(height: 10),

                      // 🔹 Post Image
                      if (imageUrl != null && imageUrl.startsWith('http'))
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else if (imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(File(imageUrl)),
                        ),

                      const SizedBox(height: 10),

                      // 🔹 Post Video
                      if (videoUrl != null && videoUrl.startsWith('http'))
                        FutureBuilder<VideoPlayerController?>(
                          future: _initializeVideo(videoUrl),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data == null) {
                              return const Text("Error loading video");
                            }
                            VideoPlayerController videoController =
                                snapshot.data!;
                            return Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AspectRatio(
                                    aspectRatio:
                                        videoController.value.aspectRatio,
                                    child: VideoPlayer(videoController),
                                  ),
                                ),
                                VideoProgressIndicator(videoController,
                                    allowScrubbing: true),
                              ],
                            );
                          },
                        ),

                      const SizedBox(height: 10),

                      // 🔹 Attached Document
                      if (document != null)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.insert_drive_file,
                              color: Colors.orange),
                          title: Text(
                            document.split('/').last,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.blue),
                          ),
                          onTap: () => _openDocument(document),
                        ),

                      const SizedBox(height: 10),

                      // 🔹 Like & Interaction Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${post['likes']} likes',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () => _likePost(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: post['isLiked']
                                    ? Colors.red.shade100
                                    : Colors.grey.shade200,
                              ),
                              child: Icon(
                                Icons.favorite,
                                color:
                                    post['isLiked'] ? Colors.red : Colors.grey,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
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
                content:
                    const Text("Are you sure you want to send an SOS alert?"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: const Text("Send SOS"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      //    _sendSOS(context); // Call function to send SOS
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
        notchMargin: 6.0,
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
                            const HomeScreen()), // Replace HomeScreen with your actual home screen widget
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
                            const DoctorFeeds()), // Replace ReadingsEntry with your actual readings entry screen widget
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.location_pin,
                    color: Colors.white, size: 34),
                onPressed: () {
                  // Navigate to the home screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GoogleMaps()), // Replace HomeScreen with your actual home screen widget
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
