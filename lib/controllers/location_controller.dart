import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigationapp/controllers/map_controller.dart';
import 'package:navigationapp/utils/location_utils.dart';

class LocationController extends GetxController {
  final MapController _mapController = Get.find();
  Rxn<LatLng> currentLocation = Rxn<LatLng>();
  Rxn<LatLng> destination = Rxn<LatLng>();
  RxString currentCity = RxString("");
  RxString distanceLeft = RxString("");
  RxString timeLeft = RxString("");

  Future<String> getCurrentCity() async {
    try {
      currentCity.value = await LocationUtils.getCityNameFromLatLng(LatLng(
        currentLocation.value!.latitude,
        currentLocation.value!.longitude,
      ));
      return currentCity.value;
    } catch (error) {
      // Get.snackbar(
      //     "Error", "Failed to set current city.\n currentCity = Başlangıç");
      return "Başlangıç";
    }
  }

  Future<LatLng> getCurrentLocation({bool isCameraMove = true}) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentLocation.value = LatLng(position.latitude, position.longitude);
      if (currentLocation.value != null && isCameraMove) {
        _mapController.moveCameraToLocation(location: currentLocation.value!);
        // _mapController.setCurrentLocationMarker(
        //     location: currentLocation.value!);
      }
      return currentLocation.value!;
    } catch (error) {
      Get.snackbar(
          "Error", "Failed to get current location.\n currentLocation = (0,0)");
      return const LatLng(0, 0);
    }
  }

  void setCurrentLocation({required Position position}) {
    try {
      LatLng newLocation = LatLng(position.latitude, position.longitude);
      double bearing = 0;
      if (currentLocation.value != null) {
        bearing =
            LocationUtils.calculateBearing(currentLocation.value!, newLocation);
        // _mapController.updatePolylineCoordinates(
        //     location: currentLocation.value!);
        // Check if the driver is off the route.
        if (_mapController.isOffRoute(location: currentLocation.value!)) {
          Get.snackbar("Navigation", "The navigation has been preparing.");
          _mapController.recalculateRoute(
              start: currentLocation.value!, destination: destination.value!);
        }
      }
      currentLocation.value = newLocation;
      //_mapController.setCurrentLocationMarker(location: newLocation);
      _mapController.moveCameraToLocation(
          location: newLocation, bearing: bearing);
    } catch (error) {
      Get.snackbar("Error", "Failed to set current location.");
    }
  }
}
