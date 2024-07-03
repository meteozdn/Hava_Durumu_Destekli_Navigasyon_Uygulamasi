import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/controllers/location_controller.dart';
import 'package:navigationapp/controllers/map_controller.dart';
import 'package:navigationapp/controllers/route_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/models/chat_group.dart';
import 'package:http/http.dart' as http;
import 'package:navigationapp/models/route.dart';
import 'package:navigationapp/utils/location_utils.dart';

class CreateRouteController extends GetxController {
  var origin = <String, dynamic>{};
  var destination = <String, dynamic>{};
  var originSuggestions = [].obs;
  var destinationSuggestions = [].obs;
  DateTime dateTime = DateTime.now();
  RxList<ChatGroup> allChatGroups = <ChatGroup>[].obs;
  RxSet<int> selectedChatGroups = <int>{}.obs;
  RxBool isShared = false.obs;
  RxBool isLoad = false.obs;
  @override
  void onInit() async {
    super.onInit();
    final ChatGroupController chatGroupController = Get.find();
    allChatGroups = chatGroupController.chatGroups;
  }

  void changeShareState() {
    isShared(!isShared.value);
  }

  void load() {
    isLoad(!isLoad.value);
  }

  void clearSelections() {
    selectedChatGroups.clear();
  }

  void selectUnselectFunc() {
    if (selectedChatGroups.length == allChatGroups.length) {
      for (var i = 0; i < allChatGroups.length; i++) {
        clearSelections();
      }
    } else {
      for (var index = 0; index < allChatGroups.length; index++) {
        selectedChatGroups.add(index);
      }
    }
  }

  Future<void> createRouteOnMap({required bool isPlanned}) async {
    try {
      LatLng start = await origin["location"];
      LatLng finish = await destination["location"];
      List<String> sharedChatGroups = [];
      for (var index in selectedChatGroups) {
        sharedChatGroups.add(allChatGroups[index].id);
      }
      RouteModel route = Get.find<RouteController>().createRouteModel(
        startingLocation: GeoPoint(start.latitude, start.longitude),
        startingCity: origin["cityName"],
        destinationLocation: GeoPoint(finish.latitude, finish.longitude),
        destinationCity: destination["cityName"],
        dateTime: dateTime,
        sharedChatGroups: sharedChatGroups,
      );
      var mapController = Get.find<MapController>();
      mapController.setRouteModel(route: route, isPlanned: isPlanned);
      await mapController.setPolylinePoints(start: start, destination: finish);
      await mapController.moveCameraToAllRoute();
      var locationController = Get.find<LocationController>();
      locationController.destination.value = finish;
      mapController.isRouteCreated.value = true;
    } catch (error) {
      // Get.snackbar("Error", error.toString());
    }
  }

  Future<Map<String, dynamic>> setCityNameAndLocation(String address) async {
    LatLng location = await LocationUtils.getLatLngFromAddress(address);
    String cityName = await LocationUtils.getCityNameFromLatLng(location);
    return {"cityName": cityName, "location": location};
  }

  void fetchSuggestions(
      {required String input, required RxList<dynamic> suggestions}) async {
    if (input.isEmpty) {
      suggestions.clear();
      return;
    }
    try {
      const String baseUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      final String request =
          "$baseUrl?input=$input&key=${AppConstants.googleMapsApiKey}";
      final response = await http.get(Uri.parse(request));
      final jsonResponse = json.decode(response.body);
      final List<dynamic> predictions = jsonResponse["predictions"];
      suggestions.value = predictions
          .map((e) => {
                "description": e["description"],
                "place_id": e["place_id"],
              })
          .toList();
    } catch (error) {
      Get.snackbar("Error", "Failed to fetch suggestions.");
    }
  }
}
