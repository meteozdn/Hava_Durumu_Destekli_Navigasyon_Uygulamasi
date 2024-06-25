import 'package:flutter/material.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class WeatherMarker extends StatelessWidget {
  final String weatherIcon;
  final double weatherTemp;
  final bool isNight;

  WeatherMarker({
    super.key,
    required this.weatherIcon,
    required this.weatherTemp,
    required this.isNight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor:
                isNight ? ColorConstants.blackColor : ColorConstants.lightGrey,
            child: CircleAvatar(
              backgroundColor: isNight
                  ? ColorConstants.lightGrey
                  : ColorConstants.pictionBlueColor,
              radius: 55,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("${weatherTemp.toInt().toString()}°C",
                      style: const TextStyle(
                          fontSize: 30,
                          color: ColorConstants.blackColor,
                          fontWeight: FontWeight.bold)),
                  Image.asset(
                    weatherIcon,
                    width: 50,
                  )
                ],
              ),
            ),
          ),
          CustomPaint(
            painter: _Triangle(
              isNight ? ColorConstants.blackColor : ColorConstants.greyColor,
            ),
            size: const Size(40, 40),
          ),
        ],
      ),
    );
  }
}

class _Triangle extends CustomPainter {
  final Color color;

  _Triangle(
    this.color,
  );
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
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
