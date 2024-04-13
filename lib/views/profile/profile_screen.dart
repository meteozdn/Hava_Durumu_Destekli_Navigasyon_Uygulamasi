import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/views/profile/friends_screen.dart';
import 'package:navigationapp/views/profile/messages_screen.dart';
import 'package:navigationapp/views/profile/user_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final RxInt _index = 1.obs;
  final List<String> titles = ["Mesajlar", "Profil", "Arkadaşlar"];

  void indexController(int num) {
    _index(num);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const MessagesScreen(),
      const UserScreen(),
      const FriendsScreen(),
    ];
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(titles[_index.value]),
        ),
        body: screens[_index.value],
        bottomNavigationBar: bottomNav(),
      );
    });
  }

  NavigationBar bottomNav() {
    return NavigationBar(
      onDestinationSelected: (int index) {
        indexController(index);
      },
      selectedIndex: _index.value,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: const Icon(
            Icons.message,
            size: 30,
          ),
          icon: const Icon(
            Icons.message,
            size: 30,
          ),
          label: titles[0],
        ),
        NavigationDestination(
          selectedIcon: const Icon(
            Icons.person,
            size: 30,
          ),
          icon: const Icon(
            Icons.person,
            size: 30,
          ),
          label: titles[1],
        ),
        NavigationDestination(
          selectedIcon: const Icon(
            size: 30,
            Icons.perm_contact_calendar_sharp,
          ),
          icon: const Icon(
            Icons.perm_contact_calendar_sharp,
            size: 30,
          ),
          label: titles[2],
        ),
      ],
    );
  }
}
