import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message; // The actual message text
  final String senderId; // ID of the sender
  final String receiverId; // ID of the receiver
  final String imageUrl; // URL of the image (if any)
  final String attachmentUrl; // URL of the attachment (if any)
  final DateTime createdAt; // Timestamp of the message

  Message({
    required this.message,
    required this.senderId,
    required this.receiverId,
    this.imageUrl = '', // Default to empty string if no image
    this.attachmentUrl = '', // Default to empty string if no attachment
    required this.createdAt,
  });

  factory Message.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      message: data['message'] ?? '',
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      imageUrl: data['imageUrl'] ?? '', // Parse imageUrl if present
      attachmentUrl:
          data['attachmentUrl'] ?? '', // Parse attachmentUrl if present
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'imageUrl': imageUrl,
      'attachmentUrl': attachmentUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
