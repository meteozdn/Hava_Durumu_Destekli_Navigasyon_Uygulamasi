import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/core/controllers/user_controller.dart';
import 'package:navigationapp/core/models/user.dart';

class SearchUserController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<User> _users = <User>[].obs;
  final RxList<String> _buttonTexts = <String>[].obs;
  List<User> get users => _users;
  List<String> get buttonTexts => _buttonTexts;

  Future<void> searchUsers(String searchTerm) async {
    try {
      users.clear();
      buttonTexts.clear();
      final getUsers = await Get.find<UserController>()
          .searchUsersByUsername(search: searchTerm);
      for (var user in getUsers) {
        final text = await getFriendState(friendId: user.id);
        buttonTexts.add(text);
      }
      _users.assignAll(getUsers);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<String> getFriendState({required String friendId}) async {
    List<Future<void>> futures = [];
    String text = "Add Friend";
    // If user already sent friend request.
    futures.add(_getFriendRequestSnapshot(
            senderId: Get.find<UserController>().user.value!.id,
            recipientId: friendId)
        .then((value) {
      if (value!.docs.isNotEmpty) {
        text = "Remove Request";
      }
    }));
    // If user already received friend request.
    futures.add(_getFriendRequestSnapshot(
            senderId: friendId,
            recipientId: Get.find<UserController>().user.value!.id)
        .then((value) {
      if (value!.docs.isNotEmpty) {
        text = "Accept Request";
      }
    }));
    futures.add(Get.find<UserController>()
        .fetchUser(userId: Get.find<UserController>().user.value!.id)
        .then((value) {
      if (value.friends!.contains(friendId)) {
        text = "Remove Friend";
      }
    }));
    await Future.wait(futures);
    return text;
  }

  Future<QuerySnapshot?> _getFriendRequestSnapshot({
    required String senderId,
    required String recipientId,
  }) async {
    QuerySnapshot querySnapshot = await firestore
        .collection(FirestoreCollections.friendRequests)
        .where("senderId", isEqualTo: senderId)
        .where("recipientId", isEqualTo: recipientId)
        .get();
    return querySnapshot;
  }

  void updateButtonText({required String buttonText, required int index}) {
    switch (buttonText) {
      case "Remove Request":
        buttonTexts[index] = "Add Friend";
        break;
      case "Accept Request":
        buttonTexts[index] = "Remove Friend";
        break;
      case "Remove Friend":
        buttonTexts[index] = "Add Friend";
        break;
      case "Add Friend":
        buttonTexts[index] = "Remove Request";
        break;
      default:
    }
  }
}
