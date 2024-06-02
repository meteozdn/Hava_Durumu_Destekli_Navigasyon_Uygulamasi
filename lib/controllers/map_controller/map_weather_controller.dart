import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ForecastTileProvider implements TileProvider {
  // final String mapType;

//  ForecastTileProvider({required this.mapType});
  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    Uint8List tileBytes = Uint8List(0);

    try {
      final url =
          "https://tile.openweathermap.org/map/pressure_new/$zoom/$x/$y.png?appid=1561ccdb27bea8d65e5dca8f1223cdc2";

      //final url =
      //   "http://maps.openweathermap.org/maps/2.0/weather/PR0/$zoom/$x/$y?appid=1561ccdb27bea8d65e5dca8f1223cdc2";
      final uri = Uri.parse(url);
      final imageData = await NetworkAssetBundle(uri).load("");
      tileBytes = imageData.buffer.asUint8List();
    } catch (e) {
      print(e);
    }

    return Tile(256, 256, tileBytes);
  }
}
