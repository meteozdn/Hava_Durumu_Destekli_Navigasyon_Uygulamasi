import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/core/controllers/route_controller.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Yolculuğa başla"),
        ElevatedButton(onPressed: () {}, child: const Text("Şimdi başla")),
        ElevatedButton(onPressed: () {}, child: const Text("Rota planla")),
        const Text("Kayıtlı Rotalar"),
        Expanded(
          child: GetX<RouteController>(
            init: Get.find<RouteController>(),
            builder: (controller) {
              return ListView.builder(
                itemCount: controller.routes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.route),
                    title: Text(controller.routes[index].id),
                    onTap: () {},
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
