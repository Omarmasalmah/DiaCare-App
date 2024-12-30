import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/chatBuble.dart';
import 'package:diabetes/constants.dart';
import 'package:diabetes/models/message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  static String id = 'ChatPage';

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

  final currentUser = FirebaseAuth.instance.currentUser?.email;

  String generateConversationId(String user1, String user2) {
    List<String> users = [user1, user2];
    users.sort(); // Alphabetical order
    return users.join('_');
  }

  String? conversationId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args == null || args['email'] == null) {
        // Handle missing arguments gracefully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recipient email is missing.')),
        );
        Navigator.pop(context); // Navigate back to prevent further issues
        return;
      }

      final currentUser = FirebaseAuth.instance.currentUser?.email;
      if (currentUser != null) {
        setState(() {
          recipientEmail = args['email'];
          recipientName = args['name'] ?? 'No Name';
          conversationId = generateConversationId(currentUser, recipientEmail!);
          print('Conversation ID: $conversationId'); // Debugging log

          // Debugging logs
          print('Current User: $currentUser');
          print('Recipient Email: $recipientEmail');
          print('Conversation ID: $conversationId');
        });
      } else {
        print('Current user is null');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Chat with $recipientName',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
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
                  return Center(child: CircularProgressIndicator());
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
                  return Center(child: Text('No messages yet.'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (data) => _sendMessage(data),
                    decoration: InputDecoration(
                      hintText: 'Send Message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _sendMessage(controller.text),
                  child: Icon(
                    Icons.send,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }
}
