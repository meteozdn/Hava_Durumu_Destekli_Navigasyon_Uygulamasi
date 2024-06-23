import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:navigationapp/controllers/friend_request_controller.dart';
import 'package:navigationapp/controllers/screen_cotrollers/search_friend_controller.dart';
import 'package:navigationapp/controllers/search_user_controller.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/models/user.dart';

class FriendsView extends StatelessWidget {
  FriendsView({
    super.key,
  });
  final TextEditingController _searchController = TextEditingController();
  final SearchFriendsController _friendsController =
      Get.put(SearchFriendsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Arkadaşlar"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              TextField(
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        // width: 0.0 produces a thin "hairline" border
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: ColorConstants.blackColor)),
                      labelText: "Ara",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Obx(() {
                    return ListView.builder(
                        itemCount: _friendsController.friends.length,
                        itemBuilder: (context, index) {
                          return FriendCard(
                            friend: _friendsController.friends[index],
                          );
                        });
                  }),
                ),
              ),
            ],
          ),
        ));
  }
}

class FriendCard extends StatelessWidget {
  const FriendCard({
    super.key,
    required this.friend,
  });
  final User friend;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SizedBox(
            height: 40.h,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: ColorConstants.blackColor,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0.w),
                          child: Text(friend.name),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorConstants.blackColor, width: 2.w),
                          borderRadius: BorderRadius.circular(20.r)),
                      child: Padding(
                        padding: EdgeInsets.all(2.0.w),
                        child: const Icon(
                          Icons.delete,
                          color: ColorConstants.blackColor,
                        ),
                      ))
                ],
              ),
            )));
  }
}
