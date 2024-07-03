import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:navigationapp/controllers/saved_routes.dart';

class SavedRotatesView extends StatelessWidget {
  SavedRoutesController savedRoutes = Get.find();
  SavedRotatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kayıtlı Rotalar"),
        ),
        body: ListView.builder(
          itemCount: savedRoutes.savedRoutes.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(
                  "${savedRoutes.savedRoutes[index].startingCity}-${savedRoutes.savedRoutes[index].destinationCity}"),
              trailing: const Icon(Icons.navigate_next),
              onTap: () {
                // ListTile tıklandığında yapılacak işlemler buraya
                //print('${items[index]} seçildi');
              },
            );
          },
        ));
  }
}
