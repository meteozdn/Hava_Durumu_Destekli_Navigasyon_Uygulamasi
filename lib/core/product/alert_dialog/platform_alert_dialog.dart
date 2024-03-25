import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import '../platform_widgets.dart';

class PlatformAlertDialog extends PlatformWidget {
  final String title;
  final String contentText;
  final String? cancelButtonText;
  final String? basicButtonText;
  final VoidCallback? onPressedBasicButton;
  final VoidCallback? onPressedButton;
  final bool? barrierDismissible;
  final bool isSuccessful;

  const PlatformAlertDialog(
      {Key? key,
      required this.title,
      required this.contentText,
      this.basicButtonText,
      this.cancelButtonText,
      this.onPressedButton,
      this.onPressedBasicButton,
      this.barrierDismissible,
      this.isSuccessful = false})
      : super(key: key);

  Future<bool?> showDialogPlatform(BuildContext context) async {
    bool? result = Platform.isIOS
        ? await showCupertinoDialog(
            context: (context),
            builder: (context) => this,
            barrierDismissible:
                cancelButtonText != null ? false : barrierDismissible ?? true)
        : await showDialog(
            context: (context),
            builder: (context) => this,
            barrierDismissible:
                cancelButtonText != null ? false : barrierDismissible ?? true);
    return result;
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: isSuccessful
          ? Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.done, color: Colors.white),
                ),
                Text(title)
              ],
            )
          : Text(title),
      content: _contentWidget(contentText, context),
      actions: _dialogButtonsActions(context),
    );
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: isSuccessful
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.done, color: Colors.white),
                ),
              ],
            )
          : Text(title),
      content: _contentWidget(contentText, context),
      actions: _dialogButtonsActions(context),
    );
  }

  List<Widget> _dialogButtonsActions(BuildContext context) {
    final List<Widget> allButtons = <Widget>[];
    if (Platform.isAndroid) {
      allButtons.add(
        TextButton(
          onPressed: onPressedBasicButton,
          child: Text(basicButtonText ?? ""),
        ),
      );
      if (cancelButtonText != null) {
        allButtons.add(
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(cancelButtonText!),
          ),
        );
      }
    } else {
      allButtons.add(
        CupertinoDialogAction(
          onPressed: onPressedBasicButton,
          child: Text(basicButtonText ?? ""),
        ),
      );
      if (cancelButtonText != null) {
        allButtons.add(
          CupertinoDialogAction(
            child: Text(cancelButtonText!),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        );
      }
    }
    return allButtons;
  }

  Text _contentWidget(String content, BuildContext context) {
    return Text(content);
  }
}
