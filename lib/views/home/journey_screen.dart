import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: EdgeInsets.only(top: 100.0.h, left: 20.w, right: 20.w),
          child: ListView.builder(
              padding: EdgeInsets.only(bottom: 20.0.h),
              itemCount: journeys.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(top: 20.0.h),
                  child: Material(
                    borderRadius: BorderRadius.circular(20.r),
                    elevation: 10.h,
                    child: JourneyWidget(
                      startCity: journeys[index].user,
                      endCity: 'Samsun',
                      startDate: '18.00',
                      endDate: '20.30',
                      user: 'Ahmet Mehmet',
                      time: '12 sa 10 dk',
                    ),
                  ),
                );
              })),
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
  });
  final String startCity;
  final String endCity;
  final String startDate;
  final String endDate;
  final String user;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: ColorConstants.pictionBlueColor),
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
                          backgroundColor: ColorConstants.pictionBlueColor,
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
                                  backgroundColor:
                                      ColorConstants.pictionBlueColor,
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
