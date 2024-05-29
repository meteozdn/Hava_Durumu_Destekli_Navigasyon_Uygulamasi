import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:navigationapp/controllers/friend_request_controller.dart';
import 'package:navigationapp/controllers/search_user_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key, required this.title});
  final String title;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: ColorConstants.pictionBlueColor)),
                labelText: "Ara",
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
                      leading: CircleAvatar(
                        backgroundImage: controller.users[index].image != null
                            ? NetworkImage(controller.users[index].image!)
                            : null,
                        backgroundColor: ColorConstants.pictionBlueColor,
                        radius: 20.h,
                        child: controller.users[index].image == null
                            ? Icon(
                                Icons.person,
                                size: 50.w,
                              )
                            : null,
                      ),
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
