import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

import '../platform_widgets.dart';

class PlatformErrorAlertDialog extends PlatformWidget {
  final String errorMessage;
  final List<Widget> actions;
  const PlatformErrorAlertDialog(
      {Key? key, required this.errorMessage, this.actions = const <Widget>[]})
      : super(key: key);

  Future<bool?> showDialogPlatform(BuildContext context) async {
    bool? result = Platform.isIOS
        ? await showCupertinoDialog(
            context: (context),
            builder: (context) => this,
          )
        : await showDialog(
            context: (context),
            builder: (context) => this,
          );
    return result;
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: const CircleAvatar(
        backgroundColor: ColorConstants.pinkColor,
        child: Icon(Icons.close, color: Colors.white),
      ),
      content: _contentWidget(errorMessage, context),
      actions: actions,
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: const CircleAvatar(
        backgroundColor: Colors.red,
        child: Icon(Icons.close, color: Colors.white),
      ),
      content: _contentWidget(errorMessage, context),
      actions: actions,
    );
  }

  Widget _contentWidget(String content, BuildContext context) {
    return Text(
      content,
      style: TextStyle(fontSize: 16.sp),
    );
  }
}
