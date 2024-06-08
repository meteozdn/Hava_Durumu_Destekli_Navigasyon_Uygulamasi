import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigationapp/controllers/map_controller/map_weather_controller.dart';
import 'package:navigationapp/controllers/screen_cotrollers/weather_screen_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/views/components/blured_container.dart';
import 'package:navigationapp/views/components/indicator.dart';
import 'package:navigationapp/views/components/weather_map_widgets/weather_map_widgets.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class WeatherScreen extends StatelessWidget {
  WeatherScreen({super.key});
  RxString mapTheme = "".obs;

  final MapWeatherController weatherScreenController =
      Get.put(MapWeatherController());

  MapWeatherController mapWeatherController = Get.put(MapWeatherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //color: Colors.blue,
      body: Stack(
        children: [
          Obx(() {
            mapWeatherController.load();
            return GoogleMap(
              markers: mapWeatherController.markers,
              initialCameraPosition: CameraPosition(
                  target: mapWeatherController.center, zoom: 9.h),
              onMapCreated: mapWeatherController.onMapCreated,
              compassEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              //   mapType: MapType.normal,
              tileOverlays: mapWeatherController.tileOverlays,
            );
          }),
          Padding(
            padding: EdgeInsets.only(top: 50.0.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const WeatherScreenAppBar(),
                  const TempViewerWidget(),
                  WeatherScreenBottomWidgets(
                      mapWeatherController: mapWeatherController)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WeatherScreenBottomWidgets extends StatelessWidget {
  const WeatherScreenBottomWidgets({
    super.key,
    required this.mapWeatherController,
  });

  final MapWeatherController mapWeatherController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.w, bottom: 20.h, left: 20.w),
      child: BluredContainer(
        height: 150.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                SizedBox(
                    height: 120.h,
                    child: PageView(
                      controller: PageController(),
                      onPageChanged: (index) {
                        mapWeatherController.changePage();
                        print(index);
                        mapWeatherController.pageViewIndex.value = index;
                      },
                      children: [
                        NowTemp(),
                        Daily24HourTemp(),
                        WeeklyTemp(),
                        PreasureWidget(),
                        Wind(),
                        AirClean(),
                      ],
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: WeatherScreenIndicator(
                  mapWeatherController: mapWeatherController),
            )
          ],
        ),
        //   width: 300.w,
      ),
    );
  }
}

class WeatherScreenAppBar extends StatelessWidget {
  const WeatherScreenAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    _showAlertDialog() {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Doğal Afetler'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        Image.asset(
                          ImageConst.disaster,
                          width: 100.w,
                        ),
                        Text(
                          "Çevrenizde Kritik\nDurum Yok",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        BluredContainer(
            width: 200.w,
            height: 30.h,
            child: Center(
              child: Text(
                "Samsun-Atakum",
                style: TextStyle(
                    color: ColorConstants.blackColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            )),
        IconButton(
            onPressed: () {
              final MapWeatherController weatherScreenController = Get.find();
              weatherScreenController.getAllerts();
              _showAlertDialog();
            },
            icon: const Icon(Icons.notification_important))
      ],
    );
  }
}
