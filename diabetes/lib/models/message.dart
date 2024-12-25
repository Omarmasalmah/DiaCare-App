import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/constants.dart';

class Message {
  final String message;
  final String senderId;
  final String receiverId;
  final DateTime createdAt;
  final String conversationId;

  Message({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.conversationId,
  });

  factory Message.fromJson(dynamic json) {
    return Message(
      message: json['message'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      conversationId: json['conversationId'],
    );
  }
}
