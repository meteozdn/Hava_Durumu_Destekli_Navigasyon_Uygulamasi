import 'package:get/get.dart';
import 'package:navigationapp/models/route.dart';

class SavedRoutesController extends GetxController {
  RxList<RouteModel> savedRoutes = <RouteModel>[].obs;
  addSaved(RouteModel route) {
    savedRoutes.add(route);
  }
}
