import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/Cloudinary.dart';
import 'package:diabetes/constants.dart';
import 'package:diabetes/models/message.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  static String id = 'ChatPage';

  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = ScrollController();
  final TextEditingController controller = TextEditingController();
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);

  String? recipientEmail;
  String recipientName = 'No Name';
  String recipientProfileImageUrl = '';

  String? conversationId;
  File? selectedFile;

  final currentUser = FirebaseAuth.instance.currentUser?.email;

  String generateConversationId(String user1, String user2) {
    List<String> users = [user1, user2];
    users.sort(); // Alphabetical order
    return users.join('_');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args == null || args['email'] == null) {
        // Handle missing arguments gracefully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipient email is missing.')),
        );
        Navigator.pop(context); // Navigate back to prevent further issues
        return;
      }

      final currentUser = FirebaseAuth.instance.currentUser?.email;
      if (currentUser != null) {
        setState(() {
          recipientEmail = args['email'];
          recipientName = args['name'] ?? 'No Name';
          recipientProfileImageUrl =
              args['profileImage'] ?? 'images/NoProfilePic.png';
          conversationId = generateConversationId(currentUser, recipientEmail!);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedFile = File(image.path);
      await uploadFile();
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      selectedFile = File(result.files.single.path!);
      await uploadFile();
    }
  }

  Future<void> uploadFile() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected')),
      );
      return;
    }

    try {
      String fileType = selectedFile!.path.endsWith('.jpg') ||
              selectedFile!.path.endsWith('.png')
          ? 'image'
          : 'raw';
      String? uploadUrl =
          await CloudinaryService.uploadFile(selectedFile!, fileType);

      if (uploadUrl != null) {
        controller.text = uploadUrl; // Display the file URL in the text field
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File uploaded successfully!')),
        );
      } else {
        throw Exception('Upload failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload file: $e')),
      );
    }
  }

  void _sendMessage(String data) async {
    if (data.trim().isEmpty) return;

    try {
      await messages.add({
        'message': data,
        'type': 'text', // Indicate that this is a text message
        'createdAt': DateTime.now(),
        'senderId': currentUser,
        'receiverId': recipientEmail,
        'conversationId': conversationId,
      });
      controller.clear();
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300], // Placeholder background color
              backgroundImage: (recipientProfileImageUrl != null &&
                      recipientProfileImageUrl.isNotEmpty)
                  ? NetworkImage(recipientProfileImageUrl)
                  : const AssetImage('images/NoProfilePic.png')
                      as ImageProvider,
            ),
            const SizedBox(width: 12),
            Text(
              recipientName,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 58, 140, 85),
                Color.fromARGB(255, 25, 106, 48)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: conversationId != null
                  ? messages
                      .where('conversationId', isEqualTo: conversationId)
                      .orderBy('createdAt', descending: true)
                      .snapshots()
                  : null, // Prevent building without a conversation ID
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  List<Message> messagesList = snapshot.data!.docs
                      .map((doc) => Message.fromJson(doc))
                      .toList();

                  return ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      final message = messagesList[index];
                      return message.senderId == currentUser
                          ? ChatBuble(message: message)
                          : ChatBubleForFriend(message: message);
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No messages yet. Start a conversation!',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Material(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
            child: IconButton(
              icon: const Icon(Icons.photo, color: Colors.teal),
              onPressed: () {
                //print("Pick image");
                pickImage();
              },
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
            child: IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.teal),
              onPressed: () {
                //print("Pick file");
                pickFile();
              }, //_pickFile,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (data) => _sendMessage(data),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Type your message...',
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _sendMessage(controller.text),
            child: CircleAvatar(
              backgroundColor: Colors.teal,
              radius: 24,
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
/*
  void _sendMessage(String data) async {
    if (data.trim().isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser?.email;
    if (conversationId == null ||
        recipientEmail == null ||
        currentUser == null) {
      print('Cannot send message: Invalid conversation or user data');
      return;
    }

    try {
      await messages.add({
        'message': data,
        'createdAt': DateTime.now(),
        'senderId': currentUser,
        'receiverId': recipientEmail,
        'conversationId': conversationId,
      });
      controller.clear();
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }*/
}

/// Chat Bubble for Current User
/// Chat Bubble for Current User
class ChatBuble extends StatelessWidget {
  final Message message;

  const ChatBuble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.imageUrl.isNotEmpty)
              Image.network(message.imageUrl, height: 200, fit: BoxFit.cover),
            if (message.attachmentUrl.isNotEmpty)
              TextButton.icon(
                icon: const Icon(Icons.file_present),
                label: const Text('Open Attachment'),
                onPressed: () {
                  // Handle attachment opening
                },
              ),
            if (message.message.isNotEmpty)
              Text(
                message.message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}

/// Chat Bubble for Recipient
class ChatBubleForFriend extends StatelessWidget {
  final Message message;

  const ChatBubleForFriend({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Text(
          message.message, // Updated to access 'message'
          style: const TextStyle(color: Colors.black87, fontSize: 18),
        ),
      ),
    );
  }
}
