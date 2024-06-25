import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:navigationapp/controllers/location_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class JourneyController extends GetxController {
  Map<String, dynamic> weatherData = {};
  RxBool isRouteCompleted = false.obs;
  // double distance = 0.0;
  // double duration = 0.0;

  late StreamSubscription<Position> positionStream;
  final LocationController _locationController = Get.find();

  @override
  void onInit() {
    super.onInit();
    initializeLocationTracking();
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

  void getTotalDistanceAndTime() async {
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
        // for (var i = 0; i < elements.length; i++) {
        //   distance = distance + elements[i]["distance"]["value"];
        //   duration = duration + elements[i]["duration"]["value"];
        // }
        // if (distance < 20) {
        //   isRouteCompleted.value = true;
        //   Get.snackbar("Completed", "You have arrived to your destination.");
        // }
        // _locationController.distanceLeft.value =
        //     "Kalan: ${(distance / 1000).toStringAsFixed(2)} km";
        // _locationController.timeLeft.value =
        //     "Tahmini Süre: ${(duration / 60).round()} dk";
        _locationController.distanceLeft.value = "Kalan: $distanceText";
        _locationController.timeLeft.value = "Tahmini Süre: $durationText";
      }
    } catch (error) {
      Get.snackbar("Error", error.toString());
    }
  }

  // Function to fetch weather data.
  Future<void> fetchWeatherData(
      double lat, double lon, DateTime datetime) async {
    String origin =
        "${_locationController.currentLocation.value!.latitude},${_locationController.currentLocation.value!.longitude}";
    String dest = "$lat,$lon";
    final String request =
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$origin&destinations=$dest&key=${AppConstants.googleMapsApiKey}";
    final response1 = await http.get(Uri.parse(request));
    if (response1.statusCode == 200) {
      final jsonResponse = json.decode(response1.body);
      var data = jsonResponse;
      double duration = 0.0;
      List<dynamic> elements = data["rows"][0]["elements"];
      for (var i = 0; i < elements.length; i++) {
        duration = duration + elements[i]["duration"]["value"];
      }
      DateTime newDateTime =
          DateTime.now().add(Duration(minutes: (duration / 60).round()));
      int dt = newDateTime.millisecondsSinceEpoch ~/ 1000;
      final String request =
          "https://api.openweathermap.org/data/3.0/onecall/timemachine?lat=$lat&lon=$lon&dt=$dt&units=metric&lang=tr&appid=${AppConstants.weatherAPIKey}";
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        weatherData = json.decode(response.body);
        Get.defaultDialog(middleText: weatherData.toString());
      } else {
        Get.snackbar("Error", "Failed to fetch weather data");
      }
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
