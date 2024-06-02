import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/models/user.dart';

class WeatherScreenController extends GetxController {
  final PageController pageController = PageController();

  var pageViewIndex = 0.obs;
  indexInc() {
    pageViewIndex(pageViewIndex.value + 1);
  }

  indexDown() {
    pageViewIndex(pageViewIndex.value + -1);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
