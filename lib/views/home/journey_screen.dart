import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/core/controllers/route_controller.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<RouteController>(
        init: Get.find<RouteController>(),
        builder: (routeController) {
          return ListView.builder(
            itemCount: routeController.routes.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(routeController.routes[index].id),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
