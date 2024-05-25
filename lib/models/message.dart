import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String chatGroupId;
  final String senderId;
  final String text;
  final DateTime sentAt;
  List<String> seen;

  Message(
      {required this.id,
      required this.chatGroupId,
      required this.senderId,
      required this.text,
      required this.sentAt,
      required this.seen});

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
        id: data["id"],
        chatGroupId: data["chatGroupId"],
        senderId: data["senderId"],
        text: data["text"],
        sentAt: data["sentAt"].toDate(),
        seen: (data["seen"] as List<dynamic>).cast<String>());
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "chatGroupId": chatGroupId,
        "senderId": senderId,
        "text": text,
        "sentAt": sentAt,
        "seen": seen
      };
}
