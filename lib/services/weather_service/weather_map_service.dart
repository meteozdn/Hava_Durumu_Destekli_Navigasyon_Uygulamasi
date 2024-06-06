import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:navigationapp/core/constants/app_constants.dart';

class WeatherMapService implements TileProvider {
  // final String mapType;
  final String maptype = WeatherMapTypes.wnd;
//  ForecastTileProvider({required this.mapType});
  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    Uint8List tileBytes = Uint8List(0);

    try {
      //  final url =
      //      "https://tile.openweathermap.org/map/temp_new/$zoom/$x/$y.png?appid=d23f3624098ff746d0953cb3c0640e1b";

      final url2 =
          "http://maps.openweathermap.org/maps/2.0/weather/${maptype}/$zoom/$x/$y?&appid=${AppConstants.openWeatherApiKey}";
      final uri = Uri.parse(url2);
      final imageData = await NetworkAssetBundle(uri).load("");

      tileBytes = imageData.buffer.asUint8List();
      http.Response response = await http.get(uri);
      print(maptype);
      // print(response.headers);
      //print(tileBytes);
    } catch (e) {
      print(e);
    }

    return Tile(256, 256, tileBytes);
  }

/*
    try {
      final url =
          "https://tile.openweathermap.org/map/temp_new/$zoom/$x/$y.png?appid=1561ccdb27bea8d65e5dca8f1223cdc2";

      final url2 =
          "http://maps.openweathermap.org/maps/2.0/weather/PR0/$zoom/$x/$y?appid=d23f3624098ff746d0953cb3c0640e1b";
      final uri = Uri.parse(url2);
      final imageData = await NetworkAssetBundle(uri).load("");
      tileBytes = imageData.buffer.asUint8List();
      http.Response response = await http.get(uri);

      print(response.headers);
      //print(tileBytes);
    } catch (e) {
      print(e);
    }

    return Tile(256, 256, tileBytes);
  }*/
}

class WeatherMapTypes {
  static const String pac0 = "PAC0";
  static const String pr0 = "PR0";
  static const String pa0 = "PA0";
  static const String par0 = "PAR0";
  static const String pas0 = "PAS0";
  static const String sd0 = "SD0";
  static const String ws10 = "WS10";
  static const String wnd = "WND";
  // static const String hrd0 = "HRD0";

  static const String apm = "APM";
  static const String ta2 = "TA2";
  static const String td2 = "TD2";
  static const String ts0 = "TS0";
  static const String ts10 = "TS10";
  static const String hrd0 = "HRD0";
  static const String cl = "CL";
}
