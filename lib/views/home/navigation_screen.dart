import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/core/controllers/route_controller.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: MaterialButton(
          onPressed: addRoute,
          color: Colors.deepPurple,
          child: const Text("Random Route"),
        ),
      ),
    );
  }

  void addRoute() async {
    var destinationLocation =
        GeoPoint(Random().nextDouble(), Random().nextDouble());
    await Get.find<RouteController>()
        .createRoute(destinationLocation: destinationLocation);
  }
}
