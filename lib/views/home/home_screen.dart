import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:navigationapp/controllers/map_controller/map_weather_controller.dart';
import 'package:navigationapp/controllers/navigation_controller.dart';
import 'package:navigationapp/controllers/theme_change_controller.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';
import 'package:navigationapp/views/home/journeys/journey_screen.dart';
import 'package:navigationapp/views/home/navigation/create_route_view.dart';
import 'package:navigationapp/views/home/navigation/navigation_screen.dart';

class HomeScreen extends StatelessWidget {
  final ThemeChanger themeChanger = Get.find();

  HomeScreen({super.key});
  // ignore: prefer_final_fields
  RxInt _index = 0.obs;
  final List<String> titles = ["Hava Durumu", "Navigasyon", "Yolcluk"];
  final UserController userController = Get.find();
  final MapWeatherController weatherScreenController =
      Get.put(MapWeatherController());

  void indexController(int num) {
    _index(num);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      NavigationScreen(),
      JourneyScreen(),
    ];

    return Obx(() {
      return Scaffold(
        //  backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _index.value == 1
            ? FloatingActionButton(
                onPressed: () {
                  Get.toNamed(NavigationConstants.message);
                },
                child: const Icon(
                  Icons.message,
                  color: ColorConstants.whiteColor,
                ),
              )
            : FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        width: 500.h,
                        height: 200.h,
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //  mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Get.to(() =>
                                            CreateRouteView(isPlanned: false));
                                      },
                                      icon: Icon(
                                        Icons.navigation,
                                        size: 50.r,
                                      ),
                                    ),
                                    Text(
                                      "Güvenli\nSürüş",
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.midBlack,
                                    )
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 50.0),
                                  child: VerticalDivider(
                                    width: 2,
                                  ),
                                ),
                                //  const SizedBox(height: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Get.to(() =>
                                            CreateRouteView(isPlanned: true));
                                      },
                                      icon: Icon(Icons.watch_later, size: 50.r),
                                    ),
                                    Text(
                                      "Sürüş\nPlanla",
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.midBlack,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.navigation_rounded,
                  color: ColorConstants.whiteColor,
                ),
              )
        /*   ExpandableFab(
                openIcon: const Icon(
                  Icons.add,
                  color: ColorConstants.whiteColor,
                ),
                distance: 80,
                children: [
                  ActionButton(
                    color: ColorConstants.pictionBlueColor,
                    icon: const Icon(
                      Icons.navigation_rounded,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return const NavigationSheet(
                              //  isTimed: true,
                              title: "Hızlı Sürüş",
                            );
                          });
                    },
                  ),
                  ActionButton(
                    color: ColorConstants.pictionBlueColor,
                    icon: const Icon(
                      Icons.health_and_safety,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return const NavigationSheet(
                              isTimed: true,
                              title: "Güvenli Sürüş",
                            );
                          });
                    },
                  ),
                  ActionButton(
                    color: ColorConstants.pictionBlueColor,
                    icon: const Icon(
                      Icons.watch_later_rounded,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return const NavigationSheet(
                              isTimed: true,
                              title: "İleri Tarihli Sürüş",
                            );
                          });
                    },
                  ),
                ],
              ),*/
        ,
        body: Stack(
          children: [
            screens[_index.value],
            Padding(
              padding: EdgeInsets.only(top: 60.0.h, left: 30.w, right: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _index.value == 1
                      ? const SizedBox.shrink()
                      : ElevatedWidgetButton(
                          image: weatherScreenController
                                      .currentWeatherModel.value.main ==
                                  null
                              ? WeatherIcons.partlyCloudy
                              : weatherScreenController.getIcon(),
                          height: 30,
                          width: 70,
                          temp: weatherScreenController
                                      .currentWeatherModel.value.main ==
                                  null
                              ? 0
                              : weatherScreenController
                                  .currentWeatherModel.value.main!.temp!,
                        ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(NavigationConstants.profileView);
                    },
                    child: CircleAvatar(
                      radius: 20.h,
                      backgroundColor: ColorConstants.blackColor,
                      child: CircleAvatar(
                        radius: 18.h,

                        backgroundImage: userController.user.value == null
                            ? null
                            : NetworkImage(userController.user.value!.image),
                        backgroundColor: ColorConstants.blackColor,
                        // radius: 50.h,
                        child: userController.user.value == null
                            ? Icon(
                                Icons.person,
                                size: 30.w,
                              )
                            : null,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: bottomNav(),
      );
    });
  }

  NavigationBar bottomNav() {
    return NavigationBar(
      indicatorColor: themeChanger.isLight.value
          ? ColorConstants.pictionBlueColor
          : ColorConstants.blackColor,
      backgroundColor: themeChanger.isLight.value
          ? ColorConstants.lightBlue
          : ColorConstants.darkGrey,
      shadowColor: Colors.transparent,
      elevation: 0,
      height: 55.h,
      //  backgroundColor: ProjectColors.paleCornflowerBlue,
      onDestinationSelected: (int index) {
        indexController(index);
      },
      //  indicatorColor: ProjectColors.navyBlue,
      selectedIndex: _index.value,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: Icon(
            color: themeChanger.isLight.value
                ? ColorConstants.whiteColor
                : ColorConstants.whiteColor,
            Icons.assistant_navigation,
            //  color: ProjectColors.white,
          ),
          icon: Icon(
            color: themeChanger.isLight.value
                ? ColorConstants.pictionBlueColor
                : ColorConstants.whiteColor,
            Icons.assistant_navigation,
            size: 30.r,
            //  color: ProjectColors.navyBlue,
          ),
          label: titles[1],
        ),
        NavigationDestination(
          selectedIcon: Badge(
            label: Text('3'),
            child: Icon(
              color: themeChanger.isLight.value
                  ? ColorConstants.whiteColor
                  : ColorConstants.whiteColor,
              //  size: 30, color: ColorConstants.blackColor,
              Icons.time_to_leave,
              //  color: ProjectColors.white,
            ),
          ),
          icon: Badge(
            label: const Text('2'),
            child: Icon(
              color: themeChanger.isLight.value
                  ? ColorConstants.pictionBlueColor
                  : ColorConstants.whiteColor,
              Icons.time_to_leave,
              size: 30.r,
              //   color: ProjectColors.navyBlue,
            ),
          ),
          label: titles[2],
        ),
      ],
    );
  }
}

