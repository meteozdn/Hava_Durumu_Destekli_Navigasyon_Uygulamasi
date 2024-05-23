import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late GoogleMapController mapController;
    final LatLng _center = LatLng(39, 32);

    _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _center, zoom: 8.h),
      onMapCreated: _onMapCreated, compassEnabled: true,
      myLocationButtonEnabled: false,

      // mapType: MapType.hybrid,
      //myLocationButtonEnabled: true,
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
