import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/controllers/route_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:navigationapp/models/chat_group.dart';

class NavigationController extends GetxController {
  //Other controllers.
  final ChatGroupController chatGroupController = Get.find();
  GoogleMapController? mapController;
  final RouteController _routeController = Get.find<RouteController>();

  //Navigation variables.
  var polylines = <Polyline>[].obs;
  Rxn<LatLng> currentLocation = Rxn<LatLng>();
  RxString currentCity = RxString("");

  //Other variables.
  var startingLocation = <String, dynamic>{};
  var destinationLocation = <String, dynamic>{};
  DateTime dateTime = DateTime.now();
  var originSuggestions = [].obs;
  var destinationSuggestions = [].obs;
  final String apiKey = "AIzaSyDA9541Tfh0jVOTKmYz-nFn03i6Eb9cO4E";

  //Yolculuk Planla View
  RxList<ChatGroup> allChatGroups = <ChatGroup>[].obs;
  RxSet<int> selectedChatGroups = <int>{}.obs;
  RxBool isShared = false.obs;
  RxBool isRotateCreated = false.obs;

  void clearSelected() {
    selectedChatGroups.clear();
  }

  void clearPolylines() {
    polylines.clear();
  }

  void isRotateCreatedController() {
    isRotateCreated(!isRotateCreated.value);
  }

  void shareStateChange() {
    isShared(!isShared.value);
  }

  void selectUnselectFunc() {
    if (selectedChatGroups.length == allChatGroups.length) {
      for (var i = 0; i < allChatGroups.length; i++) {
        clearSelected();
      }
    } else {
      for (var index = 0; index < allChatGroups.length; index++) {
        selectedChatGroups.add(index);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    allChatGroups = chatGroupController.chatGroups;
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentLocation.value = LatLng(position.latitude, position.longitude);
      mapController
          ?.animateCamera(CameraUpdate.newLatLng(currentLocation.value!));
      currentCity.value = await _getCityNameFromLatLng(LatLng(
        position.latitude,
        position.longitude,
      ));
      //print('City: ${currentCity.value}');
    } catch (e) {
      Get.snackbar("Error", "Failed to get current location");
    }
  }

  Future<Map<String, dynamic>> setCityNameAndLocation(String address) async {
    LatLng location = await _getLatLngFromAddress(address);
    String cityName = await _getCityNameFromLatLng(location);
    return {"cityName": cityName, "location": location};
  }

  Future<LatLng> _getLatLngFromAddress(String address) async {
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse["results"].isNotEmpty) {
        final location = jsonResponse["results"][0]["geometry"]["location"];
        return LatLng(location["lat"], location["lng"]);
      } else {
        Get.snackbar("Error", "No results found for the provided address.");
        return const LatLng(0, 0);
      }
    } else {
      Get.snackbar("Error", "Failed to fetch coordinates.");
      return const LatLng(0, 0);
    }
  }

  Future<String> _getCityNameFromLatLng(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      Placemark placemark = placemarks.first;
      String cityName = placemark.administrativeArea ?? "Unknown";
      return cityName;
    } catch (error) {
      Get.snackbar("Error", "Failed to find city name.");
      return "Unknown";
    }
  }

  Future<List<LatLng>> getPolylinePoints() async {
    try {
      List<LatLng> polylineCoordinates = [];
      PolylinePoints polylinePoints = PolylinePoints();
      var start = startingLocation["location"];
      var finish = destinationLocation["location"];
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          apiKey,
          PointLatLng(start.latitude, start.longitude),
          PointLatLng(finish.latitude, finish.longitude));
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        return polylineCoordinates;
      } else {
        Get.snackbar("Error", result.errorMessage.toString());
        return [];
      }
    } catch (error) {
      Get.snackbar("Error", "An error occurred while fetching the route.");
      return [];
    }
  }

  void generatePolylineFromPoints({required List<LatLng> points}) {
    PolylineId id = const PolylineId("Unique");
    Polyline polyline =
        Polyline(polylineId: id, color: Colors.black, points: points, width: 8);
    polylines.add(polyline);
  }

  Future<void> saveRoute() async {
    if (startingLocation.isNotEmpty && destinationLocation.isNotEmpty) {
      List<String> sharedChatGroups = [];
      for (var index in selectedChatGroups) {
        sharedChatGroups.add(allChatGroups[index].id);
      }
      var start = startingLocation["location"];
      var finish = destinationLocation["location"];
      await _routeController.createRoute(
        startingLocation: GeoPoint(start.latitude, start.longitude),
        startingCity: startingLocation["cityName"],
        destinationLocation: GeoPoint(finish.latitude, finish.longitude),
        destinationCity: destinationLocation["cityName"],
        dateTime: dateTime,
        sharedChatGroups: sharedChatGroups,
      );
    }
  }

  void fetchOriginSuggestions(String input) async {
    if (input.isEmpty) {
      originSuggestions.clear();
      return;
    }
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String request = '$baseUrl?input=$input&key=$apiKey';
    final response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> predictions = jsonResponse["predictions"];
      originSuggestions.value = predictions
          .map((e) => {
                "description": e["description"],
                "place_id": e["place_id"],
              })
          .toList();
    } else {
      Get.snackbar("Error", "Failed to fetch suggestions");
    }
  }

  void fetchDestinationSuggestions(String input) async {
    if (input.isEmpty) {
      destinationSuggestions.clear();
      return;
    }
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String request = '$baseUrl?input=$input&key=$apiKey';
    final response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> predictions = jsonResponse["predictions"];
      destinationSuggestions.value = predictions
          .map((e) => {
                "description": e["description"],
                "place_id": e["place_id"],
              })
          .toList();
    } else {
      Get.snackbar("Error", "Failed to fetch suggestions");
    }
  }
}
