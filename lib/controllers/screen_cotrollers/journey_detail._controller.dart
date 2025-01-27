import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/controllers/journey_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/models/chat_group.dart';
import 'package:navigationapp/models/route.dart';
import 'package:navigationapp/utils/location_utils.dart';
import 'package:navigationapp/views/components/navigation_marker.dart';
import 'package:widget_to_marker/widget_to_marker.dart';
import 'package:http/http.dart' as http;

class JourneyDetailController extends GetxController {
  final RouteModel route;
  JourneyDetailController({
    //super.key,
    required this.route,
  });
  RxSet<Marker> markers = <Marker>{}.obs;
  var polylines = <Polyline>[].obs;
  var polylineCoordinates = <LatLng>[].obs;
  @override
  void onInit() async {
    super.onInit();
    await getMarkers(route);
  }

  Future<void> setPolylinePoints(
      {required LatLng start, required LatLng destination}) async {
    try {
      String url = "https://maps.googleapis.com/maps/api/directions/json?"
          "origin=${start.latitude},${start.longitude}&"
          "destination=${destination.latitude},${destination.longitude}&"
          "mode=driving&"
          "key=${AppConstants.googleMapsApiKey}";
      var response = await http.get(Uri.parse(url));
      var data = json.decode(response.body);
      var routes = data["routes"];
      if (routes.isNotEmpty) {
        var points = PolylinePoints()
            .decodePolyline(routes[0]["overview_polyline"]["points"]);
        polylineCoordinates.clear();
        polylineCoordinates.addAll(points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList());
        updatePolyline();
      }
    } catch (error) {
      //Get.snackbar("Error", "PolylinePoints could not be set.");
    }
  }

  getMarkers(RouteModel route) async {
    markers.add(Marker(
        markerId: const MarkerId("start"),
        // position: _locationController.currentLocation.value != null
        //     ? _locationController.currentLocation.value!
        //     : center
        position: LatLng(route.startingLocation.latitude,
            route.startingLocation.longitude)));
    markers.add(Marker(
        icon: await NavigationMarker(
          isNight: !(DateTime.now().hour < 19 && DateTime.now().hour > 6),
          icon: IconsConst.flag,
        ).toBitmapDescriptor(
            logicalSize: const Size(200, 200), imageSize: const Size(200, 200)),
        markerId: const MarkerId("end"),
        // position: _locationController.currentLocation.value != null
        //     ? _locationController.currentLocation.value!
        //     : center
        position: LatLng(route.destinationLocation.latitude,
            route.destinationLocation.longitude)));
    //load();
  }

  @override
  void dispose() {
    clearRoute();
    super.dispose();
  }

  void updatePolyline() {
    polylines.clear();
    PolylineId id = const PolylineId("JourneyRouteLive");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 4,
    );
    polylines.add(polyline);
  }

  void clearRoute() {
    polylines.clear();
    polylineCoordinates.clear();
    markers.clear();
    if (Get.isRegistered<JourneyController>()) {
      Get.delete<JourneyController>();
    }
  }

  RxList<ChatGroup> returnGroup = <ChatGroup>[].obs;
  @override
  fetchSharedGroups(List<String> groups) {
    final ChatGroupController chatGroupController = Get.find();

    var _chatGropus = chatGroupController.chatGroups;
    for (var groupName in groups) {
      for (var group in _chatGropus) {
        if (group.id == groupName && !returnGroup.contains(group)) {
          returnGroup.add(group);
          print(group.id);
        }
      }
    }
  }

  listClear() {
    returnGroup.clear();
  }
}
