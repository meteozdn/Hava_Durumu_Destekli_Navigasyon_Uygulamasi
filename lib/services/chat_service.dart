import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/models/message.dart';

class ChatService extends ChangeNotifier {
  String currentUserId = Get.find<UserController>().user.value!.id;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage(
      {required String chatGroupId, required String text}) async {
    try {
      // Create auto Id.
      final id = _fireStore
          .collection(FirestoreCollections.chatGroups)
          .doc(chatGroupId)
          .collection(FirestoreCollections.messages)
          .doc()
          .id;
      // Create messsage model.
      Message message = Message(
          id: id,
          chatGroupId: chatGroupId,
          senderId: currentUserId,
          text: text,
          sentAt: DateTime.now(),
          seen: [currentUserId]);
      // Save to firebase.
      await _fireStore
          .collection(FirestoreCollections.chatGroups)
          .doc(chatGroupId)
          .collection(FirestoreCollections.messages)
          .add(message.toJson());
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Stream<QuerySnapshot> getMessages(
      {required String userId, required String chatGroupId}) {
    return _fireStore
        .collection(FirestoreCollections.chatGroups)
        .doc(chatGroupId)
        .collection(FirestoreCollections.messages)
        .orderBy("sentAt", descending: false)
        .snapshots();
  }
}
