import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class MessageView extends StatelessWidget {
  MessageView({super.key});
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.whiteColor,
        actions: const [
          /*
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.pictionBlueColor,
                  iconColor: ColorConstants.whiteColor),
              onPressed: () {},
              child: const Icon(Icons.message),
            ),
          )*/
        ],
      ),
      body: Column(
        children: [
          Material(
            elevation: 5,
            child: Container(
              color: ColorConstants.whiteColor,
              height: 70.h,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return const CirclePersonCard(
                      user: 'Metehan',
                    );
                  }),
            ),
          ),
          SizedBox(
            height: 510.h,
            child: ListView.builder(
                controller: _pageController,
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) {
                  return MessageTile(
                    sender: "Name",
                    message: "Mesaj, mesaj, mesaj, mesaj",
                    isNew: index % 4 == 0,
                  );
                }),
          )
        ],
      ),
    );
  }
}

class CirclePersonCard extends StatelessWidget {
  const CirclePersonCard({
    super.key,
    required this.user,
  });
  final String user;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: ColorConstants.pictionBlueColor,
            radius: 25.r,
          ),
          SizedBox(
              width: 55.h,
              // height: 15.h,
              child: Center(child: Text(user)))
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.sender,
    required this.message,
    required this.isNew,
  });
  final String sender;
  final String message;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Text(message,
          style: isNew
              ? const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.pictionBlueColor)
              : null),
      title: Text(
        sender,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
      ),
      visualDensity: const VisualDensity(vertical: 4), // to compact

      leading: CircleAvatar(
        backgroundColor: ColorConstants.pictionBlueColor,
        radius: 30.r,
      ),
      trailing: const Icon(Icons.navigate_next),
    );
  }
}
