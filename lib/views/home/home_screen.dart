import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/views/home/journey_screen.dart';
import 'package:navigationapp/views/home/navigation_screen.dart';
import 'package:navigationapp/views/home/weather_screen.dart';
import 'package:navigationapp/views/profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final RxInt _index = 1.obs;
  final List<String> titles = ["Hava Durumu", "Navigasyon", "Yolculuk"];

  void indexController(int num) {
    _index(num);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const WeatherScreen(),
      const NavigationScreen(),
      const JourneyScreen(),
    ];
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(titles[_index.value]),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // Navigate to the profile screen
                Get.to(() => ProfileScreen());
              },
            ),
          ],
        ),
        body: screens[_index.value],
        bottomNavigationBar: bottomNav(),
      );
    });
  }

  NavigationBar bottomNav() {
    return NavigationBar(
      //  backgroundColor: ProjectColors.paleCornflowerBlue,
      onDestinationSelected: (int index) {
        indexController(index);
      },
      //  indicatorColor: ProjectColors.navyBlue,
      selectedIndex: _index.value,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: const Icon(
            Icons.cloud,
            size: 30,
            // color: ProjectColors.white,
          ),
          icon: const Icon(
            Icons.cloud,
            size: 30,
            //  color: ProjectColors.navyBlue,
          ),
          label: titles[0],
        ),
        NavigationDestination(
          selectedIcon: const Icon(
            Icons.assistant_navigation,
            size: 30,
            //  color: ProjectColors.white,
          ),
          icon: const Icon(
            Icons.assistant_navigation,
            size: 30,
            //  color: ProjectColors.navyBlue,
          ),
          label: titles[1],
        ),
        NavigationDestination(
          selectedIcon: const Badge(
            label: Text('3'),
            child: Icon(
              size: 30,
              Icons.time_to_leave,
              //  color: ProjectColors.white,
            ),
          ),
          icon: const Badge(
            label: Text('2'),
            child: Icon(
              Icons.time_to_leave,
              size: 30,
              //   color: ProjectColors.navyBlue,
            ),
          ),
          label: titles[2],
        ),
      ],
    );
  }
}
