import 'package:cloud_firestore/cloud_firestore.dart';

class Route {
  final String id;
  final String ownerId;
  final DateTime plannedAt;
  final GeoPoint destinationLocation;
  bool isActive;
  GeoPoint? startingLocation;
  DateTime? startedAt;
  String? startedWeather;
  GeoPoint? location;
  DateTime? locationLastUpdate;
  String? weather;
  DateTime? weatherLastUpdate;
  String? speed;
  DateTime? speedLastUpdate;
  DateTime? estimatedFinishTime;
  String? estimatedFinishTimeWeather;

  Route(
      {required this.id,
      required this.ownerId,
      required this.plannedAt,
      required this.destinationLocation,
      required this.isActive,
      this.startingLocation,
      this.startedAt,
      this.startedWeather,
      this.location,
      this.locationLastUpdate,
      this.weather,
      this.weatherLastUpdate,
      this.speed,
      this.speedLastUpdate,
      this.estimatedFinishTime,
      this.estimatedFinishTimeWeather});

  factory Route.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Route(
      id: data["id"],
      ownerId: data["ownerId"],
      plannedAt: data["plannedAt"].toDate(),
      startingLocation: data["startingLocation"],
      destinationLocation: data["destinationLocation"],
      isActive: data["isActive"],
      startedAt: data["startedAt"]?.toDate(),
      startedWeather: data["startedWeather"],
      location: data["location"],
      locationLastUpdate: data["locationLastUpdate"]?.toDate(),
      weather: data["weather"],
      weatherLastUpdate: data["weatherLastUpdate"]?.toDate(),
      speed: data["speed"],
      speedLastUpdate: data["speedLastUpdate"]?.toDate(),
      estimatedFinishTime: data["estimatedFinishTime"]?.toDate(),
      estimatedFinishTimeWeather: data["estimatedFinishTimeWeather"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "ownerId": ownerId,
        "plannedAt": plannedAt,
        "startingLocation": startingLocation,
        "destinationLocation": destinationLocation,
        "isActive": isActive,
        "startedAt": startedAt,
        "startedWeather": startedWeather,
        "location": location,
        "locationLastUpdate": locationLastUpdate,
        "weather": weather,
        "weatherLastUpdate": weatherLastUpdate,
        "speed": speed,
        "speedLastUpdate": speedLastUpdate,
        "estimatedFinishTime": estimatedFinishTime,
        "estimatedFinishTimeWeather": estimatedFinishTimeWeather,
      };
}
