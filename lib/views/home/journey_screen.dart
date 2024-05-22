import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          height: 200,
          width: 200,
        ),
      ),
    );
  }
}
