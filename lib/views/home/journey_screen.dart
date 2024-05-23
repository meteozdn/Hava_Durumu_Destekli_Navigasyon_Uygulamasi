import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:navigationapp/views/components/indicator.dart';
import 'package:navigationapp/views/components/journey_card.dart';

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
