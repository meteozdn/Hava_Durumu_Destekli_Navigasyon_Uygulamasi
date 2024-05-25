import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/models/message.dart';
import 'package:navigationapp/services/chat_service.dart';

class ChatController extends GetxController {
  final String chatGroupId;
  final ChatService _chatService = ChatService();
  final TextEditingController messageController = TextEditingController();
  final RxList<Message> messages = <Message>[].obs;
  RxBool isLoading = true.obs;

  ChatController(this.chatGroupId);

  @override
  void onInit() async {
    super.onInit();
    loadMessages();
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
}
