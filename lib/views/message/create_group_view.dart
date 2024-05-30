import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/controllers/friend_request_controller.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/models/user.dart';

class CreateGroupView extends StatelessWidget {
  CreateGroupView({super.key});
  final ChatGroupController chatGroupController =
      Get.find<ChatGroupController>();
  final FriendRequestController friendRequestController =
      Get.find<FriendRequestController>();
  final UserController userController = Get.find<UserController>();
  final TextEditingController groupNameController = TextEditingController();
  final RxList<String> selectedFriends = <String>[].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mesaj Grubu Oluştur")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: groupNameController,
              decoration: const InputDecoration(labelText: "Grup Adı"),
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildFriendsList()),
            ElevatedButton(
              onPressed: () async {
                if (groupNameController.text.isEmpty) {
                  print("Group name is empty!");
                  //Get.snackbar("Error", "Group name is empty!");
                } else if (selectedFriends.isEmpty) {
                  // Get.snackbar(
                  //     "Error", "At least one friend must be selected!");
                  print("At least one friend must be selected!");
                } else {
                  selectedFriends.add(userController.user.value!.id);
                  await chatGroupController.createChatGroup(
                      members: selectedFriends,
                      image: "GRUP_IMAGE", ////////////////////////
                      name: groupNameController.text);
                }
                Get.back();
              },
              child: const Text("Grubu Oluştur"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendsList() {
    return Obx(() {
      return ListView.builder(
        itemCount: friendRequestController.friends.length,
        itemBuilder: (context, index) {
          User friend = friendRequestController.friends[index];
          return ListTile(
            title: Text(friend.username),
            trailing: Obx(() {
              bool isSelected = selectedFriends.contains(friend.id);
              return Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  toggleSelection(friend.id);
                },
              );
            }),
          );
        },
      );
    });
  }

  void toggleSelection(String friendId) {
    if (selectedFriends.contains(friendId)) {
      selectedFriends.remove(friendId);
    } else {
      selectedFriends.add(friendId);
    }
  }
}
