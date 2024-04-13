import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/core/controllers/friend_request_controller.dart';
import 'package:navigationapp/core/controllers/search_user_controller.dart';

class SearchUserScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Get.find<SearchUserController>()
                        .searchUsers(_searchController.text.trim())
                        .then((value) {
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: GetX<SearchUserController>(
              init: SearchUserController(),
              builder: (controller) {
                return ListView.builder(
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(controller.users[index].username),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await Get.find<FriendRequestController>()
                              .buttonAction(
                                  userId: controller.users[index].id,
                                  buttonText: controller.buttonTexts[index])
                              .then((value) {
                            controller.updateButtonText(
                                buttonText: controller.buttonTexts[index],
                                index: index);
                          });
                        },
                        child: Obx(() => Text(controller.buttonTexts[index])),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
