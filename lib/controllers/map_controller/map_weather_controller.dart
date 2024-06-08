import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:navigationapp/controllers/navigation_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/models/weather/current_weather.dart';
import 'package:navigationapp/services/weather_service/weather_map_service.dart';
import 'package:navigationapp/services/weather_service/weathers_service.dart';

class MapWeatherController extends GetxController {
  final NavigationController _navigationController = Get.find();
  final PageController pageController = PageController();
  RxBool isLoad = false.obs;
  final LatLng center = const LatLng(41.32859, 36.2846729);
  RxSet<Marker> markers = <Marker>{}.obs;
  final DateFormat formatterDate = DateFormat('dd MMMM EEEE', 'tr_TR');
  final WeathersService weatherService = WeathersService();
  final DateFormat formatterHour = DateFormat('jm', 'tr_TR');
  final date = DateTime.now();
  final WeathersService weathersService = WeathersService();
  var pageViewIndex = 0.obs;
  Rx<CurrentWeatherModel> currentWeatherModel =
      Rx<CurrentWeatherModel>(CurrentWeatherModel());
  RxSet<TileOverlay> tileOverlays = <TileOverlay>{}.obs;

  String getdate() {
    return formatterDate.format(date);
  }

  String getCelcius(WeatherState state) {
    String temp = "";

    switch (state) {
      case WeatherState.current:
        temp =
            (currentWeatherModel.value.main!.temp! - 283.12).toStringAsFixed(1);
        break;
      case WeatherState.min:
        temp = (currentWeatherModel.value.main!.tempMin! - 283.12)
            .toStringAsFixed(1);
        break;
      case WeatherState.max:
        temp = (currentWeatherModel.value.main!.tempMax! - 283.12)
            .toStringAsFixed(1);
        break;
      default:
    }
    return temp;
  }

  String getIcon() {
    String icon =
        "${IconsConst.root}${currentWeatherModel.value.weather!.first.icon!}_t@4x.png";

    return icon;
  }

  changePage() {
    if (pageViewIndex == 0) {
      print("sıfır");
      _setTiles(WeatherMapTypes.ta2);
    } else if (pageViewIndex == 3) {
      _setTiles(WeatherMapTypes.wnd);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    _setTiles(WeatherMapTypes.ta2);
    getCurrentLocation();
    getCurrentWeather();
    currentWeatherModel.value = await weatherService.fetchCurrentWeatherData(
        center.longitude, center.longitude);
    load();
  }

  getCurrentLocation() {
    markers.add(Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(30),
        markerId: const MarkerId("CurrentId"),
        position: _navigationController.currentLocation.value != null
            ? _navigationController.currentLocation.value!
            : center));
    load();
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
}

enum WeatherState { max, min, current }
