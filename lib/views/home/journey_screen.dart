import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class Journey {
  final String startDate;
  final String endCity;
  final String startCity;
  final String endDate;
  final String user;
  final String time;

  Journey(
      {required this.startDate,
      required this.endCity,
      required this.startCity,
      required this.endDate,
      required this.user,
      required this.time});
}

class JourneyScreen extends StatelessWidget {
  final List<Journey> journeys = [
    Journey(
        startDate: "10.9.2024",
        endCity: "Çorum",
        startCity: "Ankara",
        endDate: "11.10.2024",
        user: "Mehmet Büyükekşi",
        time: "5 sa 10 dk"),
    Journey(
        startDate: "10.9.2024",
        endCity: "Çorum",
        startCity: "Ankara",
        endDate: "11.10.2024",
        user: "Mehmet Büyükekşi",
        time: "5 sa 10 dk"),
    Journey(
        startDate: "10.9.2024",
        endCity: "Çorum",
        startCity: "Ankara",
        endDate: "11.10.2024",
        user: "Mehmet Büyükekşi",
        time: "5 sa 10 dk"),
    Journey(
        startDate: "10.9.2024",
        endCity: "Çorum",
        startCity: "Ankara",
        endDate: "11.10.2024",
        user: "Mehmet Büyükekşi",
        time: "5 sa 10 dk"),
    Journey(
        startDate: "10.9.2024",
        endCity: "Çorum",
        startCity: "Ankara",
        endDate: "11.10.2024",
        user: "Mehmet Büyükekşi",
        time: "5 sa 10 dk")
  ];
  RxInt _selectedIndex = 1.obs;
  final PageController _controller = PageController();
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
              _selectedIndex.value == 1
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
              controller: _controller,
              children: [
                ListView.builder(
                    padding:
                        EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30),

                    //  padding: EdgeInsets.only(bottom: 20.0.h),
                    itemCount: journeys.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 20.0.h),
                        child: Material(
                          borderRadius: BorderRadius.circular(20.r),
                          elevation: 10.h,
                          child: JourneyWidget(
                            isMY: true,
                            startCity: journeys[index].user,
                            endCity: 'Samsun',
                            startDate: '18.00',
                            endDate: '20.30',
                            user: 'Ahmet Mehmet',
                            time: '12 sa 10 dk',
                          ),
                        ),
                      );
                    }),
                ListView.builder(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),

                    //   padding: EdgeInsets.only(bottom: 20.0.h),
                    itemCount: journeys.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 20.0.h),
                        child: Material(
                          borderRadius: BorderRadius.circular(20.r),
                          elevation: 10.h,
                          child: JourneyWidget(
                            isMY: false,
                            startCity: journeys[index].user,
                            endCity: 'Samsun',
                            startDate: '18.00',
                            endDate: '20.30',
                            user: 'Ahmet Mehmet',
                            time: '12 sa 10 dk',
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
            radius: 5.r,
          ),
        ),
      ],
    );
  }
}

class ProjectIndicator extends StatelessWidget {
  final bool isActive;
  const ProjectIndicator({
    super.key,
    required this.isActive,
    this.index,
  });
  final int? index;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.all(5),
      width: isActive ? 40.0 : 10.0,
      height: 10.0,
      decoration: BoxDecoration(
          color: index == 0
              ? isActive
                  ? ColorConstants.pastelMagentaColor
                  : ColorConstants.pictionBlueColor
              : isActive
                  ? ColorConstants.pictionBlueColor
                  : ColorConstants.pastelMagentaColor,
          borderRadius: BorderRadius.circular(8)),
    );
  }
}
