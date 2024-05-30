import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigationapp/controllers/map_controller/map_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class NavigationScreen extends StatelessWidget {
  NavigationScreen({super.key});
  final NavigationController _mapController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    RxInt x = 5.obs;

    Set<Marker> markers = {};
    late GoogleMapController googlemapController;
    final LatLng _center = LatLng(41.28667, 36.33);

    _onMapCreated(GoogleMapController controller) {
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
                    : _center,
                zoom: 7.h),
            onMapCreated: _onMapCreated, compassEnabled: true,
            myLocationButtonEnabled: false, zoomControlsEnabled: false,
            mapType: MapType.normal,

            // mapType: MapType.hybrid,
            //myLocationButtonEnabled: true,
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
    );
  }
}
