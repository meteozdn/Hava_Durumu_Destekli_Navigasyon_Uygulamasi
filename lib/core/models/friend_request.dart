import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  final String id;
  final String senderId;
  final String recipientId;

  FriendRequest({
    required this.id,
    required this.senderId,
    required this.recipientId,
  });

  factory FriendRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FriendRequest(
        id: data["id"],
        senderId: data["senderId"],
        recipientId: data["recipientId"]);
  }

  Map<String, dynamic> toJson() =>
      {"id": id, "senderId": senderId, "recipientId": recipientId};
}
