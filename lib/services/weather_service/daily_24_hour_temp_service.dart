import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class Daily24HourTempService {
  // final String mapType;

//  ForecastTileProvider({required this.mapType});

  Future fetchDaily24HoursWeatherData(double lan, double lat) async {
    try {
      final url =
          "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lan&appid=${AppConstants.openWeatherApiKey}";
//561ccdb27bea8d65e5dca8f1223cdc2
      final uri = Uri.parse(url);
      http.Response response = await http.get(uri);

      String data = response.body;
      print(data);
    } catch (e) {
      print(e);
    }

    // return Tile(256, 256, tileBytes);
  }

  Future fetch16DaysWeatherData(double lan, double lat) async {
    try {
      final url =
          "https://api.openweathermap.org/data/2.5/forecast/daily?lat=$lat&lon=$lan&cnt=7&appid=${AppConstants.openWeatherApiKey}";
//561ccdb27bea8d65e5dca8f1223cdc2
      final uri = Uri.parse(url);
      http.Response response = await http.get(uri);

      String data = response.body;
      print(data);
    } catch (e) {
      print(e);
    }

    // return Tile(256, 256, tileBytes);
  }
}
