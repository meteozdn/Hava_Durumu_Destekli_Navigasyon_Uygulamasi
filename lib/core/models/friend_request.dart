import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  final String id;
  final String senderId;
  final String senderUsername;
  final String recipientId;
  final String recipientUsername;

  FriendRequest(
      {required this.id,
      required this.senderId,
      required this.senderUsername,
      required this.recipientId,
      required this.recipientUsername});

  factory FriendRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FriendRequest(
        id: data["id"],
        senderId: data["senderId"],
        senderUsername: data["senderUsername"],
        recipientId: data["recipientId"],
        recipientUsername: data["recipientUsername"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "senderId": senderId,
        "senderUsername": senderUsername,
        "recipientId": recipientId,
        "recipientUsername": recipientUsername
      };
}
