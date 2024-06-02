import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigationapp/controllers/map_controller/map_controller.dart';
import 'package:navigationapp/controllers/map_controller/map_weather_controller.dart';
import 'package:navigationapp/controllers/screen_cotrollers/weather_screen_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/services/weather_service/daily_24_hour_temp_service.dart';
import 'package:navigationapp/views/components/indicator.dart';

class WeatherScreen extends StatelessWidget {
  WeatherScreen({super.key});
  RxString mapTheme = "".obs;
  final WeatherScreenController weatherScreenController =
      Get.put(WeatherScreenController());
  final NavigationController _mapController = Get.put(NavigationController());
  late GoogleMapController googlemapController;
  final LatLng center = LatLng(39.925533, 36.33);

  _onMapCreated(GoogleMapController controller) async {
    googlemapController = controller;
  }

  Future<void> _applyMapStyle() async {
    String style = await DefaultAssetBundle.of(Get.context!)
        .loadString('lib/assets/map_theme/silver_theme.json');
    googlemapController.setMapStyle(style);
    _isLoad(_isLoad.value);
  }

  RxBool _isLoad = false.obs;
  RxSet<TileOverlay> _tileOverlays = <TileOverlay>{}.obs;

  initTiles() async {
    final String overlayId = DateTime.now().millisecondsSinceEpoch.toString();
    final tileOverlay = TileOverlay(
        tileOverlayId: TileOverlayId(overlayId),
        tileProvider: ForecastTileProvider());

    _tileOverlays = {tileOverlay}.obs;
    _isLoad(!_isLoad.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //color: Colors.blue,
      body: Stack(
        children: [
          Obx(() {
            _isLoad.value;
            return GoogleMap(
              //  markers: markers,
              initialCameraPosition: CameraPosition(target: center, zoom: 6.h),
              onMapCreated: (GoogleMapController controller) {
                googlemapController = controller;
                initTiles();
                _applyMapStyle();
              },
              compassEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              tileOverlays: _tileOverlays,
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
                      weatherScreenController: weatherScreenController)
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
    required this.weatherScreenController,
  });

  final WeatherScreenController weatherScreenController;

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
                      weatherScreenController.pageViewIndex.value = index;
                    },
                    children: [
                      NowTemp(),
                      Daily24HourTemp(),
                      WeeklyTemp(),
                      PreasureWidget(),
                      Wind()
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: WeatherScreenIndicator(
                  weatherScreenController: weatherScreenController),
            )
          ],
        ),
        //   width: 300.w,
      ),
    );
  }
}

class Wind extends StatelessWidget {
  const Wind({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Center(child: Text("Wind")),
    );
  }
}

class PreasureWidget extends StatelessWidget {
  const PreasureWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(child: Text("PreasureWidget")),
    );
  }
}

class WeeklyTemp extends StatelessWidget {
  const WeeklyTemp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(child: Text("WeeklyTemp")),
    );
  }
}

class Daily24HourTemp extends StatelessWidget {
  final Daily24HourTempService service = Daily24HourTempService();
  Daily24HourTemp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        //color: Colors.pink,
        child: Padding(
      padding: EdgeInsets.all(10.0.r),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Container(
              height: 150,
              width: 100,
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, index) {
                    return Container(
                      height: 130,
                      //   width: 100,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ...List.generate(4, (index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: .0),
                                  child: Container(
                                    height: 100,
                                    //width: 70,
                                    //color: Colors.red,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("0$index"),
                                        Image.asset(
                                          WeatherIcons.snow,
                                          width: 50,
                                        ),
                                        const Text("25°"),
                                      ],
                                    ),
                                  ),
                                );
                              })
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              height: 5,
                            ),
                          )
                        ],
                      ),
                    );
                  })),
        ),
      ),
    ));
  }
}

class WeatherScreenIndicator extends StatelessWidget {
  const WeatherScreenIndicator({
    super.key,
    required this.weatherScreenController,
  });

  final WeatherScreenController weatherScreenController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          5,
          (index) => Obx(() {
            return ProjectIndicator(
                firstColor: ColorConstants.blackColor,
                secondColor: ColorConstants.greyColor,
                index: weatherScreenController.pageViewIndex.value,
                isActive: weatherScreenController.pageViewIndex.value == index);
          }),
        ),
      ],
    );
  }
}

class TempViewerWidget extends StatelessWidget {
  const TempViewerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.0.w, bottom: 200.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BluredContainer(
                width: 50.w,
                height: 160.h,
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0.h),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 50.w,
                        height: 20,
                        child: const Center(child: Text("°C")),
                      ),
                      Divider(
                        height: 5,
                        color: ColorConstants.greyColor.withOpacity(0.2),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 120.h,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("40"),
                                Text("20"),
                                Text("0"),
                                Text("-20"),
                                Text("-40")
                              ],
                            ),
                          ),
                          Container(
                            width: 5.w,
                            height: 120.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.deepPurple.withOpacity(0.7),
                                  Colors.indigoAccent.withOpacity(0.7),
                                  Colors.blueAccent[200]!.withOpacity(0.7),
                                  Colors.blue.withOpacity(0.7),
                                  Colors.greenAccent[400]!.withOpacity(0.7),
                                  Colors.white.withOpacity(0.7),
                                  Colors.yellow.withOpacity(0.7),
                                  Colors.orangeAccent[200]!.withOpacity(0.7),
                                  Colors.orangeAccent[400]!.withOpacity(0.7),
                                  Colors.deepOrange.withOpacity(0.7),
                                  Colors.red.withOpacity(0.7)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BluredContainer extends StatelessWidget {
  const BluredContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
  });
  final double? width;
  final double? height;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class NowTemp extends StatelessWidget {
  const NowTemp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 15.0.h),
          child: const Text(
            "11 Ocak Salı",
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
                //width: 120.w,
                height: 90.w,
                WeatherIcons.thunder),
            Column(
              children: [
                Text(
                  "25°",
                  style: TextStyle(
                    color: ColorConstants.blackColor,
                    fontSize: 50.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("Y:20°  D:8°")
              ],
            )
          ],
        ),
      ],
    );
  }
}

class WeatherScreenAppBar extends StatelessWidget {
  const WeatherScreenAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(
          width: 50,
        )
      ],
    );
  }
}
