import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:navigationapp/controllers/route_controller.dart';
import 'package:navigationapp/views/components/indicator.dart';
import 'package:navigationapp/views/components/journey_card.dart';

class JourneyScreen extends StatelessWidget {
  RxInt _selectedIndex = 0.obs;
  final PageController _pageviewontroller = PageController();
  JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 60.0.h,
      ),
      child: Column(
        children: [
          Obx(() {
            return Text(
              _selectedIndex.value == 0
                  ? "Yolculuklarım"
                  : "Paylaşılan Yolculuklar",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                2,
                (index) => Obx(() {
                  return ProjectIndicator(
                      index: _selectedIndex.value,
                      isActive: _selectedIndex.value == index);
                }),
              ),
            ],
          ),
          SizedBox(
            height: 500.h,
            child: PageView(
              onPageChanged: (index) {
                _selectedIndex(index);
              },
              controller: _pageviewontroller,
              children: [
                SizedBox(
                  height: 200,
                  child: GetX<RouteController>(
                    init: Get.find<RouteController>(),
                    builder: (controller) {
                      return ListView.builder(
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        itemCount: controller.userRoutes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 20.0.h),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.r),
                              elevation: 10.h,
                              child: JourneyWidget(
                                isMY: true,
                                startCity:
                                    controller.userRoutes[index].startingCity,
                                endCity: controller
                                    .userRoutes[index].destinationCity,
                                startDate:
                                    controller.userRoutes[index].plannedAt,
                                endDate: DateTime.now(),
                                user: controller.userRoutes[index].ownerName,
                                userImage:
                                    controller.userRoutes[index].userImage,
                                time: '12 sa 10 dk',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 200.h,
                  child: GetX<RouteController>(
                    init: Get.find<RouteController>(),
                    builder: (controller) {
                      return ListView.builder(
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        itemCount: controller.sharedRoutes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 20.0.h),
                            child: Material(
                                borderRadius: BorderRadius.circular(20.r),
                                elevation: 10.h,
                                child: JourneyWidget(
                                  isMY: false,
                                  startCity: controller
                                      .sharedRoutes[index].startingCity,
                                  endCity: controller
                                      .sharedRoutes[index].destinationCity,
                                  startDate:
                                      controller.sharedRoutes[index].plannedAt,
                                  endDate: DateTime.now(),
                                  user:
                                      controller.sharedRoutes[index].ownerName,
                                  userImage:
                                      controller.sharedRoutes[index].userImage,
                                  time: '12 sa 10 dk',
                                )),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
