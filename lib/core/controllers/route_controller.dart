import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/core/controllers/user_controller.dart';
import 'package:navigationapp/core/models/route.dart';

class RouteController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<Route> _routes = <Route>[].obs;
  List<Route> get routes => _routes;

  @override
  void onInit() async {
    super.onInit();
    await fetchUserRoutes();
  }

  Future<void> fetchUserRoutes() async {
    try {
      routes.clear();
      // Store routes in local.
      List<String> ids = Get.find<UserController>().user.value!.routes ?? [];
      // Get routes from firestore.
      for (String id in ids) {
        DocumentSnapshot snapshot = await firestore
            .collection(FirestoreCollections.routes)
            .doc(id)
            .get();
        // Create Route model.
        Route route = Route.fromFirestore(snapshot);
        routes.add(route);
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> createRoute({
    required GeoPoint destinationLocation,
    GeoPoint? startingLocation,
  }) async {
    try {
      // Create auto Id.
      final id = firestore.collection(FirestoreCollections.routes).doc().id;
      // Create Route model.
      Route route = Route(
        id: id,
        ownerId: Get.find<UserController>().user.value!.id,
        plannedAt: DateTime.now(),
        startingLocation: startingLocation,
        destinationLocation: destinationLocation,
        isActive: false,
      );
      // Save Route to local.
      Get.find<UserController>().user.value!.routes?.add(id);
      // Save Route to firestore.
      await firestore
          .collection(FirestoreCollections.routes)
          .doc(id)
          .set(route.toJson());
      await updateUserRouteList(routeId: route.id);
      await fetchUserRoutes();
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  //Method to update users route list.
  Future<void> updateUserRouteList({
    required String routeId,
    bool isAdding = true,
  }) async {
    try {
      String currentUserId = Get.find<UserController>().user.value!.id;
      // Save to firestore.
      if (isAdding) {
        await firestore
            .collection(FirestoreCollections.users)
            .doc(currentUserId)
            .update({
          "routes": FieldValue.arrayUnion([routeId])
        });
      } else {
        await firestore
            .collection(FirestoreCollections.users)
            .doc(currentUserId)
            .update({
          "routes": FieldValue.arrayRemove([routeId])
        });
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
