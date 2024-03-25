import 'dart:io';

import 'package:flutter/cupertino.dart';

abstract class PlatformWidget extends StatelessWidget {
  const PlatformWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Platform.isIOS ? buildIOSWidget(context) : buildAndroidWidget(context);

  Widget buildAndroidWidget(BuildContext context);
  Widget buildIOSWidget(BuildContext context);
}
