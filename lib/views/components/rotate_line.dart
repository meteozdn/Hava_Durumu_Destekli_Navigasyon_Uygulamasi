import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:navigationapp/controllers/theme_change_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class RotateLine extends StatelessWidget {
  final ThemeChanger themeChanger = Get.find();

  RotateLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: themeChanger.isLight.value
              ? ColorConstants.darkGrey
              : ColorConstants.blackColor,
          radius: 10.r,
          child: CircleAvatar(
            backgroundColor: themeChanger.isLight.value
                ? ColorConstants.lightGrey
                : ColorConstants.darkGrey,
            radius: 5.r,
          ),
        ),
        SizedBox(
          height: 30.h,
          child: VerticalDivider(
            thickness: 5.w,
            color: themeChanger.isLight.value
                ? ColorConstants.blackColor
                : ColorConstants.blackColor,
          ),
        ),
        CircleAvatar(
          backgroundColor: themeChanger.isLight.value
              ? ColorConstants.darkGrey
              : ColorConstants.blackColor,
          radius: 10.r,
          child: CircleAvatar(
            backgroundColor: themeChanger.isLight.value
                ? ColorConstants.lightGrey
                : ColorConstants.darkGrey,
            radius: 5.r,
          ),
        ),
      ],
    );
  }
}
