import 'package:flutter/material.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class MessageView extends StatelessWidget {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.pictionBlueColor,
                  iconColor: ColorConstants.whiteColor),
              onPressed: () {},
              child: const Icon(Icons.person_add_alt_1),
            ),
          )
        ],
      ),
    );
  }
}
