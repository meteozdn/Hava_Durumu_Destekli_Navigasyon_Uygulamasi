import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:navigationapp/controllers/location_controller.dart';
import 'package:navigationapp/controllers/map_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/utils/location_utils.dart';

class JourneyController extends GetxController {
  late StreamSubscription<Position> positionStream;
  final LocationController _locationController = Get.find();
  final MapController _mapController = Get.find();
  var selectedCoordinates = <LatLng>[].obs;
  Map<String, dynamic> weatherData = {};
  RxBool isRouteCompleted = false.obs;
  int distanceInMeters = 0;
  int durationInSeconds = 0;
  LatLng? currentLocation;
  LatLng? lastLocation;

  @override
  void onInit() {
    super.onInit();
    initializeLocationTracking();
    initializeSelectedLocations();
  }

  @override
  void onClose() {
    positionStream.cancel();
    super.onClose();
  }

  void initializeLocationTracking() {
    // Subscribe to location changes.
    positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    )).listen((Position position) {
      LatLng location = LatLng(position.latitude, position.longitude);
      currentLocation = location;
      _locationController.setCurrentLocation(location: currentLocation!);
      if (lastLocation == null ||
          LocationUtils.calculateDistance(lastLocation!, location) >= 250) {
        lastLocation = location;
        // Update left distance and time.
        getTotalDistanceAndTime();
        // Update route model for firebase.
        _mapController.updateRouteLocation(
            current: location, secondsLeft: durationInSeconds);
      }
    });
  }

  void initializeSelectedLocations() async {
    try {
      await getTotalDistanceAndTime().then((_) async {
        selectedCoordinates.clear();
        int totalPoints = _mapController.polylineCoordinates.length;
        // For each 20 minutes (1200 seconds).
        int intervalInSeconds = 20 * 60;
        // Calculate interval in terms of polyline coordinates.
        int intervalPoints =
            (totalPoints * (intervalInSeconds / durationInSeconds)).round();
        // Add to selectedCoordinates.
        for (int i = intervalPoints; i < totalPoints; i += intervalPoints) {
          selectedCoordinates.add(_mapController.polylineCoordinates[i]);
        }
        // Calculate the average speed from the values of distance and duration.
        double averageSpeed = distanceInMeters / durationInSeconds;
        // Get current location.
        LatLng startingLocation = _locationController.currentLocation.value!;
        // Fetch weather data for each selected coordinates.
        for (int i = 0; i < selectedCoordinates.length; i++) {
          var location = selectedCoordinates[i];
          double distance =
              LocationUtils.calculateDistance(startingLocation, location);
          double secondsAfter = distance / averageSpeed;
          await fetchWeatherData(
              lat: location.latitude,
              lon: location.longitude,
              secondsAfter: secondsAfter.toInt(),
              markerId: i);
        }
      });
    } catch (error) {
      Get.snackbar("Error", error.toString());
    }
  }

  Future<void> getTotalDistanceAndTime() async {
    try {
      String origin =
          "${_locationController.currentLocation.value!.latitude},${_locationController.currentLocation.value!.longitude}";
      String dest =
          "${_locationController.destination.value!.latitude},${_locationController.destination.value!.longitude}";
      final String request =
          "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$origin&destinations=$dest&key=${AppConstants.googleMapsApiKey}&language=tr";
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        var data = jsonResponse;
        List<dynamic> elements = data["rows"][0]["elements"];
        _locationController.timeLeft.value = elements[0]["duration"]["text"];
        _locationController.distanceLeft.value =
            elements[0]["distance"]["text"];
        durationInSeconds = elements[0]["duration"]["value"];
        distanceInMeters = elements[0]["distance"]["value"];
        Get.snackbar("Test",
            "${_locationController.timeLeft.value}  ${_locationController.distanceLeft.value}");

        // _locationController.timeLeft.value =
        //     _locationController.convertTimeString("$durationText");
        // _locationController.distanceLeft.value =
        //     _locationController.convertMilesToKilometers("$distanceText");
        // _locationController
        //     .addTimeToCurrentTime(_locationController.timeLeft.value);
      }
    } catch (error) {
      Get.snackbar("Error", error.toString());
    }
  }

  // Function to fetch weather data.
  Future<void> fetchWeatherData(
      {required double lat,
      required double lon,
      required int secondsAfter,
      required int markerId}) async {
    try {
      DateTime dateTime = DateTime.now().add(Duration(seconds: secondsAfter));
      int dt = dateTime.millisecondsSinceEpoch ~/ 1000;
      final String request =
          "https://api.openweathermap.org/data/3.0/onecall/timemachine?lat=$lat&lon=$lon&dt=$dt&units=metric&lang=tr&appid=${AppConstants.weatherAPIKey}";
      final response = await http.get(Uri.parse(request));
      weatherData = json.decode(response.body);
      _mapController.createCustomMarkerForWeather(
          weatherData: weatherData,
          secondsAfter: secondsAfter,
          location: LatLng(lat, lon),
          markerId: markerId);
    } catch (error) {
      Get.snackbar("Error", error.toString());
    }
  }

  // Function to check for adverse weather.
  bool willAdverseWeather() {
    final condition = weatherData["data"][0]["weather"][0]["main"];
    if (AppConstants.adverseWeathers.contains(condition)) {
      return true;
    }
    return false;
  }

  // void updateCurrentRoute({required LatLng location}) async {
  //   //Check if the driver is off the route.
  //   if (_mapController.isOffRoute(location: location)) {
  //     Get.snackbar("updateCurrentRoute(), isOffRoute = true",
  //         "The navigation has been preparing.");
  //     await _mapController.recalculateRoute(
  //         start: location, destination: _locationController.destination.value!);
  //   }
  //   getTotalDistanceAndTime();
  // }
}
