import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/core/controllers/user_controller.dart';
import 'package:navigationapp/core/models/chat_group.dart';

class ChatGroupController extends GetxController {
  var chatGroups = <ChatGroup>[].obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() async {
    super.onInit();
    await fetchUserChatGroups();
  }

  Future<void> createChatGroup({
    required List<String> members,
    String name = "",
  }) async {
    try {
      // Create auto Id.
      final id = firestore.collection(FirestoreCollections.chatGroups).doc().id;
      // Create ChatGroup model.
      ChatGroup chatGroup =
          ChatGroup(id: id, name: name, members: members, sharedRoutes: []);
      // Save ChatGroup to fireStore.
      await firestore
          .collection(FirestoreCollections.chatGroups)
          .doc(id)
          .set(chatGroup.toJson());
      for (String userId in members) {
        await Get.find<UserController>()
            .updateUserChatGroupList(chatGroupId: id, userId: userId);
        await fetchUserChatGroups();
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> fetchUserChatGroups() async {
    try {
      List<String> ids =
          Get.find<UserController>().user.value!.chatGroups ?? [];
      List<ChatGroup> chatGroups = [];
      // Get ChatGroups from firestore.
      for (String id in ids) {
        DocumentSnapshot snapshot = await firestore
            .collection(FirestoreCollections.chatGroups)
            .doc(id)
            .get();
        // Create ChatGroup models.
        ChatGroup chatGroup = ChatGroup.fromFirestore(snapshot);
        // If the ChatGroup is for two persons, the name will be friend's username.
        if (chatGroup.name.isEmpty) {
          String friendId = chatGroup.members.firstWhere(
              (id) => id != Get.find<UserController>().user.value!.id);
          Get.find<UserController>().fetchUser(userId: friendId).then((value) {
            chatGroup.name = value.username;
          });
        }
        chatGroups.add(chatGroup);
      }
      this.chatGroups.value = chatGroups;
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
