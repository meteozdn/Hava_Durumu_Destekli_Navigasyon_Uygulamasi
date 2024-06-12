import 'package:flutter/material.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class WeatherMarker extends StatelessWidget {
  const WeatherMarker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundColor: ColorConstants.pictionBlueColor,
            child: CircleAvatar(
              backgroundColor: ColorConstants.whiteColor,
              radius: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("25",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Image.asset(
                    IconsConst.sunnyIcon,
                    height: 80,
                  )
                ],
              ),
            ),
          ),
          CustomPaint(
            painter: _Triangle(),
            size: Size(60, 60),
          ),
        ],
      ),
    );
  }
}

class _Triangle extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      // ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width / 2, size.height); // Koni ucu
    path.lineTo(0, 0); // Sol alt köşe
    path.quadraticBezierTo(
      size.width / 2,
      size.height / 3, // Kontrol noktası (merkezde biraz aşağıda)
      size.width, 0, // Sağ alt köşe
    );

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
