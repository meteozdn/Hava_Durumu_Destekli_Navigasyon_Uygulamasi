import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstants {
  static const String appName = 'Navi App';
  static String openWeatherApiKey = 'd23f3624098ff746d0953cb3c0640e1b';
  static String weatherBitApiKey = 'aab6d70cac1f4119ade84672d50f0618';
  static String googleMapsApiKey = "AIzaSyDA9541Tfh0jVOTKmYz-nFn03i6Eb9cO4E";

  // For JourneyController.
  static const String weatherAPIKey = "b3baa2e76f1fde182c7a298d21287a93";
  static const List<String> adverseWeathers = [
    "Thunderstorm",
    "Drizzle",
    "Rain",
    "Snow",
    "Mist",
    "Smoke",
    "Haze",
    "Dust",
    "Fog",
    "Sand",
    "Ash",
    "Squall",
    "Tornado"
  ];

  // static const int responseTimeout = 60;
  // static int? userType;
}

class AppTextStyle {
  static final smallWhite = TextStyle(color: ColorConstants.whiteColor);
  static final midBlack = TextStyle(fontSize: 20.sp, color: Colors.black);
}

class ColorConstants {
  /*static const Color pinkColor = Color(0xFFE24E74);
  static const Color greyColor = Color(0xFFD9D9D9);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF2C3333);
  static const Color greenColor = Color(0xFF8EC148);
  static const Color redColor = Color(0xFFD94555);
  static const Color purpleColor = Color(0xFF7C5DA4);
  static const Color blackPurpleColor = Color(0xFF3D2E6B);
  static const Color orangeColor = Color(0xFFFF9255);
  static const Color likedColor = Color(0xFFFFC830);
  static const Color leftPlateColor = Color(0xFFF8BA43);
  static const Color lightPinkColor = Color(0xFFFFEBFF);
  static const Color pictionBlueColor = Color(0xFF61B9ED);*/
  static const Color cardinalColor = Color(0xFFBD1742);
  static const Color lightBlue = Color(0xFFE0EEFD);
  static const Color pastelMagentaColor = Color(0xFFBD1742);
  static const Color pictionBlueColor = Color.fromARGB(255, 137, 197, 232);
  //static const Color blackColor = Color(0xFF2C3333);
  //static const Color pictionBlueColor = Color(0xFF61B9ED);
  static const Color blackColor = Color(0xFF2C3333);
  static const Color orangeColor = Color(0xFFFF9255);
  static const Color purpleColor = Color(0xFF7C5DA4);
  static const Color blackPurpleColor = Color(0xFF3D2E6B);
  static const Color leftPlateColor = Color(0xFFF8BA43);
  static const Color lightGrey = Color(0xFFECECEC);
  static const Color transparent = Colors.transparent;
  static const Color darkGrey = Color(0xFF232323);

  static const Color greenColor = Color(0xFF8EC148);
  static const Color yellow = Color(0xFFFFFF00);
  static const Color yellowColor = Color.fromARGB(255, 248, 206, 91);

  static const Color redColor = Color(0xFFD94555);
  static const Color pinkColor = Color(0xFFE24E74);
  static const Color greyColor = Color(0xFF999999);
  static const Color whiteColor = Color(0xFFFFFFFF);
}

class WeatherIcons {
  static const sunny = "lib/assets/icons/sunny.png";
  static const partlyCloudy = "lib/assets/icons/partlyCloudy.png";
  static const thunder = "lib/assets/icons/thunder.png";
  static const rainy = "lib/assets/icons/rainy.png";
  static const snow = "lib/assets/icons/snow.png";
}

class Animations {
  static const safeCar = "lib/assets/animations/safeCar.json";
  static const journeyCar = "lib/assets/animations/journeyCar.json";
  static const a = "lib/assets/animations/a.json";
  static const notFound = "lib/assets/animations/lottie_data_not_found.json";
  static const load = "lib/assets/animations/ld1.json";
  static const ld1 = "lib/assets/animations/f.json";
  static const ld2 = "lib/assets/animations/loadcar.json";

  // static const safeCar = "lib/assets/animations/safeCar.json";
}

class IconsConst {
  static const root = "lib/assets/icons/";
  static const friends = "lib/assets/icons/friends.png";
  static const sunnyIcon = "lib/assets/icons/01d.png";
  static const thunderIcon = "lib/assets/icons/11n.png";
  static const logo1 = "lib/assets/icons/logo1.png";
  static const logo2 = "lib/assets/icons/logo2.png";
  static const logo3 = "lib/assets/icons/logo3.png";
  static const flag = "lib/assets/icons/flag.png";
  static const compass = "lib/assets/icons/compass.png";
  static const calender = "lib/assets/icons/calendar.png";

  static const blackNavigateIcon = "lib/assets/icons/navigate.png";
  static const windIcon = "lib/assets/icons/wind.png";
  static const markerIcon = "lib/assets/icons/location.png";
}

class ImageConst {
  static const compass = "lib/assets/images/BlankCompass.png";
  static const arrow = "lib/assets/images/rightArrow.png";
  static const sad = "lib/assets/images/sad.png";
  static const smile = "lib/assets/images/smile.png";
  static const neutral = "lib/assets/images/neutral.png";
  static const disaster = "lib/assets/images/disaster.png";
  static const profile = "lib/assets/images/mnd.jpeg";
}

class NavigationConsts {
  static const idle = "idle";
  static const route = "route";
  static const onDestination = "on destination";
  static const north = 'north';
  static const east = 'east';
  static const south = 'south';
  static const west = 'west';
  static const northEast = 'northeast';
  static const northWest = 'northwest';
  static const southEast = 'southeast';
  static const southWest = 'southwest';
  static const straight = 'straight';
  static const right = 'right';
  static const left = 'left';
}
