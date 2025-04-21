import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/Cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:diabetes/NavBar.dart';
import 'package:diabetes/pages/UserListPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  XFile? _video;
  PlatformFile? _document; // Use PlatformFile instead of String
  final TextEditingController _controller = TextEditingController();
  VideoPlayerController? _previewVideoController;
  List<Map<String, dynamic>> _userPosts = []; // Make _userPosts non-final
  String doctorName = 'Loading . . .';
  String? currentUserId;
  String? imageUrl;
  String? videoUrl;
  String? documentUrl;

  @override
  void initState() {
    super.initState();
    fetchDoctorName();
    fetchPosts();
    getCurrentUserId();
  }

  Future<void> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid; // Store current user ID
      });
    }
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DateTime now = DateTime.now();
        DateTime startOfWeek = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: now.weekday - 1));

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('posts')
            // .where('userId', isEqualTo: user.uid)
            .where('createdAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
            .orderBy('createdAt', descending: true) // Ensures proper sorting
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
              'videoController': data['videoController'],
              'likes': data['likes'] ?? 0,
              'isLiked': data['isLiked'] ?? false,
              'createdAt': data['createdAt'],
              'userId': data['userId'],
            };
          }).toList();
        });
      } catch (e) {
        print('Error fetching posts: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching posts: $e')),
        );
      }
    }
  }

  Future<void> storePost(Map<String, dynamic> post) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        print("🚀 Uploading files to Firebase Storage...");

        // Show progress dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text("Uploading"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Please wait while we upload your post...")
                ],
              ),
            );
          },
        );

        // Future<String?> uploadFile(Reference ref, dynamic file) async {
        //   UploadTask uploadTask;
        //   if (kIsWeb) {
        //     Uint8List? fileBytes = file.bytes;
        //     if (fileBytes == null) return null;
        //     uploadTask = ref.putData(fileBytes);
        //   } else {
        //     String? filePath = file.path;
        //     if (filePath == null) return null;
        //     uploadTask = ref.putFile(File(filePath));
        //   }

        //   // Set a timeout for 30 seconds
        //   TaskSnapshot snapshot = await uploadTask.timeout(
        //     const Duration(seconds: 30),
        //     onTimeout: () {
        //       throw Exception(
        //           "❌ Upload timeout: File took too long to upload.");
        //     },
        //   );

        //   return await snapshot.ref.getDownloadURL();
        // }

        // // Upload image if available
        // if (post['image'] != null) {
        //   final imageRef = FirebaseStorage.instance
        //       .ref()
        //       .child('posts/${user.uid}/images/${post['image'].name}');
        //   imageUrl = await uploadFile(imageRef, post['image']);
        // }

        // // Upload video if available
        // if (post['video'] != null) {
        //   final videoRef = FirebaseStorage.instance
        //       .ref()
        //       .child('posts/${user.uid}/videos/${post['video'].name}');
        //   videoUrl = await uploadFile(videoRef, post['video']);
        // }

        // // Upload document if available
        // if (post['document'] != null) {
        //   final documentRef = FirebaseStorage.instance
        //       .ref()
        //       .child('posts/${user.uid}/documents/${post['document'].name}');
        //   documentUrl = await uploadFile(documentRef, post['document']);
        // }

        if (post['image'] != null) {
          print("Uploading image...");
          if (kIsWeb) {
            Uint8List imageBytes = await post['image'].readAsBytes();
            imageUrl = await CloudinaryService.uploadBytes(imageBytes, "image");
          } else {
            imageUrl = await CloudinaryService.uploadFile(
                File(post['image'].path), "image");
          }
          print("Image uploaded: $imageUrl");
        }
        if (post['video'] != null) {
          print("Uploading video...");
          if (kIsWeb) {
            Uint8List videoBytes = await post['video'].readAsBytes();
            videoUrl = await CloudinaryService.uploadBytes(videoBytes, "video");
          } else {
            videoUrl = await CloudinaryService.uploadFile(
                File(post['video'].path), "video");
          }
          print("Video uploaded: $videoUrl");
        }

        if (post['document'] != null) {
          print("Uploading document...");
          documentUrl = await CloudinaryService.uploadFile(
              kIsWeb
                  ? post['document']
                  : (post['document'] is PlatformFile
                      ? post['document']
                      : File(post['document'].path)),
              "raw");
          print("Document uploaded: $documentUrl");
        }
        // Close the upload dialog
        Navigator.pop(context);

        print("✅ Uploads completed. Saving post in Firestore...");

        // Store post in Firestore
        await FirebaseFirestore.instance.collection('posts').add({
          'text': post['text'],
          'image': imageUrl,
          'video': videoUrl,
          'document': documentUrl,
          'videoController': post['videoController']?.value?.toString(),
          'likes': post['likes'],
          'createdAt': FieldValue.serverTimestamp(),
          'userId': user.uid,
        });

        print("✅ Post stored successfully in Firestore!");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post successfully stored!')),
        );
      } catch (e) {
        Navigator.pop(context); // Close upload dialog if error occurs
        print("❌ Error storing post: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error storing post: $e')),
        );
      }
    }
  }

  Future<void> _deletePost(String postId, int index) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      setState(() {
        _userPosts.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting post: $e')),
      );
    }
  }

  // Pick a photo
  Future<void> _pickPhoto() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage; // No need for casting
      });
    }
  }

  // Pick a video
  Future<void> _pickVideo() async {
    final XFile? pickedVideo =
        await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      setState(() {
        _video = pickedVideo;
      });

      if (kIsWeb) {
        Uint8List videoBytes = await pickedVideo.readAsBytes();

        // Upload video to Cloudinary first
        String? videoUrl =
            await CloudinaryService.uploadBytes(videoBytes, "video");

        if (videoUrl != null) {
          print("Video uploaded: $videoUrl");
          setState(() {
            _previewVideoController = VideoPlayerController.network(videoUrl)
              ..initialize().then((_) {
                setState(() {});
                _previewVideoController!.play();
              });
          });
        }
      } else {
        _previewVideoController =
            VideoPlayerController.file(File(pickedVideo.path))
              ..initialize().then((_) {
                setState(() {});
              });
      }
    }
  }

  // Pick a document (Attachment)
  // Pick a document (Attachment)
  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile selectedFile = result.files.first;

        setState(() {
          _document = selectedFile; // Store the PlatformFile object
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Document selected: ${selectedFile.name}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking document: $e')),
      );
    }
  }

  // Open a document using url_launcher
  Future<void> _openDocument(String filePath) async {
    final Uri uri = Uri.file(filePath); // Convert file path to Uri
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open file.')),
      );
    }
  }

  // Add likes functionality
  void _likePost(int index) {
    setState(() {
      // Toggle the isLiked status
      _userPosts[index]['isLiked'] = !_userPosts[index]['isLiked'];

      // Update the likes count based on the isLiked status
      if (_userPosts[index]['isLiked']) {
        _userPosts[index]['likes']++;
      } else {
        _userPosts[index]['likes']--;
      }
    });
  }

  // Post the feed
  void _postFeed() async {
    String text = _controller.text;

    if (text.isEmpty && _image == null && _video == null && _document == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add content to your post.')),
      );
      return;
    }

    print("Attempting to submit post...");

    Uint8List? videoBytes;
    String? videoUrl;

    if (kIsWeb && _video != null) {
      videoBytes = await _video!.readAsBytes();
      videoUrl = await CloudinaryService.uploadBytes(videoBytes, "video");
    }

    // Initialize video controller for web
    VideoPlayerController? videoController;
    if (videoUrl != null) {
      videoController = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          setState(() {});
          videoController!.play();
        });
    }

    final newPost = {
      'text': text,
      'image': _image,
      'video': videoUrl, // Store only URL
      'videoController': videoController, // Store the controller object
      'likes': 0,
      'isLiked': false,
      'doctorName': doctorName,
    };

    try {
      print("Storing post...");
      await storePost(newPost);
      print("Post stored successfully!");

      // Refresh the page automatically after posting
      Future.delayed(const Duration(milliseconds: 100), () async {
        await fetchPosts(); // Fetch updated posts
      });

      setState(() {
        _userPosts.insert(0, newPost);
        _controller.clear();
        _image = null;
        _video = null;
        _document = null;
        _previewVideoController?.dispose();
        _previewVideoController = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post successfully submitted!')),
      );
    } catch (e) {
      print("Error submitting post: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting post: $e')),
      );
    }
  }

  Future<String> _fetchDoctorName(String? userId) async {
    if (userId == null) return "Unknown Doctor"; // Handle missing userId

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users') // Your users collection
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc['name'] ??
            "Doctor Name Missing"; // Return the doctor’s name
      } else {
        return "Doctor Not Found"; // Handle case if user doesn't exist
      }
    } catch (e) {
      print("Error fetching doctor name: $e");
      return "Error Fetching Name"; // Return error message if fetching fails
    }
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
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Feed',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        centerTitle: true,
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Color.fromARGB(255, 11, 111, 188)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.facebookMessenger),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserListPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Post Feed Box
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              "D",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Dr. $doctorName",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _controller,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "What's on your mind?",
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.photo,
                                color: Colors.blueAccent),
                            onPressed: _pickPhoto,
                          ),
                          IconButton(
                            icon: const Icon(Icons.video_library,
                                color: Colors.green),
                            onPressed: _pickVideo,
                          ),
                          IconButton(
                            icon: const Icon(Icons.attach_file,
                                color: Colors.orange),
                            onPressed: _pickDocument,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            onPressed: _postFeed,
                            child: const Text('Post',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Preview Section
                      if (_image != null)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  Dialog(child: Image.file(File(_image!.path))),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Image.file(
                              File(_image!.path),
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (_video != null &&
                          _previewVideoController != null &&
                          _previewVideoController is VideoPlayerController)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: _previewVideoController!.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _previewVideoController!
                                      .value.aspectRatio,
                                  child: VideoPlayer(_previewVideoController!),
                                )
                              : Container(),
                        ),

                      if (_document != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListTile(
                            leading: const Icon(Icons.insert_drive_file,
                                color: Colors.orange),
                            title: Text(documentUrl!
                                .split('/')
                                .last), // ✅ Extract the file name from the URL
                            onTap: () {
                              _openDocument(_document!.path!);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),

            // Feeds List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _userPosts.length,
              itemBuilder: (context, index) {
                final post = _userPosts[index];
                // final videoController = post['videoController'];
                final document = post['document'];
                final String? videoUrl = post['video']; // Ensure it's a String
                final String? userId =
                    post['userId']; // Get the doctor's userId who posted

                // // ✅ Initialize video controller only if videoUrl exists
                // VideoPlayerController? videoController;
                // if (videoUrl != null) {
                //   videoController = VideoPlayerController.network(videoUrl)
                //     ..initialize().then((_) {
                //       setState(() {}); // Refresh UI when video is ready
                //     });
                // }

                return FutureBuilder<String>(
                    future: _fetchDoctorName(userId),
                    builder: (context, snapshot) {
                      String doctorPostName = snapshot.data ??
                          "Loading..."; // Default if not loaded yet

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: Colors.blueAccent,
                                      child: Text(
                                        "D",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Dr. $doctorPostName",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Spacer(),

                                    // Delete Button for User's Posts
                                    // if (userId == currentUserId)
                                    //   IconButton(
                                    //     icon: const Icon(Icons.delete,
                                    //         color: Colors.red),
                                    //     onPressed: () {
                                    //       showDialog(
                                    //         context: context,
                                    //         builder: (BuildContext context) {
                                    //           return AlertDialog(
                                    //             title:
                                    //                 const Text('Delete Post'),
                                    //             content: const Text(
                                    //                 'Are you sure you want to delete this post?'),
                                    //             actions: <Widget>[
                                    //               TextButton(
                                    //                 child: const Text('Cancel'),
                                    //                 onPressed: () {
                                    //                   Navigator.of(context)
                                    //                       .pop(); // Close the dialog
                                    //                 },
                                    //               ),
                                    //               TextButton(
                                    //                 child: const Text('Yes'),
                                    //                 onPressed: () {
                                    //                   Navigator.of(context)
                                    //                       .pop(); // Close the dialog
                                    //                   _deletePost(
                                    //                       post['postId'],
                                    //                       index); // Delete the post
                                    //                 },
                                    //               ),
                                    //             ],
                                    //           );
                                    //         },
                                    //       );
                                    //     },
                                    //   ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                if (post['text'] != null &&
                                    post['text'].isNotEmpty)
                                  Text(post['text'],
                                      style: const TextStyle(fontSize: 16)),
                                if (post['image'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Image.network(post['image'],
                                        height: 150, fit: BoxFit.cover),
                                  ),
                                if (videoUrl != null)
                                  FutureBuilder<VideoPlayerController?>(
                                    future: _initializeVideo(videoUrl),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }

                                      if (!snapshot.hasData ||
                                          snapshot.data == null) {
                                        return const Center(
                                            child: Text("Error loading video"));
                                      }

                                      VideoPlayerController videoController =
                                          snapshot.data!; // Safe unwrap

                                      return Column(
                                        children: [
                                          AspectRatio(
                                            aspectRatio: videoController
                                                .value.aspectRatio,
                                            child: VideoPlayer(videoController),
                                          ),
                                          VideoProgressIndicator(
                                              videoController,
                                              allowScrubbing: true),
                                        ],
                                      );
                                    },
                                  ),
                                if (document != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ListTile(
                                      leading: const Icon(
                                          Icons.insert_drive_file,
                                          color: Colors.orange),
                                      title: Text(document.split('/').last),
                                      onTap: () {
                                        _openDocument(document.path!);
                                      },
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${post['likes']} likes',
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                    IconButton(
                                      icon: Icon(Icons.favorite,
                                          color: post['isLiked']
                                              ? Colors.red
                                              : Colors.grey),
                                      onPressed: () => _likePost(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
