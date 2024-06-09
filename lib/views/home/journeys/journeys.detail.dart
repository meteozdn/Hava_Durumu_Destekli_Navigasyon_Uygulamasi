import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_stack/image_stack.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:navigationapp/controllers/screen_cotrollers/journey_detail._controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/models/route.dart';

class JourneyDetail extends StatelessWidget {
  JourneyDetail({super.key, required this.route});
  final RouteModel route;
  final DateFormat formatterDate = DateFormat('dd MMMM EEEE', 'tr_TR');
  final DateFormat formatterHour = DateFormat('jm', 'tr_TR');
  final JourneyDetailController journeyDetailController =
      Get.put(JourneyDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Yolculuk Detayları"),
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

                  borderRadius: BorderRadius.circular(15),
                  //    color: ColorConstants.redColor,
                ),
                height: 380,
                width: 350,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        "${formatterDate.format(route.plannedAt)},\n${formatterHour.format(route.plannedAt)}",
                      ),
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          height: 200,
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: GoogleMap(
                                //  scrollGesturesEnabled: false,
                                myLocationButtonEnabled: false,
                                initialCameraPosition: const CameraPosition(
                                  target: LatLng(41.28667, 36.33),
                                  zoom: 10,
                                ),
                                onMapCreated: (mapController) {
                                  //  controller.mapController = mapController;
                                },
                                // polylines: controller.polylines.toSet(),
                                zoomControlsEnabled: false,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: ColorConstants.pictionBlueColor,
                          radius: 27,
                          child: CircleAvatar(
                            foregroundImage: NetworkImage(route.userImage!),
                            radius: 25,
                            backgroundColor: ColorConstants.blackColor,
                          ),
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
                          const Text("3 saat 12 dk"),
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
                            const Icon(Icons.person_add_alt_1)
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
                                              ColorConstants.pictionBlueColor,
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
                                  Padding(
                                    padding: EdgeInsets.only(right: 15.0),
                                    child: Icon(Icons.delete),
                                  )
                                ],
                              );
                            },
                          );
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 50),
              child: Material(
                elevation: 20,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.pictionBlueColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  //color: Colors.red,
                  width: 500,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Yolculuğu sil",
                      style: AppTextStyle.smallWhite
                          .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          ],
        )));
  }
}
