import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:navigationapp/controllers/map_controller.dart';
import 'package:navigationapp/utils/location_utils.dart';

class LocationController extends GetxController {
  final MapController _mapController = Get.find();
  Rxn<LatLng> currentLocation = Rxn<LatLng>();
  Rxn<LatLng> destination = Rxn<LatLng>();
  RxString currentCity = RxString("");
  RxString distanceLeft = RxString("");
  RxString timeLeft = RxString("");
  RxString estimatedTime = RxString("");
  RxBool isMinute = true.obs;

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
      }
      return currentLocation.value!;
    } catch (error) {
      Get.snackbar("Error = getCurrentLocation()", error.toString());
      return const LatLng(0, 0);
    }
  }

  estimatedTimeCalculate() {
    final dateFormat = DateFormat('HH:mm', "tr_TR");
    try {
      if (isMinute.value) {
        estimatedTime(dateFormat.format(DateTime.now()
            .add(Duration(minutes: double.parse(timeLeft.value).round()))));
      } else {
        estimatedTime(dateFormat.format(DateTime.now()
            .add(Duration(hours: double.parse(timeLeft.value).round()))));
      }
    } catch (e) {
      print(e);
    }
    // print();
  }

  Duration parseTimeString(String timeString) {
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return Duration(hours: hours, minutes: minutes);
  }

// Şu anki zamana verilen süreyi ekleyen fonksiyon
  addTimeToCurrentTime(String timeString) {
    final dateFormat = DateFormat('HH:mm', "tr_TR");

    Duration duration = parseTimeString(timeString);
    DateTime now = DateTime.now();
    estimatedTime(dateFormat.format(now.add(duration)));
    //   return now.add(duration);
  }

  convertMilesToKilometers(String milesString) {
    // String'ten sadece sayıları al
    String milesNumber = milesString.replaceAll(RegExp(r'\D'), '');

    // Sayıları int olarak parse et
    int miles = int.parse(milesNumber);

    // Mil değerini kilometreye dönüştür
    const double mileToKilometerFactor = 1.60934;
    double kilometers = miles * mileToKilometerFactor;

    // Kilometre değerini en yakın tam sayıya yuvarla ve geri dön
    distanceLeft.value = kilometers.round().toString();
  }

  convertTimeString(String timeString) {
    // "10 saat 20 dk" gibi bir string'i parçalarına ayır
    List<String> parts = timeString.split(' ');

    // Saat ve dakikaları ayrı değişkenlere ata
    String hourPart = parts[0];
    String minutePart = parts[2];

    // Saat ve dakikalardan sadece sayıları al
    String hours = hourPart.replaceAll(RegExp(r'\D'), '');
    String minutes = minutePart.replaceAll(RegExp(r'\D'), '');

    // "HH:MM" formatında string oluştur ve geri dön
    timeLeft('$hours:$minutes');
    print(timeLeft.value);
    // return '$hours:$minutes';
  }

  Future<void> setCurrentLocation({required LatLng location}) async {
    try {
      double bearing = 0;
      bearing =
          LocationUtils.calculateBearing(currentLocation.value!, location);
      _mapController.moveCameraToLocation(location: location, bearing: bearing);
      currentLocation.value = location;
    } catch (error) {
      Get.snackbar("Error = setCurrentLocation()", error.toString());
    }
  }
}
