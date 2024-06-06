import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/chat_controller.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/models/chat_group.dart';

class ChatGroupController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<ChatGroup> chatGroups = <ChatGroup>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchUserChatGroups();
  }

  Future<void> fetchUserChatGroups() async {
    try {
      chatGroups.clear();
      String currentUserId = Get.find<UserController>().user.value!.id;
      List<String> ids =
          Get.find<UserController>().user.value!.chatGroups ?? [];
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
          String friendId =
              chatGroup.members.firstWhere((id) => id != currentUserId);
          Get.find<UserController>().fetchUser(userId: friendId).then((value) {
            chatGroup.name = value.username;
            chatGroup.image = value.image;
          });
        }
        chatGroups.add(chatGroup);
        // Initialize ChatController for each chat group.
        if (!Get.isRegistered<ChatController>(tag: chatGroup.id)) {
          Get.put(ChatController(chatGroup.id),
              tag: chatGroup.id, permanent: true);
        }
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> createChatGroup({
    required List<String> members,
    required String image,
    String name = "",
  }) async {
    try {
      // Normalize the members list by sorting it.
      members.sort();
      for (var chatGroup in chatGroups) {
        List<String> existingMembers = List<String>.from(chatGroup.members);
        existingMembers.sort();
        // Check if the sorted members list matches.
        if (const ListEquality().equals(existingMembers, members)) {
          // Chat group with the same members already exists.
          // Exit the function to prevent creating a new chat group.
          return;
        }
      }
      // Create auto Id.
      final id = firestore.collection(FirestoreCollections.chatGroups).doc().id;
      // Create ChatGroup model.
      ChatGroup chatGroup = ChatGroup(
          id: id, name: name, image: image, members: members, sharedRoutes: []);
      // Save ChatGroup to local.
      Get.find<UserController>().user.value!.chatGroups?.add(id);
      // Save ChatGroup to fireStore.
      await firestore
          .collection(FirestoreCollections.chatGroups)
          .doc(id)
          .set(chatGroup.toJson());
      for (String userId in members) {
        await updateUserChatGroupList(chatGroupId: id, userId: userId);
      }
      await fetchUserChatGroups();
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> updateUserChatGroupList(
      {required String chatGroupId,
      required String userId,
      bool isAdding = true}) async {
    try {
      // Save to firestore.
      await firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .update({
        "chatGroups": isAdding
            ? FieldValue.arrayUnion([chatGroupId])
            : FieldValue.arrayRemove([chatGroupId])
      });
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> updateChatGroupPhoto(
      {required String image, required String chatGroupId}) async {
    try {
      firestore
          .collection(FirestoreCollections.chatGroups)
          .doc(chatGroupId)
          .update(({"image": image}));
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
