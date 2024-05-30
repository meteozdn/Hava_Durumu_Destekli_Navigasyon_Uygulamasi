import 'package:geolocator/geolocator.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigationController extends GetxController {
  var _currentPosition = Rxn<Position>();
  var currentPositionLL = Rxn<LatLng>();
  var state = true.obs;

  final LatLng center = const LatLng(39, 32);

  @override
  void onInit() async {
    await determinePosition();
    state(false);
    super.onInit();
  }

//Get current location
  Future<Position> determinePosition() async {
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
    Position position = await Geolocator.getCurrentPosition();
    _currentPosition.value = position;
    currentPositionLL.value = LatLng(position.latitude, position.longitude);
    return position;
  }

  LatLng? getPosition(double latitude, double longitude) {
    return LatLng(latitude, longitude);
  }
}
