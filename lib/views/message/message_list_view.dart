import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/chat_controller.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/views/message/create_group_view.dart';
import 'package:navigationapp/views/message/message_tile.dart';

class MessageView extends StatelessWidget {
  const MessageView({super.key});

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
                      final lastMessage = chatController.messages.isNotEmpty
                          ? chatController.messages.last.text
                          : "Mesaj Gönderin!";
                      final isSeen = chatController.messages.isNotEmpty
                          ? chatController.messages.last.seen.contains(
                              Get.find<UserController>().user.value!.id)
                          : true;
                      return MessageTile(
                        chatGroup: chatGroup,
                        lastMessage: lastMessage,
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
