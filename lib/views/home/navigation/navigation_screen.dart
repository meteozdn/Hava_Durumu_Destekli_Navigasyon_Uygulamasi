import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/location_controller.dart';
import 'package:navigationapp/controllers/map_controller.dart';
import 'package:navigationapp/controllers/theme_change_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';

class NavigationScreen extends StatelessWidget {
  NavigationScreen({super.key});
  final ThemeChanger themeChanger = Get.find();
  final LocationController locationController = Get.find();
  final MapController mapController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Obx(() => GoogleMap(
              style: mapController.mapStyle.value,
              //style: ,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              initialCameraPosition:
                  locationController.currentLocation.value != null
                      ? CameraPosition(
                          target: locationController.currentLocation.value!,
                          zoom: 18,
                        )
                      : const CameraPosition(
                          target: LatLng(41.28667, 36.33),
                          zoom: 18,
                        ),
              onMapCreated: (controller) async {
                if (!mapController.googleMapsController.isCompleted) {
                  mapController.googleMapsController.complete(controller);
                } else {
                  mapController.googleMapsController = Completer();
                  mapController.googleMapsController.complete(controller);
                }
                //  controller.setMapStyle(style);
              },
              polylines: mapController.polylines.toSet(),
              zoomControlsEnabled: false,
              markers: mapController.markers.values.toSet())),
          Positioned(
            bottom: 50,
            right: 10,
            left: 10,
            child: Obx(() {
              final isRouteCreated = mapController.isRouteCreated.value;
              final isRouteStarted = mapController.isRouteStarted.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isRouteCreated
                      ? clearRouteButton()
                      : const SizedBox(height: 10),
                  if (isRouteCreated && !isRouteStarted) routeActionButton(),
                  if (isRouteStarted) journeyInformation(),
                  currentLocationButton(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget clearRouteButton() {
    return GestureDetector(
      onTap: () {
        mapController.clearRoute();
      },
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 20,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorConstants.pictionBlueColor,
          ),
          child: const Icon(
            Icons.close,
            color: ColorConstants.whiteColor,
          ),
        ),
      ),
    );
  }

  Widget routeActionButton() {
    return GestureDetector(
      onTap: () async {
        if (mapController.isPlanned) {
          Get.snackbar("Success", "The route has been saved.");
          //await mapController.saveRoute();
          mapController.clearRoute();
        } else {
          Get.snackbar("Navigation", "The navigation has been preparing.");
          //await mapController.saveRoute();
          await mapController.startRoute();
        }
      },
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 20,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorConstants.pictionBlueColor,
          ),
          height: 50,
          width: 200,
          child: Center(
            child: Text(
              mapController.isPlanned
                  ? "Yolculuğu Kayıt Et"
                  : "Yolculuğa Başla",
              style: const TextStyle(
                color: ColorConstants.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget currentLocationButton() {
    return GestureDetector(
      child: Obx(() {
        return CircleAvatar(
          backgroundColor: themeChanger.isLight.value
              ? ColorConstants.pictionBlueColor
              : ColorConstants.darkGrey,
          radius: 30.0,
          child: IconButton(
            color: ColorConstants.whiteColor,
            onPressed: () async {
              if (!mapController.isRouteStarted.value) {
                await locationController.getCurrentLocation();
              } else {
                mapController.isCameraLocked.value =
                    !mapController.isCameraLocked.value;
                mapController.moveCameraToLocation(
                    location: locationController.currentLocation.value!);
                // Get.find<JourneyController>().fetchWeatherData(
                //     locationController.destination.value!.latitude,
                //     locationController.destination.value!.longitude);
              }
            },
            icon: const Icon(Icons.location_searching_outlined),
          ),
        );
      }),
    );
  }

  Widget journeyInformation() {
    return GestureDetector(
      onTap: () {
        locationController.estimatedTimeCalculate();
      },
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 20,
        child: Container(
            height: 100,
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorConstants.whiteColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      locationController.estimatedTime.value,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text("varış")
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      locationController.timeLeft.value,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Obx(() {
                      return Text(
                          locationController.isMinute.value ? "dk" : "sa");
                    }),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      locationController.distanceLeft.value,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text("km"),
                  ],
                ),

                /*Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      locationController.distanceLeft.value,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      locationController.timeLeft.value,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // Text(
                    //   locationController.speed.value,
                    //   style: const TextStyle(
                    //       fontSize: 16, fontWeight: FontWeight.bold),
                    // ),
                  ],
                ),*/
              ],
            )),
      ),
    );
  }
}

class ElevatedWidgetButton extends StatelessWidget {
  const ElevatedWidgetButton({
    super.key,
    required this.width,
    required this.height,
    required this.temp,
    required this.image,
  });
  final int width;
  final double temp;
  final String image;
  final int height;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10.r),
      elevation: 3.h,
      child: GestureDetector(
        onTap: () {
          Get.toNamed(NavigationConstants.weather);
        },
        child: SizedBox(
          width: width.w,
          height: height.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  height: 20.w,
                  child: Image.asset(
                    image,
                    height: 20.h,
                  )),
              Text(
                "${temp.toInt()}°",
                // style: AppTextStyle.midBlack,
              )
            ],
          ),
        ),
      ),
    );
  }
}
