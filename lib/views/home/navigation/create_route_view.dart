import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/create_route_controller.dart';
import 'package:navigationapp/controllers/location_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class CreateRouteView extends StatelessWidget {
  CreateRouteView({super.key, required this.isPlanned});

  final CreateRouteController controller = Get.find();
  final LocationController locationController = Get.find();
  final FocusNode startFocusNode = FocusNode();
  final FocusNode destinationFocusNode = FocusNode();
  final dateController = TextEditingController();
  final originController = TextEditingController();
  final destinationController = TextEditingController();
  final bool isPlanned;

  @override
  Widget build(BuildContext context) {
    if (!isPlanned) {
      locationController.getCurrentCity().then((cityName) {
        originController.text = cityName;
      });
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
            controller.clearSelections();
            controller.isShared(false);
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.navigate_before_outlined,
            size: 40,
          ),
        ),
        title: Text(!isPlanned ? "Yolculuk Oluştur" : "Yolculuk Planla"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0.w),
          child: Column(
            children: [
              routeTextField(
                controller: originController,
                focusNode: startFocusNode,
                hintText: "Başlangıç",
                suggestions: controller.originSuggestions,
                enabled: isPlanned,
              ),
              routeTextField(
                controller: destinationController,
                focusNode: destinationFocusNode,
                hintText: "Varılacak Yer",
                suggestions: controller.destinationSuggestions,
                enabled: true,
              ),
              if (isPlanned) dateTimePicker(),
              shareSwitch(),
              friendsShareWidget(),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (originController.text.isNotEmpty &&
                      destinationController.text.isNotEmpty) {
                    if (isPlanned && dateController.text.isEmpty) {
                      Get.snackbar("Error", "DateTime should not be empty.");
                    } else if (isPlanned) {
                      await controller.createRouteOnMap(isPlanned: isPlanned);
                    } else {
                      controller.origin["cityName"] =
                          await locationController.getCurrentCity();
                      controller.origin["location"] = await locationController
                          .getCurrentLocation(isCameraMove: false);
                      controller.dateTime = DateTime.now();
                      await controller.createRouteOnMap(isPlanned: isPlanned);
                    }
                  } else {
                    Get.snackbar("Error", "Locations should not be empty.");
                  }
                },
                child: const Text(
                  "Rotayı Görüntüle",
                  style: TextStyle(color: ColorConstants.whiteColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget routeTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required RxList suggestions,
    required bool enabled,
  }) {
    return Column(
      children: [
        TextField(
          enabled: enabled,
          controller: controller,
          focusNode: focusNode,
          onChanged: (value) => this.controller.fetchSuggestions(
                input: value,
                suggestions: suggestions,
              ),
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(Get.context!).size.height * 0.5,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return ListTile(
                  title: Text(suggestion["description"]),
                  onTap: () async {
                    controller.text = suggestion["description"];
                    if (hintText == "Başlangıç") {
                      this.controller.origin = await this
                          .controller
                          .setCityNameAndLocation(controller.text);
                    } else {
                      this.controller.destination = await this
                          .controller
                          .setCityNameAndLocation(controller.text);
                    }
                    suggestions.clear();
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget dateTimePicker() {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.0.h),
      child: TextField(
        controller: dateController,
        readOnly: true,
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            TimeOfDay? time = await showTimePicker(
              context: Get.context!,
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
              dateController.text = picked.toString().substring(0, 16);
              controller.dateTime = DateTime.parse(dateController.text);
            }
          }
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Gün ve Zaman",
          suffixIcon: Icon(Icons.calendar_today),
        ),
      ),
    );
  }

  Widget shareSwitch() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(5)),
      height: 40,
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
                    controller.changeShareState();
                  });
            }),
          )
        ],
      ),
    );
  }

  Widget friendsShareWidget() {
    return Obx(() {
      return controller.isShared.value
          ? Padding(
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
                          final chatGroup = controller.allChatGroups[index];
                          final isSelected =
                              controller.selectedChatGroups.contains(index);
                          return Padding(
                            padding: EdgeInsets.all(5.0.w),
                            child: GestureDetector(
                              onTap: () {
                                if (isSelected) {
                                  controller.selectedChatGroups.remove(index);
                                } else {
                                  controller.selectedChatGroups.add(index);
                                }
                                print(controller.selectedChatGroups);
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 35.r,
                                    backgroundColor: isSelected
                                        ? ColorConstants.greenColor
                                        : ColorConstants.pictionBlueColor,
                                    child: CircleAvatar(
                                      radius: 32.r,
                                      foregroundImage:
                                          NetworkImage(chatGroup.image),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60.w,
                                    child: Center(
                                      child: Text(
                                        chatGroup.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink();
    });
  }
}

class FriendsShareWidget extends StatelessWidget {
  const FriendsShareWidget({
    super.key,
    required this.controller,
  });

  final CreateRouteController controller;

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
