import 'package:get/get.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/models/chat_group.dart';

class JourneyDetailController {
  final ChatGroupController chatGroupController = Get.find();
  RxList<ChatGroup> returnGroup = <ChatGroup>[].obs;

  fetchSharedGroups(List<String> groups) {
    var _chatGropus = chatGroupController.chatGroups;
    for (var groupName in groups) {
      for (var group in _chatGropus) {
        if (group.id == groupName && !returnGroup.contains(group)) {
          returnGroup.add(group);
        }
      }
    }
  }

  listClear() {
    returnGroup.clear();
  }
}
