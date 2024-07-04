import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigationapp/controllers/journey_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/models/route.dart';
import 'package:navigationapp/utils/location_utils.dart';
import 'package:http/http.dart' as http;
import 'package:navigationapp/views/components/navigation_marker.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class JourneyLiveDetailController extends GetxController {
  late Completer<GoogleMapController> googleMapsController = Completer();
  // late RouteModel route;
//  RxBool isRouteCreated = false.obs;
//  RxBool isCameraLocked = true.obs;
  final RouteModel route;
  JourneyLiveDetailController({
    //super.key,
    required this.route,
  });

  Rx<RouteModel?> routeModel = Rx<RouteModel?>(null);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot>? routeSubscription;
  DocumentReference? routeDocRef;

  //RxSet<Marker> markers = <Marker>{}.obs;
  var markers = <Marker>[].obs;
  var polylines = <Polyline>[].obs;
  var polylineCoordinates = <LatLng>[].obs;
  RxString currentCity = RxString("");
  RxString lastUpdate = RxString("");

  @override
  void onInit() async {
    super.onInit();
    await getMarkers(route);
    routeDocRef =
        _firestore.collection(FirestoreCollections.routes).doc(route.id);
    listenToRouteUpdates();
  }

  @override
  void onClose() {
    routeSubscription?.cancel();
    super.onClose();
  }

  void listenToRouteUpdates() {
    routeSubscription = routeDocRef?.snapshots().listen((snapshot) async {
      if (snapshot.exists) {
        RouteModel newRouteData = RouteModel.fromFirestore(snapshot);
        RouteModel? oldRouteData = routeModel.value;
        routeModel.value = newRouteData;
        if (oldRouteData == null) {
          return;
        }
        // Check for updates to "location" field.
        if (oldRouteData.location != routeModel.value!.location) {
          Get.snackbar("title", "location update");
          currentCity.value = getCityName();
          lastUpdate.value = lastUpdateForLocation();
          updateLocationMarker();
        }
      }
    });
  }

  void updateLocationMarker() {
    MarkerId markerId = const MarkerId("location");
    // Find the marker by its ID.
    Marker? marker;
    try {
      marker = markers.firstWhere((m) => m.markerId == markerId);
    } catch (error) {
      marker = null;
    }
    if (marker != null) {
      LatLng newLocation = LatLng(routeModel.value!.location!.latitude,
          routeModel.value!.location!.longitude);
      // Create a new marker with the updated position.
      Marker updatedMarker = marker.copyWith(positionParam: newLocation);
      // Update the markers set.
      markers.remove(marker);
      markers.add(updatedMarker);
    }
  }

  String getCityName() {
    String cityName = "Bilinmeyen";
    if (routeModel.value != null && routeModel.value!.location != null) {
      GeoPoint? location = routeModel.value!.location;
      LatLng latLng = LatLng(location!.latitude, location.longitude);
      LocationUtils.getCityNameFromLatLng(latLng).then((name) {
        cityName = name;
      });
    }
    return cityName;
  }

  String lastUpdateForLocation() {
    String lastUpdate = "Bilinmeyen";
    if (routeModel.value != null &&
        routeModel.value!.locationLastUpdate != null) {
      lastUpdate =
          routeModel.value!.locationLastUpdate.toString().substring(12, 16);
    }
    return lastUpdate;
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
      }
    } catch (error) {
      Get.snackbar("Error = setPolylinePoints()", error.toString());
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

  // void setRouteModel({required RouteModel route, required bool isPlanned}) {
  //   this.route = route;
  // }
}
