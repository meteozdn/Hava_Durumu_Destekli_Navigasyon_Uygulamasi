import 'package:flutter/material.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class ProjectIndicator extends StatelessWidget {
  final bool isActive;
  final int? index;
  Color? firstColor;
  Color? secondColor;
  bool? isTwo;

  ProjectIndicator({
    super.key,
    required this.isActive,
    this.firstColor = ColorConstants.blackColor,
    this.secondColor = ColorConstants.redColor,
    this.isTwo = false,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.all(5),
      width: isActive ? 40.0 : 10.0,
      height: 10.0,
      decoration: BoxDecoration(
          color: isTwo!
              ? isActive
                  ? firstColor
                  : secondColor
              : index == 0
                  ? isActive
                      ? firstColor
                      : secondColor
                  : isActive
                      ? firstColor
                      : secondColor,
          borderRadius: BorderRadius.circular(8)),
    );
  }
}
