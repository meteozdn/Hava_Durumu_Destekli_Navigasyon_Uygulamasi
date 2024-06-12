import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/route_controller.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/models/chat_group.dart';
import 'package:navigationapp/models/message.dart';
import 'package:navigationapp/services/chat_service.dart';

class ChatController extends GetxController {
  ChatController(this.chatGroupId);

  final String chatGroupId;
  final ChatService _chatService = ChatService();
  Rx<ChatGroup?> chatGroup = Rx<ChatGroup?>(null);

  final TextEditingController messageController = TextEditingController();
  final RxList<Message> messages = <Message>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isLoading = true.obs;

  StreamSubscription<DocumentSnapshot>? chatGroupSubscription;
  DocumentReference? chatGroupDocRef;

  @override
  void onInit() async {
    super.onInit();
    loadMessages();
    chatGroupDocRef =
        _firestore.collection(FirestoreCollections.chatGroups).doc(chatGroupId);
    listenToChatGroupUpdates();
  }

  @override
  void onClose() {
    chatGroupSubscription?.cancel();
    super.onClose();
  }

  void listenToChatGroupUpdates() {
    chatGroupSubscription = chatGroupDocRef?.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        ChatGroup newChatGroupData = ChatGroup.fromFirestore(snapshot);
        ChatGroup? oldChatGroupData = chatGroup.value;
        chatGroup.value = newChatGroupData;
        if (oldChatGroupData == null) {
          return;
        }
        // Check for updates to "sharedRoutes" field.
        if (oldChatGroupData.sharedRoutes != newChatGroupData.sharedRoutes) {
          Get.find<RouteController>().fetchUserRoutes();
        }
      }
    });
  }

  void loadMessages() {
    _chatService
        .getMessages(
            userId: Get.find<UserController>().user.value!.id,
            chatGroupId: chatGroupId)
        .listen((snapshot) {
      messages.value =
          snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
      isLoading.value = false;
    });
  }

  Future<void> sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          chatGroupId: chatGroupId, text: messageController.text);
      messageController.clear();
    }
  }

  Future<void> seeMessage() async {
    try {
      // Update the "seen" field of the last message.
      String userId = Get.find<UserController>().user.value!.id;
      await _firestore
          .collection(FirestoreCollections.chatGroups)
          .doc(chatGroupId)
          .collection(FirestoreCollections.messages)
          .doc(messages.last.id)
          .update({
        "seen": FieldValue.arrayUnion([userId])
      });
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
