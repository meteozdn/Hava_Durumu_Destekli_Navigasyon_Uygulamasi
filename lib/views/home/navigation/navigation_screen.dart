import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/location_controller.dart';
import 'package:navigationapp/controllers/map_controller.dart';
import 'package:navigationapp/controllers/saved_routes.dart';
import 'package:navigationapp/controllers/theme_change_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';

class NavigationScreen extends StatelessWidget {
  NavigationScreen({super.key});
  final ThemeChanger themeChanger = Get.find();
  final LocationController locationController = Get.find();
  final MapController mapController = Get.find();
  SavedRoutesController savedRoutes = Get.put(SavedRoutesController());

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
              markers: mapController.markers.toSet())),
          Positioned(
            top: 130,
            bottom: 500,
            right: 20,
            left: 20,
            child: Obx(() {
              final isRouteStarted = mapController.isRouteStarted.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isRouteStarted) directionInstructions(),
                  // if (true) directionInstructions(),
                ],
              );
            }),
          ),
          Obx(() {
            final isRouteCreated = mapController.isRouteCreated.value;
            final isRouteStarted = mapController.isRouteStarted.value;
            return Visibility(
              visible: isRouteCreated,
              child: Positioned(
                  bottom: 120,
                  right: 10,
                  left: 320,
                  child: GestureDetector(
                    onTap: () async {
                      if (!isRouteStarted) {
                        savedRoutes.addSaved(mapController.route);
                        print("object");
                      } else {
                        await mapController.recalculateRoute();
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: themeChanger.isLight.value
                          ? ColorConstants.pictionBlueColor
                          : ColorConstants.darkGrey,
                      child: Icon(
                        size: 20,
                        isRouteStarted ? Icons.alt_route : Icons.bookmark,
                        color: ColorConstants.whiteColor,
                      ),
                    ),
                  )),
            );
          }),
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
                  // if (true) journeyInformation(),
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
          //Get.snackbar("Route", "The route has been saved.");
          await mapController.saveRoute().then((_) async {
            //await mapController.startRoute();
            mapController.clearRoute();
          });
        } else {
          //Get.snackbar("Navigation", "The navigation has been preparing.");
          if (mapController.isSaved) {
            await mapController.startRoute();
          } else {
            await mapController.saveRoute().then((_) async {
              await mapController.startRoute();
            });
          }
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
              }
            },
            icon: mapController.isCameraLocked.value
                ? const Icon(Icons.location_searching_outlined)
                : const Icon(Icons.location_pin),
          ),
        );
      }),
    );
  }

  Widget journeyInformation() {
    return GestureDetector(
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 20,
        child: Container(
            height: 100,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: themeChanger.isLight.value
                  ? ColorConstants.pictionBlueColor
                  : ColorConstants.darkGrey,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  locationController.distanceLeft.value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  locationController.timeLeft.value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
              ],
            )),
      ),
    );
  }

  Widget directionInstructions() {
    return GestureDetector(
        child: Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 10,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeChanger.isLight.value
              ? ColorConstants.pictionBlueColor
              : ColorConstants.darkGrey,
        ),
        width: 350,
        height: 150,
        child: Center(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Obx(() {
                  String instruction = mapController.instruction.value;
                  String distance = mapController.instructionDistance.value;
                  return Row(
                    children: [
                      //TODO getIcon()'u serviten gelen veriyi vererek çalıştır <3
                      Icon(
                        getIcon("Turn left onto Main St"),
                        color: ColorConstants.whiteColor,
                        size: 50,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                instruction,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 8.0),
                            //   child: Text(
                            //     distance,
                            //     maxLines: 2,
                            //     style: const TextStyle(
                            //       fontSize: 16,
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      )
                    ],
                  );
                }))),
      ),
    ));
  }

  IconData getIcon(String instruction) {
    if (instruction.contains(NavigationConsts.northEast)) {
      return Icons.north_west;
    } else if (instruction.contains(NavigationConsts.northEast)) {
      return Icons.north_east;
    } else if (instruction.contains(NavigationConsts.southEast)) {
      return Icons.south_east;
    } else if (instruction.contains(NavigationConsts.southWest)) {
      return Icons.south_west;
    } else if (instruction.contains(NavigationConsts.north) ||
        instruction.contains(NavigationConsts.straight)) {
      return Icons.north;
    } else if (instruction.contains(NavigationConsts.west) ||
        instruction.contains(NavigationConsts.left)) {
      return Icons.west;
    } else if (instruction.contains(NavigationConsts.east) ||
        instruction.contains(NavigationConsts.right)) {
      return Icons.east;
    } else if (instruction.contains(NavigationConsts.south)) {
      return Icons.south;
    }
    return Icons.north;
  }
}

class DirectionsViewWidget extends StatelessWidget {
  const DirectionsViewWidget(
      {super.key, required this.themeChanger, required this.mapController});

  final ThemeChanger themeChanger;
  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 10,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeChanger.isLight.value
              ? ColorConstants.pictionBlueColor
              : ColorConstants.darkGrey,
        ),
        width: 500,
        height: 150,
        child: Center(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Obx(() {
                  String instruction = "instruction is null";
                  String distance = "distance is null";
                  try {
                    instruction =
                        mapController.directions[0]["instruction"].toString();
                    distance =
                        mapController.directions[0]["distance"].toString();
                  } catch (error) {
                    print(error.toString());
                  }
                  return Row(
                    children: [
                      //TODO getIcon()'u serviten gelen veriyi vererek çalıştır <3
                      Icon(
                        getIcon("Turn left onto Main St"),
                        color: ColorConstants.whiteColor,
                        size: 50,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                instruction,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                distance,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                }))),
      ),
    );
  }

  IconData getIcon(String instruction) {
    if (instruction.contains(NavigationConsts.northEast)) {
      return Icons.north_west;
    } else if (instruction.contains(NavigationConsts.northEast)) {
      return Icons.north_east;
    } else if (instruction.contains(NavigationConsts.southEast)) {
      return Icons.south_east;
    } else if (instruction.contains(NavigationConsts.southWest)) {
      return Icons.south_west;
    } else if (instruction.contains(NavigationConsts.north) ||
        instruction.contains(NavigationConsts.straight)) {
      return Icons.north;
    } else if (instruction.contains(NavigationConsts.west) ||
        instruction.contains(NavigationConsts.left)) {
      return Icons.west;
    } else if (instruction.contains(NavigationConsts.east) ||
        instruction.contains(NavigationConsts.right)) {
      return Icons.east;
    } else if (instruction.contains(NavigationConsts.south)) {
      return Icons.south;
    }
    return Icons.north;
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
