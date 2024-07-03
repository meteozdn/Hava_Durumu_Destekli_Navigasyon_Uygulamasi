import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_stack/image_stack.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:navigationapp/controllers/map_controller.dart';
import 'package:navigationapp/controllers/map_controller/map_weather_controller.dart';
import 'package:navigationapp/controllers/screen_cotrollers/journey_detail._controller.dart';
import 'package:navigationapp/controllers/screen_cotrollers/journey_live_detail_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';
import 'package:navigationapp/models/route.dart';
import 'package:navigationapp/views/components/blured_container.dart';

class JourneyLiveScreen extends StatelessWidget {
  JourneyLiveScreen({
    super.key,
  });
  // final MapController navMapController = Get.find();
  // final MapWeatherController mapWeatherController = Get.find();
  final JourneyLiveDetailController controller =
      Get.put(JourneyLiveDetailController(route: Get.arguments["route"]));
  final RouteModel route = Get.arguments["route"];
  final DateFormat formatterDate = DateFormat('dd MMMM EEEE', 'tr_TR');
  final DateFormat formatterHour = DateFormat('jm', 'tr_TR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: Obx(() {
              return GoogleMap(
                markers: controller.markers,
                compassEnabled: false,
                polylines: controller.polylines
                    .toSet(), //  scrollGesturesEnabled: false,
                myLocationButtonEnabled: false,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(41.28667, 36.33),
                  zoom: 6,
                ),
                onMapCreated: (mapController) async {
                  await controller.setPolylinePoints(
                      start: LatLng(route.startingLocation.latitude,
                          route.startingLocation.longitude),
                      destination: LatLng(route.destinationLocation.latitude,
                          route.destinationLocation.longitude));
                  //  controller.mapController = mapController;
                },
                zoomControlsEnabled: false,
              );
            }),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _appBar(),
              BluredContainer(
                width: Get.width,
                height: 150,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Son konum: Bolu",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text("Saat: 00.50"),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  IconsConst.windIcon,
                                  width: 55,
                                ),
                                const Text(
                                  "14°C",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  BluredContainer _appBar() {
    return BluredContainer(
      height: 130,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0, top: 70),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                )),
            Text(
              "Metehan",
              style: TextStyle(
                  color: ColorConstants.blackColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold),
            ),
            CircleAvatar()
          ],
        ),
      ),
    );
  }
}
