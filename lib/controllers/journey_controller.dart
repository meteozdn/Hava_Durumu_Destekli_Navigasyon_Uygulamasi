import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:navigationapp/controllers/navigation_controller.dart';

class JourneyController extends GetxController {
  List<String> adverseWeathers = [
    "Thunderstorm",
    "Drizzle",
    "Rain",
    "Snow",
    "Mist",
    "Smoke",
    "Haze",
    "Dust",
    "Fog",
    "Sand",
    "Ash",
    "Squall",
    "Tornado"
  ];
  Map<String, dynamic> weatherData = {};
  final String apiKey = "b3baa2e76f1fde182c7a298d21287a93";

  late StreamSubscription<Position> positionStream;
  late Completer<GoogleMapController> googleMapsController = Completer();
  final NavigationController _navigationController =
      Get.find<NavigationController>();

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

  void initializeLocationTracking() async {
    // Subscribe to location changes.
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      _navigationController.currentLocation.value =
          LatLng(position.latitude, position.longitude);
    });
  }

  // Function to fetch weather data.
  Future<void> fetchWeatherData(
      double lat, double lon, DateTime dateTime) async {
    int dt = dateTime.millisecondsSinceEpoch ~/ 1000;
    final String request =
        "https://api.openweathermap.org/data/3.0/onecall/timemachine?lat=$lat&lon=$lon&dt=$dt&units=metric&lang=tr&appid=$apiKey";
    final response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      weatherData = json.decode(response.body);
    } else {
      Get.snackbar("Error", "Failed to fetch weather data");
    }
  }

  // Function to check for adverse weather.
  bool willAdverseWeather() {
    final condition = weatherData["data"][0]["weather"][0]["main"];
    if (adverseWeathers.contains(condition)) {
      return true;
    }
    return false;
  }
}
