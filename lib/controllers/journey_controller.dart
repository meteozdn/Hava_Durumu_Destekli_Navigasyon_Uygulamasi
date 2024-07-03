import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:navigationapp/controllers/location_controller.dart';
import 'package:navigationapp/controllers/map_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class JourneyController extends GetxController {
  late StreamSubscription<Position> positionStream;
  final LocationController _locationController = Get.find();
  final MapController _mapController = Get.find();
  var selectedCoordinates = <LatLng>[].obs;
  Map<String, dynamic> weatherData = {};
  RxBool isRouteCompleted = false.obs;
  int distanceInMeters = 0;
  int durationInSeconds = 0;

  @override
  void onInit() async {
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
      _locationController.setCurrentLocation(position: position);
      getTotalDistanceAndTime();
    });
  }

  void initializeSelectedLocations() async {
    await getTotalDistanceAndTime();
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
    // Fetch weather data for each selected coordinates.
    for (int i = 0; i < selectedCoordinates.length; i++) {
      var location = selectedCoordinates[i];
      await fetchWeatherData(
          lat: location.latitude,
          lon: location.longitude,
          secondsAfter: intervalInSeconds * (i + 1),
          markerId: i);
    }
  }

  Future<void> getTotalDistanceAndTime() async {
    try {
      String origin =
          "${_locationController.currentLocation.value!.latitude},${_locationController.currentLocation.value!.longitude}";
      String dest =
          "${_locationController.destination.value!.latitude},${_locationController.destination.value!.longitude}";
      final String request =
          "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$origin&destinations=$dest&key=${AppConstants.googleMapsApiKey}";
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        var data = jsonResponse;
        List<dynamic> elements = data["rows"][0]["elements"];
        var distanceText = elements[0]["distance"]["text"];
        var durationText = elements[0]["duration"]["text"];
        durationInSeconds = elements[0]["duration"]["value"];
        distanceInMeters = elements[0]["distance"]["value"];
        _locationController.timeLeft.value =
            _locationController.convertTimeString("$durationText");
        _locationController.distanceLeft.value =
            _locationController.convertMilesToKilometers("$distanceText");
        _locationController
            .addTimeToCurrentTime(_locationController.timeLeft.value);
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
      Get.defaultDialog(middleText: weatherData.toString());
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
}
