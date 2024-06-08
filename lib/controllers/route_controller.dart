import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/models/chat_group.dart';
import 'package:navigationapp/models/route.dart';

class RouteController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserController userController = Get.find<UserController>();
  final RxList<Route> userRoutes = <Route>[].obs;
  final RxList<Route> sharedRoutes = <Route>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchUserRoutes();
  }

  Future<void> fetchUserRoutes() async {
    try {
      userRoutes.clear();
      sharedRoutes.clear();
      // Store routes in local.
      List<String> ids = userController.user.value!.routes ?? [];
      // Get routes from firestore.
      for (String id in ids) {
        DocumentSnapshot snapshot = await firestore
            .collection(FirestoreCollections.routes)
            .doc(id)
            .get();
        // Create Route model.
        Route route = Route.fromFirestore(snapshot);
        userRoutes.add(route);
      }
      // Get shared routes Ids from chatGroups
      List<ChatGroup> chatGroups = Get.find<ChatGroupController>().chatGroups;
      List<String> sharedIds = [];
      for (ChatGroup chatGroup in chatGroups) {
        sharedIds.addAll(chatGroup.sharedRoutes);
      }
      // Get shared routes from firestore.
      for (String id in sharedIds) {
        DocumentSnapshot snapshot = await firestore
            .collection(FirestoreCollections.routes)
            .doc(id)
            .get();
        // Create shared Route model.
        Route route = Route.fromFirestore(snapshot);
        if (route.ownerId != userController.user.value!.id) {
          //&& !sharedRoutes.contains(route)
          sharedRoutes.add(route);
        }
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> createRoute(
      {required GeoPoint startingLocation,
      required String startingCity,
      required GeoPoint destinationLocation,
      required String destinationCity,
      required DateTime dateTime,
      required List<String> sharedChatGroups}) async {
    try {
      // Create auto Id.
      final id = firestore.collection(FirestoreCollections.routes).doc().id;
      // Create Route model.
      Route route = Route(
        id: id,
        ownerId: Get.find<UserController>().user.value!.id,
        userImage: Get.find<UserController>().user.value?.image,
        ownerName:
            "${Get.find<UserController>().user.value!.name} ${Get.find<UserController>().user.value!.surname}",
        plannedAt: dateTime,
        startingLocation: startingLocation,
        startingCity: startingCity,
        destinationLocation: destinationLocation,
        destinationCity: destinationCity,
        isActive: false,
        sharedChatGroups: sharedChatGroups,
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
      await firestore
          .collection(FirestoreCollections.users)
          .doc(currentUserId)
          .update({
        "routes": isAdding
            ? FieldValue.arrayUnion([routeId])
            : FieldValue.arrayRemove([routeId])
      });
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
