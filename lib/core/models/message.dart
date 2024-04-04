import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String chatGroupId;
  final String senderId;
  final String text;
  final DateTime sentAt;

  Message(
      {required this.id,
      required this.chatGroupId,
      required this.senderId,
      required this.text,
      required this.sentAt});

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
        id: data["id"],
        chatGroupId: data["chatGroupId"],
        senderId: data["senderId"],
        text: data["text"],
        sentAt: data["sentAt"].toDate());
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "chatGroupId": chatGroupId,
        "senderId": senderId,
        "text": text,
        "sentAt": sentAt
      };
}
