import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String name;
  final String surname;
  final String? image;
  final DateTime registerAt;
  List<String>? friends;
  List<String>? chatGroups;
  List<String>? routes;

  User(
      {required this.id,
      required this.username,
      required this.name,
      required this.surname,
      this.image,
      required this.registerAt,
      this.friends = const [],
      this.chatGroups = const [],
      this.routes = const []});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
        id: data["id"],
        image: data["image"],
        username: data["username"],
        name: data["name"],
        surname: data["surname"],
        registerAt: data["registerAt"].toDate(),
        friends: List<String>.from(data["friends"]),
        chatGroups: List<String>.from(data["chatGroups"]),
        routes: List<String>.from(data["routes"]));
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "username": username,
        "name": name,
        "surname": surname,
        "registerAt": registerAt,
        "friends": friends,
        "chatGroups": chatGroups,
        "routes": routes,
      };
}
