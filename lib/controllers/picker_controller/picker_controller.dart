import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navigationapp/controllers/auth_controller.dart';
import 'package:navigationapp/controllers/user_controller.dart';

class ProfilePicturePickerController extends GetxController {
  AuthController user = Get.find();
  UserController userController = Get.find();

  final _imagePicker = ImagePicker();
  final Rx<File?> _image = Rxn<File>();
  final storageRef = FirebaseStorage.instance.ref();
  String imageUrl = "";

  pickImage() async {
    var temp = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (temp != null) {
      _image.value = File(temp.path);
      _image.value = await _image.value!.exists() ? _image.value : File("");
    }
  }

  uploadImage() async {
    var uid = user.getAuthId();

    final storageRef = FirebaseStorage.instance.ref();
    Reference imageRefRoot = storageRef.child("images");
    Reference imageRefDir = imageRefRoot.child(uid);
    try {
      print("object");
      await imageRefDir.putFile(_image.value!);
      imageUrl = await imageRefDir.getDownloadURL();
      userController.updateProfilePhoto(image: imageUrl, uid: uid);
    } catch (e) {
      print(e);
    }
  }

  bool hasImage() => _image.value != null;
  void clearImage() => _image.value = null;

  File? get image => _image.value;
}
