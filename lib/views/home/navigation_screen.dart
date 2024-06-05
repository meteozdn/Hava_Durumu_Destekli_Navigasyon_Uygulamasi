import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/navigation_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class NavigationScreen extends StatelessWidget {
  NavigationScreen({super.key});

  final NavigationController controller = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(41.28667, 36.33),
                  zoom: 10,
                ),
                onMapCreated: (mapController) {
                  controller.mapController = mapController;
                },
                polylines: controller.polylines.toSet(),
                onTap: controller.onMapTapped,
                zoomControlsEnabled: false,
              )),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0, right: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: ColorConstants.pictionBlueColor,
                      radius: 30.0,
                      child: IconButton(
                          color: ColorConstants.whiteColor,
                          onPressed: () async {
                            await controller.getCurrentLocation();
                          },
                          icon: const Icon(Icons.location_searching_outlined)),
                    ),
                  )
                ],
              ),
            ),
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
    );
  }
}
