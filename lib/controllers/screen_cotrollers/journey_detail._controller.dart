import 'package:get/get.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/models/chat_group.dart';

class JourneyDetailController extends GetxController {
  RxList<ChatGroup> returnGroup = <ChatGroup>[].obs;
  @override
  void onInit() {
    super.onInit();
    // Listen to authentication changes.
  }

  fetchSharedGroups(List<String> groups) {
    final ChatGroupController chatGroupController = Get.find();

    var _chatGropus = chatGroupController.chatGroups;
    for (var groupName in groups) {
      for (var group in _chatGropus) {
        if (group.id == groupName && !returnGroup.contains(group)) {
          returnGroup.add(group);
          print(group.id);
        }
      }
    }
  }

  listClear() {
    returnGroup.clear();
  }
}
