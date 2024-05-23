import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class RotateLine extends StatelessWidget {
  const RotateLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: ColorConstants.blackColor,
          radius: 10.r,
          child: CircleAvatar(
            backgroundColor: ColorConstants.whiteColor,
            radius: 5.r,
          ),
        ),
        SizedBox(
          height: 30.h,
          child: VerticalDivider(
            thickness: 5.w,
            color: ColorConstants.blackColor,
          ),
        ),
        CircleAvatar(
          backgroundColor: ColorConstants.blackColor,
          radius: 10.r,
          child: CircleAvatar(
            backgroundColor: ColorConstants.whiteColor,
            radius: 5.r,
          ),
        ),
      ],
    );
  }
}
