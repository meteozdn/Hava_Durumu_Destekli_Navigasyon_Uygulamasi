import 'package:animated_expandable_fab/expandable_fab/action_button.dart';
import 'package:animated_expandable_fab/expandable_fab/expandable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';
import 'package:navigationapp/views/home/journeys/journey_screen.dart';
import 'package:navigationapp/views/home/navigation_screen.dart';
import 'package:navigationapp/views/home/weather_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  RxInt _index = 0.obs;
  final List<String> titles = ["Hava Durumu", "Navigasyon", "Yolcluk"];
  final UserController userController = Get.find();

  void indexController(int num) {
    _index(num);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const NavigationScreen(),
      JourneyScreen(),
    ];

    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
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
            : ExpandableFab(
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
              ),
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
                      : const ElevatedWidgetButton(
                          image: WeatherIcons.sunny,
                          height: 30,
                          width: 70,
                          text: '20',
                        ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(NavigationConstants.profileView);
                    },
                    child: CircleAvatar(
                      backgroundImage: userController.user.value!.image != null
                          ? NetworkImage(userController.user.value!.image!)
                          : null,
                      backgroundColor: ColorConstants.pictionBlueColor,
                      // radius: 50.h,
                      child: userController.user.value!.image == null
                          ? Icon(
                              Icons.person,
                              size: 50.w,
                            )
                          : null,
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
      shadowColor: Colors.transparent, backgroundColor: Colors.white,
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
            Icons.assistant_navigation,
            size: 30.r, color: ColorConstants.pictionBlueColor,
            //  color: ProjectColors.white,
          ),
          icon: Icon(
            Icons.assistant_navigation,
            size: 30.r,
            //  color: ProjectColors.navyBlue,
          ),
          label: titles[1],
        ),
        NavigationDestination(
          selectedIcon: const Badge(
            label: Text('3'),
            child: Icon(
              size: 30, color: ColorConstants.pictionBlueColor,
              Icons.time_to_leave,
              //  color: ProjectColors.white,
            ),
          ),
          icon: Badge(
            label: const Text('2'),
            child: Icon(
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
                    backgroundColor: ColorConstants.pictionBlueColor,
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
                    ? ColorConstants.pictionBlueColor
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
                borderSide:
                    const BorderSide(color: ColorConstants.pictionBlueColor),
                borderRadius: BorderRadius.all(Radius.circular(15.r)))),
      ),
    );
  }
}
