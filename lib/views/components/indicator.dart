import 'package:flutter/material.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class ProjectIndicator extends StatelessWidget {
  final bool isActive;
  const ProjectIndicator({
    super.key,
    required this.isActive,
    this.index,
  });
  final int? index;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.all(5),
      width: isActive ? 40.0 : 10.0,
      height: 10.0,
      decoration: BoxDecoration(
          color: index == 0
              ? isActive
                  ? ColorConstants.pastelMagentaColor
                  : ColorConstants.pictionBlueColor
              : isActive
                  ? ColorConstants.pictionBlueColor
                  : ColorConstants.pastelMagentaColor,
          borderRadius: BorderRadius.circular(8)),
    );
  }
}
