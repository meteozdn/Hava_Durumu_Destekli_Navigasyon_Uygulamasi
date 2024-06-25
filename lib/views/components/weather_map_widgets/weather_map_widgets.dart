import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:navigationapp/controllers/map_controller/map_weather_controller.dart';
import 'package:navigationapp/controllers/theme_change_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/services/weather_service/weathers_service.dart';
import 'package:navigationapp/views/components/blured_container.dart';
import 'package:navigationapp/views/components/indicator.dart';
import 'package:navigationapp/views/components/weather_map_widgets/weather_map_marker.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Wind extends StatelessWidget {
  final MapWeatherController _mapWeatherController = Get.find();

  Wind({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() {
        return _mapWeatherController.currentWeatherModel.value.wind == null
            ? const CircularProgressIndicator()
            : Row(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Image.asset(
                        ImageConst.compass,
                        width: 150.w,
                      ),
                      SizedBox(
                        width: 100.w,
                        height: 100.w,
                        child: Transform.rotate(
                          angle: _mapWeatherController
                                  .currentWeatherModel.value.wind!.deg! *
                              0.0174532925.toDouble(),
                          child: Image.asset(
                            ImageConst.arrow,
                          ),
                        ),
                      ),
                      CircleAvatar(
                          radius: 15.r,
                          backgroundColor: ColorConstants.blackColor,
                          child: Image.asset(
                            IconsConst.windIcon,
                            width: 20.w,
                          ))
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _mapWeatherController
                                  .currentWeatherModel.value.wind!.speed!
                                  .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40.sp,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "km/sa",
                                  ),
                                  Text("Rüzgar")
                                ],
                              ),
                            )
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Divider(
                            height: 20,
                            thickness: 2,
                            color: ColorConstants.greyColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _mapWeatherController.currentWeatherModel.value
                                          .wind!.gust ==
                                      null
                                  ? "?"
                                  : _mapWeatherController
                                      .currentWeatherModel.value.wind!.gust
                                      .toString(),
                              style: TextStyle(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "km/sa",
                                  ),
                                  Text("Ani Rüzgar")
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
      }),
    );
  }
}

class PreasureWidget extends StatelessWidget {
  final MapWeatherController _mapWeatherController = Get.find();

  PreasureWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Obx(() {
      return _mapWeatherController.currentWeatherModel.value.main == null
          ? const CircularProgressIndicator()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hava Basıncı",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    Text(
                      "${_mapWeatherController.currentWeatherModel.value.main!.pressure} hPa",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.sp),
                    )
                  ],
                ),
                SizedBox(
                  width: 150.w,
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                          axisLineStyle: const AxisLineStyle(
                            color: ColorConstants.lightBlue,
                            thickness: 0.2,
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                          ranges: const <GaugeRange>[],
                          maximumLabels: 0,
                          showLastLabel: true,

                          //radiusFactor: 1,
                          maximum: 1070,
                          minimum: 950,
                          //  axisLineStyle: const AxisLineStyle(color: Colors.white),
                          pointers: <GaugePointer>[
                            MarkerPointer(
                              enableAnimation: true,
                              value: _mapWeatherController
                                  .currentWeatherModel.value.main!.pressure!
                                  .toDouble(),
                              markerType: MarkerType.circle,
                            ),
                          ])
                    ],
                  ),
                )
              ],
            );
    }));
  }
}

class WeeklyTemp extends StatelessWidget {
  const WeeklyTemp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //List<String>
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...List.generate(5, (index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Çarş"),
              Image.asset(
                WeatherIcons.partlyCloudy,
                height: 40,
              ),
              Text("25C")
            ],
          );
        })
      ],
    );
  }
}

