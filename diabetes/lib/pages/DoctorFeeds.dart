import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/Cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:diabetes/NavBar.dart';
import 'package:diabetes/pages/UserListPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:firebase_storage/firebase_storage.dart';

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

      setState(() {
        _userPosts = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'postId': doc.id,
            'text': data['text'] ?? '',
            'image': data['image'],
            'video': data['video'],
            'document': data['document'],
            'likes': data['likes'] ?? 0,
            'isLiked': data['isLiked'] ?? false,
            'createdAt': data['createdAt'],
            'userId': data['userId'],
          };
        }).toList();
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
      appBar: AppBar(title: const Text('Doctors Feed')),
      body: ListView.builder(
        itemCount: _userPosts.length,
        itemBuilder: (context, index) {
          final post = _userPosts[index];
          final imageUrl = post['image'];
          final videoUrl = post['video'];
          final document = post['document'];

          return FutureBuilder<String>(
            future: _fetchDoctorName(post['userId']),
            builder: (context, snapshot) {
              String doctorPostName = snapshot.data ?? "Loading...";
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dr. $doctorPostName"),
                      if (post['text'] != null) Text(post['text']),
                      if (imageUrl != null && imageUrl.startsWith('http'))
                        Image.network(imageUrl, height: 150, fit: BoxFit.cover)
                      else if (imageUrl != null)
                        Image.file(File(imageUrl)),
                      if (videoUrl != null && videoUrl.startsWith('http'))
                        FutureBuilder<VideoPlayerController?>(
                          future: _initializeVideo(videoUrl),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (!snapshot.hasData || snapshot.data == null) {
                              return const Text("Error loading video");
                            }
                            VideoPlayerController videoController =
                                snapshot.data!;
                            return Column(
                              children: [
                                AspectRatio(
                                  aspectRatio:
                                      videoController.value.aspectRatio,
                                  child: VideoPlayer(videoController),
                                ),
                                VideoProgressIndicator(videoController,
                                    allowScrubbing: true),
                              ],
                            );
                          },
                        ),
                      if (document != null)
                        ListTile(
                          leading: const Icon(Icons.insert_drive_file,
                              color: Colors.orange),
                          title: Text(document.split('/').last),
                          onTap: () => _openDocument(document),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${post['likes']} likes'),
                          IconButton(
                            icon: Icon(Icons.favorite,
                                color:
                                    post['isLiked'] ? Colors.red : Colors.grey),
                            onPressed: () => _likePost(index),
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
    );
  }
}
