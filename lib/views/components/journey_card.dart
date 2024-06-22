import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:navigationapp/controllers/map_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';
import 'package:navigationapp/models/route.dart';
import 'package:navigationapp/views/components/rotate_line.dart';
import 'package:navigationapp/views/home/journeys/journeys.detail.dart';

class JourneyWidget extends StatelessWidget {
  JourneyWidget({
    super.key,
    required this.startCity,
    required this.endCity,
    required this.startDate,
    required this.endDate,
    required this.user,
    required this.time,
    required this.isMY,
    this.userImage,
    // required this.index,
    required this.route,
  });
  final RouteModel route;
  final String startCity;
  final String endCity;
  final DateTime startDate;
  final DateTime endDate;
  final String user;
  final String time;
  final bool isMY;
  final DateFormat formatterDate = DateFormat('dd MM yyyy', 'tr_TR');
  final DateFormat formatterDateDay = DateFormat('dd MMMM', 'tr_TR');

  final DateFormat formatterHour = DateFormat('jm', 'tr_TR');
  final String? userImage;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: isMY
                  ? ColorConstants.pastelMagentaColor
                  : ColorConstants.blackColor),
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
                          backgroundColor: isMY
                              ? ColorConstants.pastelMagentaColor
                              : ColorConstants.blackColor,
                          radius: 19.h,
                          child: CircleAvatar(
                            radius: 17.h,

                            backgroundImage:
                                CachedNetworkImageProvider(userImage!),
                            backgroundColor: ColorConstants.blackColor,
                            // radius: 50.h,
                            child: userImage == null
                                ? Icon(
                                    Icons.person,
                                    size: 30.w,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0.w),
                        child: Text(
                          //route.sharedChatGroups
                          user,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.sp),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50.0.w),
                        child: Text(
                          textAlign: TextAlign.center,
                          formatterDateDay.format(startDate),
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
                      width: 180.w,
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
                                formatterDate.format(startDate),
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
                                formatterDate.format(endDate),
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
                      padding: EdgeInsets.only(left: 10.0.w),
                      child: SizedBox(
                        height: 70.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isMY
                                      ? ColorConstants.pastelMagentaColor
                                      : ColorConstants.blackColor,
                                ),
                                onPressed: () async {
                                  final MapController navMapController =
                                      Get.find();

                                  await navMapController.setPolylinePoints(
                                      start: LatLng(
                                          route.startingLocation.latitude,
                                          route.startingLocation.longitude),
                                      destination: LatLng(
                                          route.destinationLocation.latitude,
                                          route.destinationLocation.longitude));
                                  Get.to(() => JourneyDetail(route: route));
                                },
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
