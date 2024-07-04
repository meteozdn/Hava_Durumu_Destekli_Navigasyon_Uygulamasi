import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigationapp/controllers/journey_controller.dart';
import 'package:navigationapp/controllers/location_controller.dart';
import 'package:navigationapp/controllers/route_controller.dart';
import 'package:navigationapp/controllers/theme_change_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/models/route.dart';
import 'package:navigationapp/utils/location_utils.dart';
import 'package:http/http.dart' as http;
import 'package:navigationapp/views/components/weather_map_widgets/weather_map_marker.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class MapController extends GetxController {
  late Completer<GoogleMapController> googleMapsController = Completer();
  late RouteModel route;
  bool isPlanned = false;
  bool isSaved = false;
  RxBool isRouteStarted = false.obs;
  RxBool isRouteCreated = false.obs;
  RxBool isCameraLocked = true.obs;
  var markers = <Marker>[].obs;
  var polylines = <Polyline>[].obs;
  var polylineCoordinates = <LatLng>[].obs;
  //var directions = [].obs;
  RxList<Map<String, dynamic>> directions = <Map<String, dynamic>>[].obs;
  RxString instruction = RxString("");
  RxString instructionDistance = RxString("");
  RxString mapStyle = "".obs;
  int directionIndex = 0;

  @override
  void onInit() async {
    super.onInit();
    await setMapStyle();
  }

  Future<void> startRoute() async {
    try {
      isRouteStarted.value = true;
      route.isActive = true;
      route.startedAt = DateTime.now();
      await Get.putAsync<JourneyController>(() async => JourneyController());
    } catch (error) {
      //Get.snackbar("Error = startRoute()", error.toString());
    }
  }

  Future<void> setPlannedRoute({required RouteModel route}) async {
    try {
      setRouteModel(route: route, isPlanned: false);
      isSaved = true;
      var start = LatLng(this.route.startingLocation.latitude,
          this.route.startingLocation.longitude);
      var destination = LatLng(this.route.destinationLocation.latitude,
          this.route.destinationLocation.longitude);

      await setPolylinePoints(start: start, destination: destination);
      isRouteCreated.value = true;
      await moveCameraToAllRoute();
      var locationController = Get.find<LocationController>();
      locationController.destination.value = destination;
    } catch (error) {
      //Get.snackbar("Error = setPlannedRoute()", error.toString());
    }
  }

  Future<void> setPolylinePoints(
      {required LatLng start, required LatLng destination}) async {
    try {
      String routesUrl =
          "https://routes.googleapis.com/directions/v2:computeRoutes";
      Map<String, dynamic> requestBody = {
        "origin": {
          "location": {
            "latLng": {"latitude": start.latitude, "longitude": start.longitude}
          }
        },
        "destination": {
          "location": {
            "latLng": {
              "latitude": destination.latitude,
              "longitude": destination.longitude
            }
          }
        },
        "travelMode": "DRIVE",
        "computeAlternativeRoutes": false,
        "routeModifiers": {
          "avoidTolls": false,
          "avoidHighways": false,
          "avoidFerries": false
        },
        "languageCode": "tr"
      };
      var response = await http.post(
        Uri.parse(routesUrl),
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": AppConstants.googleMapsApiKey,
          "X-Goog-FieldMask":
              "routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline,routes.legs.steps",
        },
        body: json.encode(requestBody),
      );
      var data = json.decode(response.body);
      var routes = data["routes"];
      if (routes != null && routes.isNotEmpty) {
        var points = PolylinePoints()
            .decodePolyline(routes[0]["polyline"]["encodedPolyline"]);
        polylineCoordinates.clear();
        polylineCoordinates.addAll(points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList());
        updatePolyline();
        if (true) {
          //!isPlanned
          directions.clear();
          var steps = data["routes"][0]["legs"][0]["steps"];
          for (var step in steps) {
            var instruction = step["navigationInstruction"]["instructions"];
            var distanceInMeters = step["distanceMeters"];
            var start = step["startLocation"];
            var end = step["endLocation"];
            //var distance = step["localizedValues"]["distance"]["text"];
            directions.add({
              "instruction": instruction,
              "distanceMeters": distanceInMeters,
              "start": start,
              "end": end
              //"distance": distance,
            });
          }
        }
      }
    } catch (error) {
      //Get.snackbar("Error = setPolylinePoints()", error.toString());
    }
  }

  Future<void> getNextDirection({required LatLng from}) async {
    if (directions.length > 1) {
      if (directionIndex == 0) {
        instruction.value = directions[directionIndex]["instruction"]!;
        instructionDistance.value =
            directions[directionIndex]["distanceMeters"];
      }
      for (var i = directionIndex; i < directions.length; i++) {
        var direction = directions[i];
        var distanceMeters = directions[i]["distanceMeters"];
        var start = LatLng(
            direction["start"]["latitude"], direction["start"]["longitude"]);
        var end =
            LatLng(direction["end"]["latitude"], direction["end"]["longitude"]);
        var startToFrom = LocationUtils.calculateDistance(start, from);
        var fromToEnd = LocationUtils.calculateDistance(from, end);
        if (startToFrom < distanceMeters && fromToEnd < distanceMeters) {
          instruction.value = direction["instruction"]!;
          instructionDistance.value = distanceMeters;
          directionIndex = i;
          break;
        }
      }
    }
  }

  void updatePolylineCoordinates({required LatLng location}) {
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

  Future<void> recalculateRoute() async {
    try {
      var locationController = Get.find<LocationController>();
      var start = locationController.currentLocation.value!;
      var destination = locationController.destination.value!;
      directions.clear();
      directionIndex = 0;
      await setPolylinePoints(start: start, destination: destination);
      // Get new future weather data.
      markers.clear();
      Get.find<JourneyController>().initializeSelectedLocations();
    } catch (error) {
      //Get.snackbar("Error = recalculateRoute()", error.toString());
    }
  }

  void createCustomMarkerForWeather(
      {required Map<String, dynamic> weatherData,
      required int secondsAfter,
      required LatLng location,
      required int markerId}) async {
    // Get hour data after secondsAfter.
    int hour = DateTime.now().add(Duration(seconds: secondsAfter)).hour;
    // Get icon path.
    String weatherIcon =
        "${IconsConst.root}${weatherData["data"][0]["weather"][0]["icon"]}.png";
    // Get weather data.
    double weatherTemp = weatherData["data"][0]["temp"];
    // Add to markers.
    markers.add(Marker(
        icon: await WeatherMarker(
          isNight: !(hour < 19 && hour > 6),
          weatherIcon: weatherIcon,
          weatherTemp: weatherTemp,
        ).toBitmapDescriptor(
            logicalSize: const Size(200, 200), imageSize: const Size(200, 200)),
        markerId: MarkerId(markerId.toString()),
        position: location));
  }

  void clearRoute() {
    polylines.clear();
    polylineCoordinates.clear();
    markers.clear();
    directions.clear();
    isRouteCreated.value = false;
    isRouteStarted.value = false;
    isSaved = false;
    isPlanned = false;
    if (Get.isRegistered<JourneyController>()) {
      Get.delete<JourneyController>();
    }
  }

  void setRouteModel({required RouteModel route, required bool isPlanned}) {
    this.route = route;
    this.isPlanned = isPlanned;
  }

  // Update the active route every x minutes.
  void updateRouteLocation(
      {required LatLng current, required int secondsLeft}) {
    route.location = GeoPoint(current.latitude, current.longitude);
    route.estimatedFinishTime =
        DateTime.now().add(Duration(seconds: secondsLeft));
    route.locationLastUpdate = DateTime.now();
    Get.find<RouteController>().updateRoute(route: route);
  }

  Future<void> saveRoute() async {
    await Get.find<RouteController>().createRoute(
        id: route.id,
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

  // bool isOffRoute(
  //     {required LatLng location, double threshold = 250, int step = 10}) {
  //   for (int i = 0; i < polylineCoordinates.length; i += step) {
  //     double distance =
  //         LocationUtils.calculateDistance(location, polylineCoordinates[i]);
  //     if (distance < threshold) {
  //       // Driver is still on the route.
  //       return false;
  //     }
  //   }
  //   // Driver is off the route.
  //   return true;
  // }
}
