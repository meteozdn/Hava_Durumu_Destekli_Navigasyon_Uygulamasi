import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/core/controllers/friend_request_controller.dart';
import 'package:navigationapp/views/profile/search_user_screen.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              Get.to(() => SearchUserScreen());
            },
            child: const Text("Arkadaş ekle")),
        const Text("Arkadaşlık istekleri"),
        Expanded(
          child: GetX<FriendRequestController>(
            init: Get.find<FriendRequestController>(),
            builder: (controller) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.friendRequestsIn.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(controller
                              .friendRequestsIn[index].senderUsername),
                          onTap: () {},
                          trailing: ElevatedButton(
                            onPressed: () async {
                              await controller.buttonAction(
                                  userId: controller
                                      .friendRequestsIn[index].senderId,
                                  buttonText: "Accept Request");
                            },
                            child: const Text("Accept Request"),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.friendRequestsOut.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(controller
                              .friendRequestsOut[index].recipientUsername),
                          onTap: () {},
                          trailing: ElevatedButton(
                            onPressed: () async {
                              await controller.buttonAction(
                                  userId: controller
                                      .friendRequestsOut[index].recipientId,
                                  buttonText: "Remove Request");
                            },
                            child: const Text("Remove Request"),
                          ),
                        );
                      },
                    ),
                  ),
                  const Text("Arkadaşlar"),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.friends.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.route),
                          title: Text(controller.friends[index].id),
                          onTap: () {},
                        );
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
