import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navigationapp/core/models/message.dart';

class ChatGroup {
  final String id;
  String name;
  List<String> members;
  List<String> sharedRoutes;
  List<Message>? messages;

  ChatGroup(
      {required this.id,
      required this.name,
      required this.members,
      required this.sharedRoutes,
      this.messages});

  factory ChatGroup.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<dynamic>? messageList = data["messages"];
    List<Message>? messages = messageList
        ?.map((messageData) => Message.fromFirestore(messageData))
        .toList();
    return ChatGroup(
        id: data["id"],
        name: data["name"],
        members: (data["members"] as List<dynamic>).cast<String>(),
        sharedRoutes: (data["sharedRoutes"] as List<dynamic>).cast<String>(),
        messages: messages);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "members": members,
        "sharedRoutes": sharedRoutes,
      };
}
