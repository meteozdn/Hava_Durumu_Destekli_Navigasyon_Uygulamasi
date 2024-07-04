import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_stack/image_stack.dart';
import 'package:intl/intl.dart';
import 'package:navigationapp/controllers/map_controller.dart';
import 'package:navigationapp/controllers/route_controller.dart';
import 'package:navigationapp/controllers/screen_cotrollers/journey_detail._controller.dart';
import 'package:navigationapp/controllers/theme_change_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';
import 'package:navigationapp/models/route.dart';
import 'package:navigationapp/views/components/blured_container.dart';

class JourneyDetail extends StatelessWidget {
  JourneyDetail({super.key, required this.route, required this.isOwner});
  final bool isOwner;
  final RouteModel route;
  final DateFormat formatterDate = DateFormat('dd MMMM EEEE', 'tr_TR');
  final DateFormat formatterHour = DateFormat('jm', 'tr_TR');
  final RouteController routeController = Get.find();
  final ThemeChanger themeChanger = Get.find();
  // JourneyDetail({super.key, required this.route});
  // final RouteModel route;
  // final DateFormat formatterDate = DateFormat('dd MMMM EEEE', 'tr_TR');
  // final DateFormat formatterHour = DateFormat('jm', 'tr_TR');

  final JourneyDetailController journeyDetailController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                journeyDetailController.clearRoute();
                Get.back();
              },
              child: const Icon(Icons.arrow_back_ios_new_outlined)),
          title: const Text("Yolculuk Detayları"),
          actions: [
            isOwner
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.redAccent,
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                  )
                : const SizedBox()
          ],
        ),
        body: Center(
            child: Column(
          children: [
            Material(
              elevation: 20,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: themeChanger.isLight.value
                      ? ColorConstants.lightGrey
                      : ColorConstants.darkGrey,
                  borderRadius: BorderRadius.circular(15),
                  //    color: ColorConstants.redColor,
                ),
                height: 380,
                width: 350,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        "${formatterDate.format(route.plannedAt)},\n${formatterHour.format(route.plannedAt)}",
                      ),
                    ),
                    Stack(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            SizedBox(
                              height: 200,
                              width: 300,
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                  ),
                                  child: Stack(
                                    children: [
                                      Obx(() {
                                        return GoogleMap(
                                          zoomGesturesEnabled: false,
                                          scrollGesturesEnabled: false,
                                          //  scrollGesturesEnabled: false,
                                          myLocationButtonEnabled: false,
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                              route.startingLocation.latitude,
                                              route.startingLocation.longitude,
                                            ),
                                            zoom: 6,
                                          ),
                                          markers: {
                                            Marker(
                                                markerId:
                                                    const MarkerId("start"),
                                                position: LatLng(
                                                    route.startingLocation
                                                        .latitude,
                                                    route.startingLocation
                                                        .longitude))
                                          },
                                          onMapCreated: (mapController) async {
                                            await journeyDetailController
                                                .setPolylinePoints(
                                                    start: LatLng(
                                                        route
                                                            .startingLocation.latitude,
                                                        route.startingLocation
                                                            .longitude),
                                                    destination: LatLng(
                                                        route
                                                            .destinationLocation
                                                            .latitude,
                                                        route
                                                            .destinationLocation
                                                            .longitude));
                                            //  controller.mapController = mapController;
                                          },
                                          polylines: journeyDetailController
                                              .polylines
                                              .toSet(),
                                          zoomControlsEnabled: false,
                                        );
                                      }),
                                      false
                                          // ignore: dead_code
                                          ? const BluredContainer(
                                              height: 200,
                                              width: 300,
                                              child: Center(
                                                  child: Text(
                                                "Yolculuk Tamamlandı.",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            )
                                          : SizedBox.shrink()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            !isOwner
                                ? ElevatedButton(
                                    onPressed: () {
                                      Get.toNamed(
                                        NavigationConstants.liveJourney,
                                        arguments: {
                                          "route": route,
                                        },
                                      );
                                    },
                                    child: const Icon(Icons.broadcast_on_home))
                                : const SizedBox()
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: ColorConstants.blackColor,
                              radius: 27,
                              child: CircleAvatar(
                                foregroundImage: NetworkImage(route.userImage!),
                                radius: 25,
                                backgroundColor: ColorConstants.blackColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            route.startingCity,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          //const Text("3 saat 12 dk"),
                          Text(
                            route.destinationCity,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Obx(() {
                        journeyDetailController
                            .fetchSharedGroups(route.sharedChatGroups);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 50,
                              child: ImageStack(
                                imageList: [
                                  ...List.generate(
                                      journeyDetailController
                                          .returnGroup.length, (index) {
                                    return journeyDetailController
                                        .returnGroup[index].image;
                                  })
                                ],
                                imageRadius: 50, // Radius of each images
                                imageCount:
                                    2, // Maximum number of images to be shown
                                imageBorderWidth: 3,
                                totalCount: journeyDetailController.returnGroup
                                    .length, // Border width around the images
                              ),
                            ),
                            //const Icon(Icons.person_add_alt_1)
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: SizedBox(
                  height: 200,
                  width: 350,
                  child: Obx(() {
                    return journeyDetailController.returnGroup.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    IconsConst.friends,
                                    height: 100,
                                  ),
                                  const Text("Paylaşılan Arkadaş Bulunamadı.")
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                journeyDetailController.returnGroup.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, left: 20),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              ColorConstants.blackColor,
                                          radius: 26,
                                          child: CircleAvatar(
                                            foregroundImage: NetworkImage(
                                                journeyDetailController
                                                    .returnGroup[index].image),
                                            radius: 25,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(journeyDetailController
                                              .returnGroup[index].name),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 15.0),
                                    //child: Icon(Icons.delete),
                                  )
                                ],
                              );
                            },
                          );
                  }),
                ),
              ),
            ),
            if (isOwner) startRouteButton(context),
          ],
        )));
  }

  Widget startRouteButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showStartRouteDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 20,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorConstants.pictionBlueColor,
            ),
            height: 50,
            width: 300,
            child: Center(
              child: Text(
                "Yolculuğu Başlat",
                style: AppTextStyle.smallWhite
                    .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Planlı Yolculuğu Kaldır"),
          content: const Text(
              "Planlanmış yolculuğu silmek istediğinizden emin misiniz?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                await routeController.deleteRoute(routeId: route.id);
              },
              child: const Text("Sil"),
            ),
          ],
        );
      },
    );
  }

  void _showStartRouteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Planlı Yolculuğu Başlat"),
          content: Text(
              "${route.plannedAt.toString().substring(0, 16)}\nTarihine planlanmış yolculuğu başlatmak istediğinizden emin misiniz?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                await Get.find<MapController>().setPlannedRoute(route: route);
              },
              child: const Text("Başlat"),
            ),
          ],
        );
      },
    );
  }
}
