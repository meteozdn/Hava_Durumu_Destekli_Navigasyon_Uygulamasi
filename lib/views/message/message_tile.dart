import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/chat_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/models/chat_group.dart';
import 'package:navigationapp/views/message/chat_view.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.chatGroup,
    required this.lastMessage,
    required this.isSeen,
  });
  final String lastMessage;
  final bool isSeen;
  final ChatGroup chatGroup;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatView(chatGroup: chatGroup),
          ),
        );
        if (!isSeen) {
          await Get.find<ChatController>(tag: chatGroup.id).seeMessage();
        }
      },
      subtitle: Text(lastMessage,
          style: isSeen
              ? null
              : const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.pictionBlueColor)),
      title: Text(
        chatGroup.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
      ),
      visualDensity: const VisualDensity(vertical: 4), // to compact
      leading: CircleAvatar(
        backgroundImage: chatGroup.image.isNotEmpty
            ? CachedNetworkImageProvider(chatGroup.image)
            : null,
        backgroundColor: ColorConstants.pictionBlueColor,
        radius: 30.r,
      ),
      trailing: const Icon(Icons.navigate_next),
    );
  }
}
