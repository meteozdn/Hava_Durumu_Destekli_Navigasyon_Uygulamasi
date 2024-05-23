import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/views/components/rotate_line.dart';

class JourneyWidget extends StatelessWidget {
  const JourneyWidget({
    super.key,
    required this.startCity,
    required this.endCity,
    required this.startDate,
    required this.endDate,
    required this.user,
    required this.time,
    required this.isMY,
  });
  final String startCity;
  final String endCity;
  final String startDate;
  final String endDate;
  final String user;
  final String time;
  final bool isMY;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: isMY
                  ? ColorConstants.pastelMagentaColor
                  : ColorConstants.pictionBlueColor),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r)),
      height: 160.h,
      width: 400.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0.w),
                  child: Row(
                    children: [
                      const Row(
                        children: [],
                      ),
                      SizedBox(
                        child: CircleAvatar(
                          radius: 25.r,
                          backgroundColor: isMY
                              ? ColorConstants.pastelMagentaColor
                              : ColorConstants.pictionBlueColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0.w),
                        child: Text(
                          user,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.sp),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 45.0.w),
                        child: Text(
                          textAlign: TextAlign.center,
                          "11.12.2024\n$time",
                          style: TextStyle(
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.r),
                      child: const RotateLine(),
                    ),
                    SizedBox(
                      height: 70.h,
                      width: 150.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                startCity,
                                style: TextStyle(fontSize: 15.sp),
                              ),
                              Text(
                                startDate,
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                endCity,
                                style: TextStyle(fontSize: 15.sp),
                              ),
                              Text(
                                endDate,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50.0.w),
                      child: SizedBox(
                        height: 70.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isMY
                                      ? ColorConstants.pastelMagentaColor
                                      : ColorConstants.pictionBlueColor,
                                ),
                                onPressed: () {},
                                child: const Icon(
                                  Icons.navigate_next,
                                  color: ColorConstants.whiteColor,
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
