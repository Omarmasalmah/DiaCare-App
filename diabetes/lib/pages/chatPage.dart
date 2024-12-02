// // import 'package:diabetes/chatBuble.dart';
// // import 'package:diabetes/constants.dart';
// // import 'package:diabetes/models/message.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class ChatPage extends StatelessWidget {
// //   static String id = 'ChatPage';

// //   final _controller = ScrollController();

// //   CollectionReference messages =
// //       FirebaseFirestore.instance.collection(kMessagesCollections);
// //   TextEditingController controller = TextEditingController();
// //   @override
// //   Widget build(BuildContext context) {
// //     var email = ModalRoute.of(context)!.settings.arguments;
// //     return StreamBuilder<QuerySnapshot>(
// //       stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
// //       builder: (context, snapshot) {
// //         if (snapshot.hasData) {
// //           List<Message> messagesList = [];
// //           for (int i = 0; i < snapshot.data!.docs.length; i++) {
// //             messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
// //           }

// //           return Scaffold(
// //             backgroundColor: Colors.white,
// //             appBar: AppBar(
// //               automaticallyImplyLeading: false,
// //               backgroundColor: kPrimaryColor,
// //               title: Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   // Image.asset(
// //                   //   kLogo,
// //                   //   height: 50,
// //                   // ),
// //                   Text('chat'),
// //                 ],
// //               ),
// //               centerTitle: true,
// //             ),
// //             body: Column(
// //               children: [
// //                 Expanded(
// //                   child: ListView.builder(
// //                       reverse: true,
// //                       controller: _controller,
// //                       itemCount: messagesList.length,
// //                       itemBuilder: (context, index) {
// //                         return messagesList[index].id == email
// //                             ? ChatBuble(
// //                                 message: messagesList[index],
// //                               )
// //                             : ChatBubleForFriend(message: messagesList[index]);
// //                       }),
// //                 ),
// //                 Padding(
// //                   padding: const EdgeInsets.all(16),
// //                   child: TextField(
// //                     controller: controller,
// //                     onSubmitted: (data) {
// //                       messages.add(
// //                         {
// //                           kMessage: data,
// //                           kCreatedAt: DateTime.now(),
// //                           'id': email
// //                         },
// //                       );
// //                       controller.clear();
// //                       _controller.animateTo(0,
// //                           duration: Duration(milliseconds: 500),
// //                           curve: Curves.easeIn);
// //                     },
// //                     decoration: InputDecoration(
// //                       hintText: 'Send Message',
// //                       suffixIcon: Icon(
// //                         Icons.send,
// //                         color: kPrimaryColor,
// //                       ),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(16),
// //                       ),
// //                       enabledBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(16),
// //                         borderSide: BorderSide(
// //                           color: kPrimaryColor,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         } else {
// //           return Text('Loading...');
// //         }
// //       },
// //     );
// //   }
// // }

// import 'package:diabetes/chatBuble.dart';
// import 'package:diabetes/constants.dart';
// import 'package:diabetes/models/message.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatPage extends StatelessWidget {
//   static String id = 'ChatPage';

//   final _controller = ScrollController();

//   CollectionReference messages =
//       FirebaseFirestore.instance.collection(kMessagesCollections);
//   TextEditingController controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     var email = ModalRoute.of(context)!.settings.arguments as String;
//     return StreamBuilder<QuerySnapshot>(
//       stream: messages
//           .where('id', isEqualTo: email)
//           .orderBy(kCreatedAt, descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           List<Message> messagesList = [];
//           for (int i = 0; i < snapshot.data!.docs.length; i++) {
//             messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
//           }

//           return Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               automaticallyImplyLeading: false,
//               backgroundColor: kPrimaryColor,
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Chat with $email'),
//                 ],
//               ),
//               centerTitle: true,
//             ),
//             body: Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                       reverse: true,
//                       controller: _controller,
//                       itemCount: messagesList.length,
//                       itemBuilder: (context, index) {
//                         return messagesList[index].id == email
//                             ? ChatBuble(
//                                 message: messagesList[index],
//                               )
//                             : ChatBubleForFriend(message: messagesList[index]);
//                       }),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: TextField(
//                     controller: controller,
//                     onSubmitted: (data) {
//                       messages.add(
//                         {
//                           kMessage: data,
//                           kCreatedAt: DateTime.now(),
//                           'id': email
//                         },
//                       );
//                       controller.clear();
//                       _controller.animateTo(0,
//                           duration: Duration(milliseconds: 500),
//                           curve: Curves.easeIn);
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Send Message',
//                       suffixIcon: Icon(
//                         Icons.send,
//                         color: kPrimaryColor,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         borderSide: BorderSide(
//                           color: kPrimaryColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return Text('Loading...');
//         }
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/chatBuble.dart';
import 'package:diabetes/constants.dart';
import 'package:diabetes/models/message.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchRecipientDetails();
  }

  void _fetchRecipientDetails() {
    // Extract email from RouteSettings.arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final email = ModalRoute.of(context)!.settings.arguments as String?;
      if (email != null) {
        setState(() {
          recipientEmail = email;
        });

        // Fetch the recipient's name from Firestore
        FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: email)
            .get()
            .then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            setState(() {
              recipientName = snapshot.docs.first['name'] ?? 'No Name';
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chat with $recipientName'),
          ],
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: messages
            .where('id', isEqualTo: recipientEmail)
            .orderBy(kCreatedAt, descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == recipientEmail
                          ? ChatBuble(
                              message: messagesList[index],
                            )
                          : ChatBubleForFriend(message: messagesList[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (data) {
                      messages.add(
                        {
                          kMessage: data,
                          kCreatedAt: DateTime.now(),
                          'id': recipientEmail
                        },
                      );
                      controller.clear();
                      _controller.animateTo(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    decoration: InputDecoration(
                      hintText: 'Send Message',
                      suffixIcon: Icon(
                        Icons.send,
                        color: kPrimaryColor,
                      ),
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
              ],
            );
          } else {
            return Center(
              child: snapshot.hasError
                  ? Text('Error: ${snapshot.error}')
                  : CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
