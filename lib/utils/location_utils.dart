import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:navigationapp/core/constants/app_constants.dart';
import 'dart:math' as math;

class LocationUtils {
  static Future<String> getCityNameFromLatLng(LatLng location) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      Placemark placemark = placemarks.first;
      return placemark.administrativeArea ?? "Unknown";
    } catch (error) {
      Get.snackbar("Error", "Current city can not be found.");
      return "Unknown";
    }
  }

  static Future<LatLng> getLatLngFromAddress(String address) async {
    try {
      final String url =
          "https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=${AppConstants.googleMapsApiKey}";
      final response = await http.get(Uri.parse(url));
      final jsonResponse = json.decode(response.body);
      if (jsonResponse["results"].isNotEmpty) {
        final location = jsonResponse["results"][0]["geometry"]["location"];
        return LatLng(location["lat"], location["lng"]);
      } else {
        Get.snackbar("Error", "No results found for the provided address.");
        return const LatLng(0, 0);
      }
    } catch (error) {
      Get.snackbar("Error", "Failed to fetch coordinates.");
      return const LatLng(0, 0);
    }
  }

  static double calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * math.pi / 180.0;
    double lon1 = start.longitude * math.pi / 180.0;
    double lat2 = end.latitude * math.pi / 180.0;
    double lon2 = end.longitude * math.pi / 180.0;
    double dLon = lon2 - lon1;
    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    double bearing = math.atan2(y, x);
    return (bearing * 180.0 / math.pi + 360.0) % 360.0;
  }

  static double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
        start.latitude, start.longitude, end.latitude, end.longitude);
  }

  static LatLngBounds calculateBounds(List<LatLng> polylineCoordinates) {
    double minLat = polylineCoordinates.first.latitude;
    double minLng = polylineCoordinates.first.longitude;
    double maxLat = polylineCoordinates.first.latitude;
    double maxLng = polylineCoordinates.first.longitude;
    for (LatLng point in polylineCoordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
