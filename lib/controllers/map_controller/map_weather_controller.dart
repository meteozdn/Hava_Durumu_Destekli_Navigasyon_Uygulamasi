import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:navigationapp/controllers/location_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/models/weather/current_weather.dart';
import 'package:navigationapp/services/weather_service/weather_map_service.dart';
import 'package:navigationapp/services/weather_service/weathers_service.dart';
import 'package:navigationapp/views/components/weather_map_widgets/weather_map_marker.dart';
import 'package:navigationapp/views/home/weather_screen.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class MapWeatherController extends GetxController {
  final LocationController _locationController = Get.find();
  final PageController pageController = PageController();
  RxBool isLoad = false.obs;
  final LatLng center = const LatLng(41.34143753, 36.26658554);
  RxSet<Marker> markers = <Marker>{}.obs;
  final DateFormat formatterDate = DateFormat('dd MMMM EEEE', 'tr_TR');
  final DateFormat formatterHour = DateFormat('jm', 'tr_TR');
  final WeathersService weatherService = WeathersService();
  final date = DateTime.now();
  final WeathersService weathersService = WeathersService();
  var pageViewIndex = 0.obs;
  Rx<CurrentWeatherModel> currentWeatherModel =
      Rx<CurrentWeatherModel>(CurrentWeatherModel());
  RxSet<TileOverlay> tileOverlays = <TileOverlay>{}.obs;

  String getdate() {
    return formatterDate.format(date);
  }

  String getIcon() {
    String icon =
        "${IconsConst.root}${currentWeatherModel.value.weather!.first.icon!}.png";
    return icon;
  }

  changePage() {
    if (pageViewIndex == 0) {
      print("sıfır");
      //   _setTiles(WeatherMapTypes.ta2);
    } else if (pageViewIndex == 3) {
      //  _setTiles(WeatherMapTypes.wnd);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await _setTiles(WeatherMapTypes.ta2);
    // await getCurrentLocation();
    getCurrentWeather();
    getAllerts();
    currentWeatherModel.value = await weatherService.fetchCurrentWeatherData(
        center.longitude, center.latitude);
    await getCurrentLocationMarker();
    determinePosition();
    load();
  }

  getCurrentLocationMarker() async {
    markers.add(Marker(
        icon: await WeatherMarker(
          isNight: !(DateTime.now().hour < 19 && DateTime.now().hour > 6),
          weatherIcon: getIcon(),
          weatherTemp: currentWeatherModel.value.main!.temp!,
        ).toBitmapDescriptor(
            logicalSize: const Size(200, 200), imageSize: const Size(200, 200)),
        markerId: const MarkerId("CurrentId"),
        // position: _locationController.currentLocation.value != null
        //     ? _locationController.currentLocation.value!
        //     : center
        position: center));
    load();
  }

  getAllerts() {
    weatherService.fetchAllertWeatherData();
  }

  late GoogleMapController googlemapController;
  onMapCreated(GoogleMapController controller) async {
    googlemapController = controller;
    //  _setTiles();
    _applyMapStyle();
    load();
  }

  getCurrentWeather() {
    weatherService.fetchCurrentWeatherData(41.32859, 36.2846729);
  }

  _setTiles(String mapType) {
    print(tileOverlays);
    // tileOverlays.clear();
    final String overlayId = DateTime.now().millisecondsSinceEpoch.toString();
    final tileOverlay = TileOverlay(
        tileOverlayId: TileOverlayId(overlayId),
        tileProvider: WeatherMapService(mapType: mapType));
    //print(tileOverlays.);

    tileOverlays = {tileOverlay}.obs;
    load();
  }

  Future<void> _applyMapStyle() async {
    String style = await DefaultAssetBundle.of(Get.context!)
        .loadString('lib/assets/map_theme/silver_theme.json');
    // ignore: deprecated_member_use
    googlemapController.setMapStyle(style);
    load();
  }

  load() {
    isLoad(isLoad.value);
  }

  Future determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("LocationServices disabled ");
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("LocationPermission Denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("LocationPermission Denied");
    }
  }

  LatLng? getPosition(double latitude, double longitude) {
    return LatLng(latitude, longitude);
  }
}

enum WeatherState { max, min, current }
