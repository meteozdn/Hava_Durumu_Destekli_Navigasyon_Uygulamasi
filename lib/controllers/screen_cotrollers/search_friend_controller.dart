import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/models/user.dart';

class SearchFriendsController extends GetxController {
  //SearchFriendsController({})

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<User> _friends = <User>[].obs;
  final RxList<String> _buttonTexts = <String>[].obs;
  List<User> get friends => _friends;
  List<String> get buttonTexts => _buttonTexts;
  final UserController _userController = Get.find();

  @override
  Future<void> onInit() async {
    fetchFriends();
    super.onInit();
  }

  Future<void> fetchFriends() async {
    final User user = _userController.user.value!;
    try {
      for (var friend in user.friends!) {
        _friends.add(await _userController.fetchUser(userId: friend));
        //  print();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
