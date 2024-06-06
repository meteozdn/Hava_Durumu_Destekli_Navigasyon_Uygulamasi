import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/navigation_controller.dart';

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
        title: const Text("Yolculuk Oluştur"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                          final placeDetails = await controller
                              .fetchPlaceDetails(suggestion["place_id"]);
                          Get.defaultDialog(
                              middleText:
                                  "Selected Origin City: ${placeDetails["cityName"]}");
                          Get.defaultDialog(
                              middleText:
                                  "Selected Origin GeoPoint: ${placeDetails["location"].latitude}, ${placeDetails["location"].longitude}");
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
                          final placeDetails = await controller
                              .fetchPlaceDetails(suggestion["place_id"]);
                          Get.defaultDialog(
                              middleText:
                                  "Selected Destination City: ${placeDetails["cityName"]}");
                          Get.defaultDialog(
                              middleText:
                                  "Selected Destination GeoPoint: ${placeDetails["location"].latitude}, ${placeDetails["location"].longitude}");
                          controller.destinationSuggestions.clear();
                        },
                      );
                    },
                  ),
                );
              }),
              if (isPlanned)
                TextField(
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
                      }
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Gün ve Zaman",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (originController.text.isNotEmpty &&
                      destinationController.text.isNotEmpty) {
                    if (isPlanned && dateController.text.isNotEmpty) {
                      await Get.find<NavigationController>().fetchRoute(
                        origin: originController.text,
                        destination: destinationController.text,
                        //dateTime: dateController.text,
                      );
                    } else {
                      await Get.find<NavigationController>().fetchRoute(
                          origin: originController.text,
                          destination: destinationController.text);
                    }
                  }
                  Navigator.pop(context);
                },
                child: const Text("Rotayı Görüntüle"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
