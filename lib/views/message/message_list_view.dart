import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/chat_controller.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/views/message/chat_view.dart';
import 'package:navigationapp/views/message/create_group_view.dart';

class MessageView extends StatelessWidget {
  MessageView({super.key});
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.whiteColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.pictionBlueColor,
              ),
              onPressed: () {
                Get.to(() => CreateGroupView());
              },
              child: const Icon(
                Icons.message,
                color: ColorConstants.whiteColor,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 510.h,
            child: GetX<ChatGroupController>(
              builder: (controller) {
                return ListView.builder(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  itemCount: controller.chatGroups.length,
                  itemBuilder: (context, index) {
                    final chatGroup = controller.chatGroups[index];
                    final chatController =
                        Get.find<ChatController>(tag: chatGroup.id);
                    return Obx(() {
                      String message;
                      bool isSeen = true;
                      String userId = Get.find<UserController>().user.value!.id;
                      try {
                        message = chatController.messages.last.text;
                        isSeen = chatController.messages.last.seen
                            .any((id) => id == userId);
                      } catch (error) {
                        message = "Mesaj Gönderin!";
                      }
                      return MessageTile(
                        sender: chatGroup.name,
                        chatGroupId: chatGroup.id,
                        message: message,
                        isSeen: isSeen,
                      );
                    });
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class CirclePersonCard extends StatelessWidget {
  const CirclePersonCard({
    super.key,
    required this.user,
  });
  final String user;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: ColorConstants.pictionBlueColor,
            radius: 25.r,
          ),
          SizedBox(
              width: 55.h,
              // height: 15.h,
              child: Center(child: Text(user)))
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile(
      {super.key,
      required this.sender,
      required this.message,
      required this.isSeen,
      required this.chatGroupId});
  final String sender;
  final String message;
  final bool isSeen;
  final String chatGroupId;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatView(
              chatGroupId: chatGroupId,
              name: sender,
            ),
          ),
        );
        if (!isSeen) {
          await Get.find<ChatController>(tag: chatGroupId).seeMessage();
        }
      },
      subtitle: Text(message,
          style: isSeen
              ? null
              : const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.pictionBlueColor)),
      title: Text(
        sender,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
      ),
      visualDensity: const VisualDensity(vertical: 4), // to compact

      leading: CircleAvatar(
        backgroundColor: ColorConstants.pictionBlueColor,
        radius: 30.r,
      ),
      trailing: const Icon(Icons.navigate_next),
    );
  }
}
