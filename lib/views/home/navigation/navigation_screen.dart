import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/navigation_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';

class NavigationScreen extends StatelessWidget {
  NavigationScreen({super.key});

  final NavigationController controller = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Obx(() => GoogleMap(
                myLocationButtonEnabled: false,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(41.28667, 36.33),
                  zoom: 10,
                ),
                onMapCreated: (mapController) {
                  controller.mapController = mapController;
                },
                polylines: controller.polylines.toSet(),
                zoomControlsEnabled: false,
              )),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, right: 10.0, left: 10),
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   mainAxisSize: MainAxisSize.min,
                children: [
                  controller.isRotateCreated.value
                      ? GestureDetector(
                          onTap: () {
                            //rota silinecek
                            controller.polylines.clear();
                            controller.isRotateCreatedController();
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
                        )
                      : const SizedBox(
                          width: 50,
                        ),
                  GestureDetector(
                    onTap: () {
                      controller.isRotateCreatedController();
                      controller.saveRoute();
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 20,
                      child: controller.isRotateCreated.value
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ColorConstants.pictionBlueColor,
                              ),
                              height: 50,
                              width: 200,
                              child: const Center(
                                child: Text(
                                  "Yolculuğa Başla",
                                  style: TextStyle(
                                      color: ColorConstants.whiteColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : const SizedBox(
                              width: 200,
                            ),
                    ),
                  ),
                  GestureDetector(
                    child: SizedBox(
                      width: 60.w,
                      child: CircleAvatar(
                        backgroundColor: ColorConstants.pictionBlueColor,
                        radius: 30.0,
                        child: IconButton(
                            color: ColorConstants.whiteColor,
                            onPressed: () async {
                              await controller.getCurrentLocation();
                            },
                            icon:
                                const Icon(Icons.location_searching_outlined)),
                      ),
                    ),
                  )
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}

class ElevatedWidgetButton extends StatelessWidget {
  const ElevatedWidgetButton({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.image,
  });
  final int width;
  final String text;
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
                "$text°",
                style: AppTextStyle.midBlack,
              )
            ],
          ),
        ),
      ),
    );
  }
}
