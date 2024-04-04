import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/core/controllers/user_controller.dart';
import 'package:navigationapp/core/models/route.dart';

class RouteController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var routes = <Route>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchUserRoutes();
  }

  Future<void> createRoute({
    required GeoPoint startingLocation,
    required GeoPoint destinationLocation,
  }) async {
    try {
      // Create auto Id.
      final routeId =
          firestore.collection(FirestoreCollections.routes).doc().id;
      // Create Route model.
      Route route = Route(
        id: routeId,
        ownerId: Get.find<UserController>().user.value!.id,
        plannedAt: DateTime.now(),
        startingLocation: startingLocation,
        destinationLocation: destinationLocation,
        isStarted: false,
      );
      // Save Route to firestore.
      await firestore
          .collection(FirestoreCollections.routes)
          .doc(routeId)
          .set(route.toJson());
      await Get.find<UserController>().updateUserRouteList(routeId: route.id);
      await fetchUserRoutes();
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> fetchUserRoutes() async {
    try {
      List<String> routeIds =
          Get.find<UserController>().user.value!.routes ?? [];
      List<Route> routes = [];
      // Get routes from firestore.
      for (String routeId in routeIds) {
        DocumentSnapshot snapshot = await firestore
            .collection(FirestoreCollections.routes)
            .doc(routeId)
            .get();
        // Create Route models.
        Route route = Route.fromFirestore(snapshot);
        routes.add(route);
      }
      this.routes.value = routes;
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
