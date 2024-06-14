import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigationapp/controllers/route_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/models/route.dart';
import 'package:navigationapp/utils/location_utils.dart';

class MapController extends GetxController {
  late Completer<GoogleMapController> googleMapsController = Completer();
  late RouteModel route;
  bool isPlanned = false;
  RxBool isRouteStarted = false.obs;
  RxBool isRouteCreated = false.obs;
  var markers = <MarkerId, Marker>{}.obs;
  var polylines = <Polyline>[].obs;
  var polylineCoordinates = <LatLng>[].obs;

  Future<void> setPolylinePoints(
      {required LatLng start, required LatLng finish}) async {
    try {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        AppConstants.googleMapsApiKey,
        PointLatLng(start.latitude, start.longitude),
        PointLatLng(finish.latitude, finish.longitude),
      );
      if (result.points.isNotEmpty) {
        polylineCoordinates.clear();
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        updatePolyline();
        LatLngBounds bounds =
            LocationUtils.calculateBounds(polylineCoordinates);
        var googleMaps = await googleMapsController.future;
        googleMaps.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      } else {
        Get.snackbar("Error", result.errorMessage.toString());
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

  Future<void> moveCameraToLocation(
      {required LatLng location, double bearing = 0}) async {
    CameraPosition newCameraPosition = CameraPosition(
      target: location,
      zoom: 18,
      bearing: bearing,
      tilt: 45,
    );
    var googleMaps = await googleMapsController.future;
    googleMaps.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  bool isOffRoute({required LatLng location, double threshold = 50}) {
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
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        AppConstants.googleMapsApiKey,
        PointLatLng(start.latitude, start.longitude),
        PointLatLng(destination.latitude, destination.longitude),
      );
      if (result.points.isNotEmpty) {
        polylineCoordinates.clear();
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        updatePolyline();
      }
    } catch (error) {
      Get.snackbar("Error", error.toString());
    }
  }

  void setCurrentLocationMarker({required LatLng location}) {
    markers.clear();
    const markerId = MarkerId("current");
    final marker = Marker(markerId: markerId, position: location);
    markers[markerId] = marker;
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

  void clearRoute() {
    polylines.clear();
    polylineCoordinates.clear();
    markers.clear();
    isRouteCreated.value = false;
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
}
