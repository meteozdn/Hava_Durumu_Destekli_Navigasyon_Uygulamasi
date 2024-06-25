import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigationapp/controllers/journey_controller.dart';
import 'package:navigationapp/controllers/route_controller.dart';
import 'package:navigationapp/controllers/theme_change_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/models/route.dart';
import 'package:navigationapp/utils/location_utils.dart';
import 'package:http/http.dart' as http;

class MapController extends GetxController {
  late Completer<GoogleMapController> googleMapsController = Completer();
  late RouteModel route;
  bool isPlanned = false;
  RxBool isRouteStarted = false.obs;
  RxBool isRouteCreated = false.obs;
  RxBool isCameraLocked = true.obs;
  var markers = <MarkerId, Marker>{}.obs;
  var polylines = <Polyline>[].obs;
  var polylineCoordinates = <LatLng>[].obs;
  RxString mapStyle = "".obs;

  @override
  void onInit() async {
    super.onInit();
    await setMapStyle();
    // Listen to authentication changes.
  }

  Future<void> startRoute() async {
    try {
      isRouteStarted.value = true;
      await Get.putAsync<JourneyController>(() async => JourneyController());
    } catch (error) {
      Get.snackbar("Error", "Failed to create JourneyController.");
    }
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
      Get.snackbar("Error", "PolylinePoints could not be set.");
    }
  }

  void updatePolylineCoordinates({required LatLng location}) {
    if (polylineCoordinates.isNotEmpty) {
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        LatLng nextPoint = polylineCoordinates[i];
        // Check if the driver has passed the next point.
        double distance = LocationUtils.calculateDistance(location, nextPoint);
        if (distance < 20) {
          // Remove the passed point.
          polylineCoordinates.removeAt(i);
          updatePolyline();
          break;
        }
      }
    }
  }

  void updatePolyline() {
    polylines.clear();
    PolylineId id = const PolylineId("route");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 4,
    );
    polylines.add(polyline);
  }

  Future<void> moveCameraToLocation(
      {required LatLng location, double bearing = 0}) async {
    if (!isCameraLocked.value) return;
    CameraPosition newCameraPosition = CameraPosition(
      target: location,
      zoom: 18,
      bearing: bearing,
      tilt: 45,
    );
    var googleMaps = await googleMapsController.future;
    googleMaps.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> moveCameraToAllRoute() async {
    LatLngBounds bounds = LocationUtils.calculateBounds(polylineCoordinates);
    var googleMaps = await googleMapsController.future;
    googleMaps.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  bool isOffRoute({required LatLng location, double threshold = 200}) {
    for (LatLng point in polylineCoordinates) {
      double distance = LocationUtils.calculateDistance(location, point);
      if (distance < threshold) {
        // Driver is still on the route.
        return false;
      }
    }
    // Driver is off the route.
    return true;
  }

  Future<void> recalculateRoute(
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
      Get.snackbar("Error", "PolylinePoints could not be recalculateRouted.");
    }
  }

  // void setCurrentLocationMarker({required LatLng location}) async {
  //   markers.clear();
  //   const markerId = MarkerId("current");
  //   final marker = Marker(markerId: markerId, position: location);
  //   markers[markerId] = marker;
  // }

  void clearRoute() {
    polylines.clear();
    polylineCoordinates.clear();
    markers.clear();
    isRouteCreated.value = false;
    isRouteStarted.value = false;
    if (Get.isRegistered<JourneyController>()) {
      Get.delete<JourneyController>();
    }
  }

  void setRouteModel({required RouteModel route, required bool isPlanned}) {
    this.route = route;
    this.isPlanned = isPlanned;
  }

  Future<void> saveRoute() async {
    await Get.find<RouteController>().createRoute(
        startingLocation: route.startingLocation,
        startingCity: route.startingCity,
        destinationLocation: route.destinationLocation,
        destinationCity: route.destinationCity,
        dateTime: route.plannedAt,
        sharedChatGroups: route.sharedChatGroups);
  }

  setMapStyle() async {
    ThemeChanger themeChanger = Get.find();
    String style = await DefaultAssetBundle.of(Get.context!)
        .loadString('lib/assets/map_theme/night_theme.json');
    themeChanger.isLight.value ? mapStyle("") : mapStyle(style);
    print(mapStyle.value);
    print(themeChanger.isLight.value);
  }
}
