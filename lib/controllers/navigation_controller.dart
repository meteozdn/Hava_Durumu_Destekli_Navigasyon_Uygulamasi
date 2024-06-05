import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/route_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NavigationController extends GetxController {
  GoogleMapController? mapController;
  var startingLocation = Rxn<LatLng>();
  var destinationLocation = Rxn<LatLng>();
  var polylines = <Polyline>[].obs;
  var routePoints = <LatLng>[].obs;
  final RouteController _routeController = Get.find<RouteController>();
  var originSuggestions = [].obs;
  var destinationSuggestions = [].obs;
  //var suggestions = [].obs;
  final String apiKey = "AIzaSyDA9541Tfh0jVOTKmYz-nFn03i6Eb9cO4E";
  // final String apiKey = "YOUR_GOOGLE_MAPS_API_KEY";

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  void fetchOriginSuggestions(String input) async {
    if (input.isEmpty) {
      originSuggestions.clear();
      return;
    }
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String request = '$baseUrl?input=$input&key=$apiKey';
    final response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> predictions = jsonResponse["predictions"];
      originSuggestions.value = predictions
          .map((e) => {
                "description": e["description"],
                "place_id": e["place_id"],
              })
          .toList();
    } else {
      Get.snackbar("Error", "Failed to fetch suggestions");
    }
  }

  void fetchDestinationSuggestions(String input) async {
    if (input.isEmpty) {
      destinationSuggestions.clear();
      return;
    }
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String request = '$baseUrl?input=$input&key=$apiKey';
    final response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> predictions = jsonResponse["predictions"];
      destinationSuggestions.value = predictions
          .map((e) => {
                "description": e["description"],
                "place_id": e["place_id"],
              })
          .toList();
    } else {
      Get.snackbar("Error", "Failed to fetch suggestions");
    }
  }

  Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
    const String baseUrl =
        "https://maps.googleapis.com/maps/api/place/details/json";
    final String request = "$baseUrl?place_id=$placeId&key=$apiKey";
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final result = jsonResponse["result"];

      String cityName = "Bilinmeyen";
      GeoPoint location = const GeoPoint(0.0, 0.0);
      // Extract city name
      if (result["address_components"] != null) {
        for (var component in result["address_components"]) {
          if (component["types"].contains("locality") ||
              component["types"].contains("colloquial_area") ||
              component["types"].contains("administrative_area_level_1")) {
            cityName = component["long_name"];
            break;
          }
        }
      }
      // Extract location
      if (result["geometry"] != null &&
          result["geometry"]["location"] != null) {
        final lat = result["geometry"]["location"]["lat"];
        final lng = result["geometry"]["location"]["lng"];
        location = GeoPoint(lat, lng);
      }
      return {"cityName": cityName, "location": location};
    } else {
      Get.snackbar("Error", "Failed to fetch place details");
      return {};
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      startingLocation.value = LatLng(position.latitude, position.longitude);
      mapController
          ?.animateCamera(CameraUpdate.newLatLng(startingLocation.value!));
    } catch (e) {
      Get.snackbar("Error", "Failed to get current location");
    }
  }

  Future<void> fetchRoute(
      {required String origin, required String destination}) async {
    try {
      final String url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["routes"] != null && data["routes"].isNotEmpty) {
          final route = data["routes"][0];
          final polyline = route["overview_polyline"]["points"];
          routePoints.value = _decodePolyline(polyline);
          polylines.clear();
          polylines.add(Polyline(
            polylineId: PolylineId(destination),
            points: routePoints,
            color: Colors.black,
            width: 5,
          ));
        } else {
          Get.snackbar("Error", "No routes found");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch route");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while fetching the route");
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      poly.add(LatLng((lat / 1E5), (lng / 1E5)));
    }
    return poly;
  }

  void onMapTapped(LatLng position) {
    // if (startingLocation.value == null) {
    //   startingLocation.value = position;
    // } else {
    //   destinationLocation.value = position;
    //   _showRoute();
    // }
  }

  // Future<void> _showRoute() async {
  //   if (startingLocation.value != null && destinationLocation.value != null) {
  //     // Fetch the route from Google Directions API
  //     // Here you would call your Google Directions API to get the route
  //     // For simplicity, let's assume you get a list of LatLng points

  //     List<LatLng> points =
  //         []; // This should be fetched from Google Directions API

  //     polylines.clear();
  //     polylines.add(Polyline(
  //       polylineId: PolylineId("route"),
  //       points: points,
  //       color: Colors.blue,
  //       width: 5,
  //     ));
  //   }
  // }

  Future<void> saveRoute() async {
    if (startingLocation.value != null && destinationLocation.value != null) {
      await _routeController.createRoute(
        startingLocation: GeoPoint(startingLocation.value!.latitude,
            startingLocation.value!.longitude),
        startingCity: "Starting City", // Get this dynamically
        destinationLocation: GeoPoint(destinationLocation.value!.latitude,
            destinationLocation.value!.longitude),
        destinationCity: "Destination City", // Get this dynamically
        dateTime: DateTime.now(),
        sharedChatGroups: [], // Add the relevant chat groups
      );
      Get.snackbar("Success", "Route saved successfully");
    }
  }
}
