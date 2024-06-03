import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';
import 'package:navigationapp/views/auth/auth_screen.dart';
import 'package:navigationapp/views/home/home_screen.dart';
import 'package:navigationapp/views/main/main_screen.dart';
import 'package:navigationapp/views/message/message_list_view.dart';
import 'package:navigationapp/views/profile/profile_view.dart';
import 'package:navigationapp/views/search/search_view.dart';

class NavigationService {
  static List<GetPage> routes = [
    GetPage(
      name: NavigationConstants.message,
      page: () => const MessageView(),
    ),
    GetPage(
      name: NavigationConstants.home,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: NavigationConstants.auth,
      page: () => AuthScreen(),
    ),
    GetPage(
      name: NavigationConstants.main,
      page: () => const MainScreen(),
    ),
    GetPage(
      name: NavigationConstants.profileView,
      page: () => ProfileView(),
    ),
    GetPage(
      name: NavigationConstants.search,
      page: () => SearchView(
        title: "",
      ),
    ),
  ];
}
