import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/chat_controller.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/models/message.dart';

class ChatView extends StatelessWidget {
  final String chatGroupId;
  final String name;

  const ChatView({
    super.key,
    required this.chatGroupId,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final ChatController chatController =
        Get.find<ChatController>(tag: chatGroupId);

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(chatController)),
          _buildMessageInput(chatController),
        ],
      ),
    );
  }

  Widget _buildMessageList(ChatController chatController) {
    return Obx(() {
      if (chatController.messages.isEmpty) {
        return const Center(child: Text("No messages"));
      }

      return ListView.builder(
        itemCount: chatController.messages.length,
        itemBuilder: (context, index) {
          Message message = chatController.messages[index];
          return _buildMessageItem(message);
        },
      );
    });
  }

  Widget _buildMessageItem(Message message) {
    var alignment =
        (message.senderId == Get.find<UserController>().user.value!.id)
            ? Alignment.centerRight
            : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(message.text),
    );
  }

  Widget _buildMessageInput(ChatController chatController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatController.messageController,
              decoration: const InputDecoration(
                hintText: 'Enter your message...',
              ),
            ),
          ),
          IconButton(
            onPressed: chatController.sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