class AirClean extends StatelessWidget {
  const AirClean({
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
            title: const Text('AQI Nedir?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  SfLinearGauge(
                    maximum: 500,
                    ranges: const [
                      LinearGaugeRange(
                          startValue: 0,
                          endValue: 84,
                          color: ColorConstants.greenColor),
                      LinearGaugeRange(
                        startValue: 84,
                        endValue: 167,
                        color: ColorConstants.yellowColor,
                      ),
                      LinearGaugeRange(
                        startValue: 167,
                        endValue: 251,
                        color: ColorConstants.leftPlateColor,
                      ),
                      LinearGaugeRange(
                        startValue: 251,
                        endValue: 335,
                        color: ColorConstants.orangeColor,
                      ),
                      LinearGaugeRange(
                        startValue: 335,
                        endValue: 420,
                        color: ColorConstants.pastelMagentaColor,
                      ),
                      LinearGaugeRange(
                          startValue: 420,
                          endValue: 500,
                          color: ColorConstants.blackPurpleColor),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                        'Hava Kalitesi Endeksi(AQI) belirli bir yerdeki havanın kalitesinin ifade edilmesi için kullanılan ölçüdür. Hava Kalitesi ölçümlerinde gösterge sayısının yükselmesi artan hava kirliliği yüzdesinin ciddi sağlık sorunlarına neden olacağını belirtir. Hava Kalitesi Endeksi değerleri aşamalara göre sınıflandırılmıştır ve her aşama birer renk ile simgelenir. Renkler ve risk aralıkları ülkeden ülkeye değişebilir.'),
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 150,
            child: Column(
              children: [
                Image.asset(
                  ImageConst.smile,
                  width: 50,
                ),
                const Text(
                  "Normal",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const Text(
                  "Nefes almakta zorlanıyorsanız açık havaya çıkın.",
                  maxLines: 5, textAlign: TextAlign.center,
                  //overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150.w,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              //axisValue: 50,
                              positionFactor: 0.1,
                              widget: Text(
                                '50',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40.sp),
                              ))
                        ],
                        axisLineStyle: const AxisLineStyle(
                          thickness: 0.2,
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        showLabels: false,
                        showAxisLine: false,
                        showTicks: false,
                        minimum: 0,
                        maximum: 500,
                        ranges: <GaugeRange>[
                          GaugeRange(
                            startValue: 0,
                            endValue: 83,
                            color: ColorConstants.greenColor,
                          ),
                          GaugeRange(
                            startValue: 86,
                            endValue: 167,
                            color: ColorConstants.yellowColor,
                          ),
                          GaugeRange(
                            startValue: 170,
                            endValue: 251,
                            color: ColorConstants.leftPlateColor,
                          ),
                          GaugeRange(
                            startValue: 254,
                            endValue: 335,
                            color: ColorConstants.orangeColor,
                          ),
                          GaugeRange(
                            startValue: 338,
                            endValue: 419,
                            color: ColorConstants.pastelMagentaColor,
                          ),
                          GaugeRange(
                            startValue: 422,
                            endValue: 500,
                            color: ColorConstants.purpleColor,
                          ),
                        ],
                        pointers: const <GaugePointer>[
                          MarkerPointer(
                            markerOffset: -8,
                            //markerType: MarkerType.dia,
                            //markerHeight: 20,
                            //markerWidth: 20,
                            value: 60,
                          )
                        ])
                  ],
                ),
                GestureDetector(
                  child: const Icon(Icons.info_outline_rounded),
                  onTap: () {
                    _showAlertDialog();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Daily24HourTemp extends StatelessWidget {
//  final Daily24HourTempService service = Daily24HourTempService();
  const Daily24HourTemp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0.r),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: SizedBox(
              height: 150,
              width: 100,
              child: Center(
                child: ListView.builder(
                    padding: MediaQuery.of(context).padding.copyWith(
                          top: 3,
                          left: 0,
                          right: 0,
                          //  bottom: 50,
                        ),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, index) {
                      return SizedBox(
                        height: 120,
                        //   width: 100,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ...List.generate(4, (index) {
                                  return SizedBox(
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("0$index"),
                                        Image.asset(
                                          WeatherIcons.snow,
                                          width: 50,
                                        ),
                                        const Text(
                                          "25°",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(
                                height: 3,
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              )),
        ),
      ),
    );
  }
}

class WeatherScreenIndicator extends StatelessWidget {
  const WeatherScreenIndicator({
    super.key,
    required this.mapWeatherController,
  });

  final MapWeatherController mapWeatherController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          6,
          (index) => Obx(() {
            return ProjectIndicator(
                firstColor: ColorConstants.blackColor,
                secondColor: ColorConstants.greyColor,
                index: mapWeatherController.pageViewIndex.value,
                isActive: mapWeatherController.pageViewIndex.value == index);
          }),
        ),
      ],
    );
  }
}

class TempViewerWidget extends StatelessWidget {
  final ThemeChanger theme = Get.find();
  TempViewerWidget({
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
              //WeatherMarker(),
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

class NowTemp extends StatelessWidget {
  final MapWeatherController _mapWeatherController = Get.find();

  NowTemp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      _mapWeatherController.load();
      return _mapWeatherController.currentWeatherModel.value.main == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.0.h),
                  child: Text(_mapWeatherController.getdate()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                        //width: 120.w,
                        height: 100.w,
                        _mapWeatherController.getIcon()),
                    Column(
                      children: [
                        Text(
                          "${_mapWeatherController.currentWeatherModel.value.main!.temp!.toInt()}°C",
                          style: TextStyle(
                            color: ColorConstants.blackColor,
                            fontSize: 60.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            "Y:${(_mapWeatherController.currentWeatherModel.value.main!.tempMax! + 2.1).toInt()}°  D:${(_mapWeatherController.currentWeatherModel.value.main!.tempMin! - 3.27).toInt()}°")
                      ],
                    )
                  ],
                ),
              ],
            );
    });
  }
}
