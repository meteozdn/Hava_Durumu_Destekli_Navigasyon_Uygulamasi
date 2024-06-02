import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigationapp/controllers/map_controller/map_controller.dart';
import 'package:navigationapp/controllers/map_controller/map_weather_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';

class NavigationScreen extends StatefulWidget {
  NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final NavigationController _mapController = Get.put(NavigationController());

  Set<TileOverlay> _tileOverlays = {};

  initTiles() async {
    final String overlayId = DateTime.now().millisecondsSinceEpoch.toString();
    final tileOverlay = TileOverlay(
        tileOverlayId: TileOverlayId(overlayId),
        tileProvider: ForecastTileProvider());
    setState(() {
      _tileOverlays = {tileOverlay};
    });
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};
    late GoogleMapController googlemapController;
    const LatLng center = LatLng(41.28667, 36.33);

    _onMapCreated(GoogleMapController controller) async {
      googlemapController = controller;
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Obx(() {
          _mapController.state.value;
          return GoogleMap(
            markers: markers,
            initialCameraPosition: CameraPosition(
                target: _mapController.currentPositionLL.value != null
                    ? _mapController.currentPositionLL.value!
                    : center,
                zoom: 7.h),
            onMapCreated: (GoogleMapController controller) {
              googlemapController = controller;
            },
            compassEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            tileOverlays: _tileOverlays,
          );
        }),
        Padding(
          padding: EdgeInsets.only(bottom: 15.0.h, right: 20.w),
          child: GestureDetector(
            child: CircleAvatar(
              backgroundColor: ColorConstants.pictionBlueColor,
              radius: 30.r,
              child: IconButton(
                  color: ColorConstants.whiteColor,
                  onPressed: () async {
                    Position position =
                        await _mapController.determinePosition();

                    googlemapController.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            zoom: 18,
                            target: LatLng(
                                position.latitude, position.longitude))));
                    markers.add(Marker(
                        markerId: const MarkerId("CurrentId"),
                        position:
                            LatLng(position.latitude, position.longitude)));
                    //print(markers);
                  },
                  icon: const Icon(Icons.location_searching_outlined)),
            ),
          ),
        )
      ],
    );
  }
}

class ElevatedWidgetButton extends StatelessWidget {
  const ElevatedWidgetButton({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.image,
  });
  final int width;
  final String text;
  final String image;
  final int height;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10.r),
      elevation: 3.h,
      child: GestureDetector(
        onTap: () {
          Get.toNamed(NavigationConstants.weather);
        },
        child: SizedBox(
          width: width.w,
          height: height.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  height: 20.w,
                  child: Image.asset(
                    image,
                    height: 20.h,
                  )),
              Text(
                "$text°",
                style: AppTextStyle.midBlack,
              )
            ],
          ),
        ),
      ),
    );
  }
}
