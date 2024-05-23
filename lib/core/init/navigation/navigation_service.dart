import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';
import 'package:navigationapp/export.dart';
import 'package:navigationapp/views/home/home_screen.dart';
import 'package:navigationapp/views/message/message_view.dart';

class NavigationService {
  static List<GetPage> routes = [
    GetPage(
      name: NavigationConstants.message,
      page: () => MessageView(),
    ),
    GetPage(
      name: NavigationConstants.home,
      page: () => HomeScreen(),
    ),
  ];
}
