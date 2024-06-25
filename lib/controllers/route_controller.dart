import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/models/chat_group.dart';
import 'package:navigationapp/models/route.dart';

class RouteController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserController _userController = Get.find<UserController>();
  final ChatGroupController _chatGroupController = Get.find();
  final RxList<RouteModel> userRoutes = <RouteModel>[].obs;
  final RxList<RouteModel> sharedRoutes = <RouteModel>[].obs;

  Future<void> fetchUserRoutes() async {
    try {
      userRoutes.clear();
      sharedRoutes.clear();
      // Get user's routeIds from userController.
      List<String> ids = _userController.user.value!.routes ?? [];
      // Get routes from firestore.
      for (String id in ids) {
        DocumentSnapshot snapshot = await _firestore
            .collection(FirestoreCollections.routes)
            .doc(id)
            .get();
        // Create Route model.
        RouteModel route = RouteModel.fromFirestore(snapshot);
        userRoutes.add(route);
      }
      // Get shared routesIds from chatGroupController.
      Set<String> sharedIdsSet = {};
      for (ChatGroup chatGroup in _chatGroupController.chatGroups) {
        sharedIdsSet.addAll(chatGroup.sharedRoutes);
      }
      List<String> sharedIds = sharedIdsSet.toList();
      // Get shared routes from firestore.
      for (String id in sharedIds) {
        DocumentSnapshot snapshot = await _firestore
            .collection(FirestoreCollections.routes)
            .doc(id)
            .get();
        // Create Route model.
        RouteModel route = RouteModel.fromFirestore(snapshot);
        if (route.ownerId != _userController.currentUserId) {
          //&& !sharedRoutes.contains(route)
          sharedRoutes.add(route);
        }
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  RouteModel createRouteModel(
      {required GeoPoint startingLocation,
      required String startingCity,
      required GeoPoint destinationLocation,
      required String destinationCity,
      required DateTime dateTime,
      required List<String> sharedChatGroups}) {
    try {
      // Create auto Id.
      final id = _firestore.collection(FirestoreCollections.routes).doc().id;
      // Create Route model.
      RouteModel route = RouteModel(
        id: id,
        ownerId: _userController.currentUserId,
        userImage: _userController.user.value?.image,
        ownerName:
            "${_userController.user.value!.name} ${_userController.user.value!.surname}",
        plannedAt: dateTime,
        startingLocation: startingLocation,
        startingCity: startingCity,
        destinationLocation: destinationLocation,
        destinationCity: destinationCity,
        isActive: false,
        sharedChatGroups: sharedChatGroups,
      );
      return route;
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
      final id = _firestore.collection(FirestoreCollections.routes).doc().id;
      // Create Route model.
      RouteModel route = RouteModel(
        id: id,
        ownerId: _userController.currentUserId,
        userImage: _userController.user.value?.image,
        ownerName:
            "${_userController.user.value!.name} ${_userController.user.value!.surname}",
        plannedAt: dateTime,
        startingLocation: startingLocation,
        startingCity: startingCity,
        destinationLocation: destinationLocation,
        destinationCity: destinationCity,
        isActive: false,
        sharedChatGroups: sharedChatGroups,
      );
      await _firestore
          .collection(FirestoreCollections.routes)
          .doc(id)
          .set(route.toJson());
      // Save Route to ChatGroups in firestore.
      for (var chatGroupId in sharedChatGroups) {
        await updateChatGroupsRouteList(chatGroupId: chatGroupId, routeId: id);
      }
      await updateUserRouteList(routeId: route.id);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // Method to update route for user's friends who see the route.
  Future<void> updateRoute({required RouteModel route}) async {
    try {
      // Update the route in Firestore.
      await _firestore
          .collection(FirestoreCollections.routes)
          .doc(route.id)
          .update(route.toJson());
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // Method to delete route.
  Future<void> deleteRoute({required String routeId}) async {
    try {
      // Get the route document from Firestore.
      DocumentSnapshot routeSnapshot = await _firestore
          .collection(FirestoreCollections.routes)
          .doc(routeId)
          .get();
      RouteModel route = RouteModel.fromFirestore(routeSnapshot);
      // Delete the route from Firestore.
      await _firestore
          .collection(FirestoreCollections.routes)
          .doc(routeId)
          .delete();
      // Remove the route from each shared chat group.
      for (var chatGroupId in route.sharedChatGroups) {
        await updateChatGroupsRouteList(
            chatGroupId: chatGroupId, routeId: routeId, isAdding: false);
      }
      // Remove the route from the user's route list.
      await updateUserRouteList(routeId: routeId, isAdding: false);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> updateRouteSharedChatGroupList({
    required String routeId,
    required String chatGroupId,
    required bool isAdding,
  }) async {
    try {
      // Update the sharedChatGroups list
      await _firestore
          .collection(FirestoreCollections.routes)
          .doc(routeId)
          .update({
        "sharedChatGroups": isAdding
            ? FieldValue.arrayUnion([chatGroupId])
            : FieldValue.arrayRemove([chatGroupId])
      });
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
      String currentUserId = _userController.currentUserId;
      // Save to firestore.
      await _firestore
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

  //Method to update chatGropus sharedRoute list.
  Future<void> updateChatGroupsRouteList({
    required String chatGroupId,
    required String routeId,
    bool isAdding = true,
  }) async {
    try {
      // Save to firestore.
      await _firestore
          .collection(FirestoreCollections.chatGroups)
          .doc(chatGroupId)
          .update({
        "sharedRoutes": isAdding
            ? FieldValue.arrayUnion([routeId])
            : FieldValue.arrayRemove([routeId])
      });
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