class NavigationSheet extends StatelessWidget {
  const NavigationSheet({
    super.key,
    this.isTimed = false,
    required this.title,
  });
  final bool isTimed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: ColorConstants.redColor,
      decoration: BoxDecoration(
          color: ColorConstants.whiteColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r))),
      height: isTimed ? 400.h : 310.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
            ),
            const ElevatedInputWidget(
              label: "Nereden",
            ),
            const IconTextButton(),
            const ElevatedInputWidget(
              label: "Nereden",
            ),
            isTimed
                ? Padding(
                    padding: EdgeInsets.only(top: 15.0.h),
                    child: ProjectDatePicker(
                      context: context,
                    ),
                  )
                : const SizedBox.shrink(),
            isTimed
                ? Padding(
                    padding: EdgeInsets.only(top: 15.0.h),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0.w),
                          child: SelectedButtonWidget(text: "Hatırlatıcı"),
                        ),
                        SelectedButtonWidget(text: "Paylaş")
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.only(top: 15.0.h),
              child: SizedBox(
                width: 400.w,
                height: 40.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.blackColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r), // <-- Radius
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Onayla",
                    style: TextStyle(
                        color: ColorConstants.whiteColor, fontSize: 20.sp),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SelectedButtonWidget extends StatelessWidget {
  SelectedButtonWidget({
    super.key,
    required this.text,
  });
  final String text;
  RxBool selected = false.obs;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(() {
        return GestureDetector(
          onTap: () {
            selected(!selected.value);
          },
          child: Container(
            width: 80.w,
            height: 20.h,
            decoration: BoxDecoration(
                color: selected.value
                    ? ColorConstants.blackColor
                    : ColorConstants.whiteColor,
                border: Border.all(
                  color: selected.value
                      ? ColorConstants.whiteColor
                      : ColorConstants.blackColor,
                ),
                borderRadius: BorderRadius.circular(20.r)),
            child: Center(
                child: Text(
              text,
              style: TextStyle(
                color: selected.value
                    ? ColorConstants.whiteColor
                    : ColorConstants.blackColor,
              ),
            )),
          ),
        );
      }),
    );
  }
}

class ProjectDatePicker extends StatelessWidget {
  const ProjectDatePicker({
    super.key,
    required this.context,
  });
  final BuildContext context;
  Future<void> _selectDate() async {
    await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 3.h,
      child: TextField(
        onTap: () {
          _selectDate();
        },
        style: const TextStyle(color: ColorConstants.blackColor),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.date_range),
          labelStyle: const TextStyle(color: ColorConstants.blackColor),
          labelText: "Tarih",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.r))),
        ),
        readOnly: true,
      ),
    );
  }
}

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: GestureDetector(
        onTap: () {},
        child: Material(
            borderRadius: BorderRadius.circular(15),
            elevation: 3,
            child: Container(
              width: 600.h,
              height: 30.h,
              decoration: BoxDecoration(
                color: ColorConstants.greyColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      IconsConst.blackNavigateIcon,
                      height: 14.h,
                    ),
                    Text(
                      "Şu anki konumu kullan.",
                      style: AppTextStyle.midBlack.copyWith(fontSize: 15.sp),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class ElevatedInputWidget extends StatelessWidget {
  const ElevatedInputWidget({
    super.key,
    this.label = "",
  });
  final String label;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 3,
      child: TextField(
        style: const TextStyle(color: ColorConstants.blackColor),
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.location_on),
            labelStyle: const TextStyle(color: ColorConstants.blackColor),
            labelText: label,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorConstants.redColor),
                borderRadius: BorderRadius.all(Radius.circular(15.r))),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorConstants.blackColor),
                borderRadius: BorderRadius.all(Radius.circular(15.r)))),
      ),
    );
  }
}
