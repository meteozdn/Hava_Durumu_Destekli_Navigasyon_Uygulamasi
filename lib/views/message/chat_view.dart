import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/chat_controller.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/models/chat_group.dart';
import 'package:navigationapp/models/message.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key, required this.chatGroup});
  final ChatGroup chatGroup;

  @override
  Widget build(BuildContext context) {
    final ChatController chatController =
        Get.find<ChatController>(tag: chatGroup.id);

    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          CircleAvatar(
            backgroundImage: chatGroup.image.isNotEmpty
                ? NetworkImage(chatGroup.image)
                : null,
            backgroundColor: ColorConstants.pictionBlueColor,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(chatGroup.name),
          ),
        ],
      )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w),
        child: Column(
          children: [
            Expanded(child: _buildMessageList(chatController)),
            _buildMessageInput(chatController),
          ],
        ),
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
          //   return _buildMessageItem(message);
          return _ChatBubble(
            message: message,
          );
        },
      );
    });
  }

  Widget _buildMessageItem(Message message) {
    bool isMy = (message.senderId == Get.find<UserController>().user.value!.id);
    var alignment = isMy ? Alignment.centerRight : Alignment.centerLeft;
    const BorderRadiusGeometry myBorder = BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
        topLeft: Radius.circular(10));
    const BorderRadiusGeometry senderBorder = BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
        topRight: Radius.circular(10));
    return Padding(
      padding: isMy
          ? EdgeInsets.only(left: 60.0.w, bottom: 20.h)
          : EdgeInsets.only(right: 60.0.w, bottom: 20.h),
      child: Material(
        elevation: 5,
        borderRadius: isMy ? myBorder : senderBorder,
        child: Container(
          width: 30,
          decoration: BoxDecoration(
              color: ColorConstants.lightBlue,
              border: Border.all(color: ColorConstants.pictionBlueColor),
              borderRadius: isMy ? myBorder : senderBorder),
          alignment: alignment,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(message.text),
        ),
      ),
    );
  }

  Widget _buildMessageInput(ChatController chatController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                  controller: chatController.messageController,
                  decoration: InputDecoration(
                      hintText: "Mesaj yaz...",
                      labelStyle:
                          const TextStyle(color: ColorConstants.blackColor),
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: ColorConstants.redColor),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.r))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: ColorConstants.pictionBlueColor),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.r))))),
            ),
            IconButton(
              onPressed: chatController.sendMessage,
              icon: const Icon(Icons.send,
                  color: ColorConstants.pictionBlueColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;
  final BorderRadiusGeometry myBorder = const BorderRadius.only(
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
      topLeft: Radius.circular(10));
  final BorderRadiusGeometry senderBorder = const BorderRadius.only(
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
      topRight: Radius.circular(10));
  @override
  Widget build(BuildContext context) {
    final isMine =
        (message.senderId == Get.find<UserController>().user.value!.id);

    List<Widget> chatContents = [
      SizedBox(width: 12.w),
      Flexible(
        child: Material(
          shadowColor: ColorConstants.greyColor,
          elevation: 4,
          borderRadius: isMine ? myBorder : senderBorder,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 8.h,
              horizontal: 10.w,
            ),
            decoration: BoxDecoration(
                color: isMine
                    ? ColorConstants.lightBlue
                    : ColorConstants.greyColor,
                borderRadius: isMine ? myBorder : senderBorder,
                border: Border.all(
                    color: isMine
                        ? ColorConstants.pictionBlueColor
                        : ColorConstants.blackColor)),
            child: Padding(
              padding: isMine
                  ? EdgeInsets.only(left: 10.0.w)
                  : EdgeInsets.only(right: 10.w),
              child: Text(message.text),
            ),
          ),
        ),
      ),
      // const SizedBox(width: 12.w),
      //Text(""),
      // const SizedBox(width: 60),
    ];
    if (isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: isMine
          ? EdgeInsets.only(left: 60.0.w, bottom: 10.h)
          : EdgeInsets.only(right: 60.0.w, bottom: 10.h),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
