import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/navigation_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class CreateRouteView extends StatelessWidget {
  CreateRouteView({super.key, required this.isPlanned});

  final NavigationController controller = Get.find<NavigationController>();
  final FocusNode startFocusNode = FocusNode();
  final FocusNode destinationFocusNode = FocusNode();
  final dateController = TextEditingController();
  final originController = TextEditingController();
  final destinationController = TextEditingController();
  final bool isPlanned;

  @override
  Widget build(BuildContext context) {
    if (!controller.isRotateCreated.value) {
      controller.clearSelected();
    }
    if (!isPlanned) {
      originController.text = "Şimdiki Konum";
      dateController.text = "Not Applicable";
    }

    startFocusNode.addListener(() {
      if (!startFocusNode.hasFocus) {
        controller.originSuggestions.clear();
      }
    });
    destinationFocusNode.addListener(() {
      if (!destinationFocusNode.hasFocus) {
        controller.destinationSuggestions.clear();
      }
    });
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            controller.clearSelected();
            controller.isShared(false);
            Get.back();
          },
          child: const Icon(
            Icons.navigate_before_outlined,
            size: 40,
          ),
        ),
        title: Text(!isPlanned ? "Yolculuk Oluştur" : "Yolculuk Planla"),
      ),
      body: SingleChildScrollView(
        //    padding: EdgeInsets.all(0),
        child: Padding(
          padding: EdgeInsets.all(10.0.w),
          child: Column(
            children: [
              TextField(
                enabled: isPlanned,
                controller: originController,
                focusNode: startFocusNode,
                onChanged: (value) => controller.fetchOriginSuggestions(value),
                decoration: const InputDecoration(
                  hintText: "Başlangıç",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.originSuggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = controller.originSuggestions[index];
                      return ListTile(
                        title: Text(suggestion["description"]),
                        onTap: () async {
                          originController.text = suggestion["description"];
                          controller.startingLocation = await controller
                              .setCityNameAndLocation(originController.text);
                          controller.originSuggestions.clear();
                        },
                      );
                    },
                  ),
                );
              }),
              TextField(
                controller: destinationController,
                focusNode: destinationFocusNode,
                onChanged: (value) =>
                    controller.fetchDestinationSuggestions(value),
                decoration: const InputDecoration(
                  hintText: "Varılacak Yer",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.destinationSuggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion =
                          controller.destinationSuggestions[index];
                      return ListTile(
                        title: Text(suggestion["description"]),
                        onTap: () async {
                          destinationController.text =
                              suggestion["description"];
                          controller.destinationLocation =
                              await controller.setCityNameAndLocation(
                                  destinationController.text);
                          controller.destinationSuggestions.clear();
                        },
                      );
                    },
                  ),
                );
              }),
              if (isPlanned)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextField(
                    controller: dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          initialEntryMode: TimePickerEntryMode.dial,
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            );
                          },
                        );
                        if (time != null) {
                          picked = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                            time.hour,
                            time.minute,
                          );
                          dateController.text =
                              picked.toString().substring(0, 16);
                          controller.dateTime =
                              DateTime.parse(dateController.text);
                        }
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Gün ve Zaman",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              //Chat Groups List
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5.r)),
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Arkadaşlarımla Paylaş"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(() {
                            return Switch(
                                value: controller.isShared.value,
                                onChanged: (bool value) {
                                  controller.shareStateChange();
                                });
                          }),
                        )
                      ],
                    ),
                  ),
                  Obx(() {
                    return Container(
                      child: controller.isShared.value
                          ? FriendsShareWidget(controller: controller)
                          : const SizedBox.shrink(),
                    );
                  }),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (originController.text.isNotEmpty &&
                        destinationController.text.isNotEmpty) {
                      if (isPlanned && dateController.text.isNotEmpty) {
                        await controller.getPolylinePoints().then((points) {
                          controller.generatePolylineFromPoints(points: points);
                        });
                      } else {
                        await controller.getCurrentLocation();
                        controller.startingLocation["cityName"] =
                            controller.currentCity.value;
                        controller.startingLocation["location"] =
                            controller.currentLocation.value;
                        controller.dateTime = DateTime.now();
                        await controller.getPolylinePoints().then((points) {
                          controller.generatePolylineFromPoints(points: points);
                        });
                      }
                    }
                    controller.isRotateCreatedController();
                    Navigator.pop(context);
                  },
                  child: const Text("Rotayı Görüntüle"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendsShareWidget extends StatelessWidget {
  const FriendsShareWidget({
    super.key,
    required this.controller,
  });

  final NavigationController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  child: const Text("Hepsini seç"),
                  onTap: () {
                    controller.selectUnselectFunc();
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 90.h,
            child: Obx(() {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.allChatGroups.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(5.0.w),
                    child: GestureDetector(
                      onTap: () {
                        if (controller.selectedChatGroups.contains(index)) {
                          controller.selectedChatGroups.remove(index);
                        } else {
                          controller.selectedChatGroups.add(index);
                        }
                        print(controller.selectedChatGroups);
                      },
                      child: Obx(() {
                        return Column(
                          children: [
                            CircleAvatar(
                              radius: 35.r,
                              backgroundColor:
                                  controller.selectedChatGroups.contains(index)
                                      ? ColorConstants.greenColor
                                      : ColorConstants.pictionBlueColor,
                              child: CircleAvatar(
                                radius: 32.r,
                                foregroundImage: NetworkImage(
                                    controller.allChatGroups[index].image),
                              ),
                            ),
                            SizedBox(
                                width: 60.w,
                                child: Center(
                                  child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                      controller.allChatGroups[index].name),
                                ))
                          ],
                        );
                      }),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
