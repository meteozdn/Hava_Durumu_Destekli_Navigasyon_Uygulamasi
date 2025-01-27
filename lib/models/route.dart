import 'package:cloud_firestore/cloud_firestore.dart';

class RouteModel {
  final String id;
  final String ownerId;
  final String ownerName;
  final DateTime plannedAt;
  final GeoPoint startingLocation;
  final String startingCity;
  final GeoPoint destinationLocation;
  final String destinationCity;
  bool isActive;
  List<String> sharedChatGroups;
  DateTime? startedAt;
  String? startedWeather;
  GeoPoint? location;
  DateTime? locationLastUpdate;
  String? weather;
  String? userImage;
  DateTime? weatherLastUpdate;
  String? speed;
  DateTime? speedLastUpdate;
  DateTime? estimatedFinishTime;
  String? estimatedFinishTimeWeather;

  RouteModel(
      {required this.id,
      required this.ownerId,
      required this.ownerName,
      required this.plannedAt,
      required this.startingLocation,
      required this.startingCity,
      required this.destinationLocation,
      required this.destinationCity,
      required this.isActive,
      required this.sharedChatGroups,
      this.startedAt,
      this.startedWeather,
      this.location,
      this.locationLastUpdate,
      this.weather,
      this.weatherLastUpdate,
      this.speed,
      this.speedLastUpdate,
      this.estimatedFinishTime,
      this.userImage,
      this.estimatedFinishTimeWeather});

  factory RouteModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return RouteModel(
      id: data["id"],
      ownerId: data["ownerId"],
      ownerName: data["ownerName"],
      userImage: data["userImage"],
      plannedAt: data["plannedAt"].toDate(),
      startingLocation: data["startingLocation"],
      startingCity: data["startingCity"],
      destinationLocation: data["destinationLocation"],
      destinationCity: data["destinationCity"],
      isActive: data["isActive"],
      sharedChatGroups:
          (data["sharedChatGroups"] as List<dynamic>).cast<String>(),
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
        "ownerName": ownerName,
        "userImage": userImage,
        "plannedAt": plannedAt,
        "startingLocation": startingLocation,
        "startingCity": startingCity,
        "destinationLocation": destinationLocation,
        "destinationCity": destinationCity,
        "isActive": isActive,
        "sharedChatGroups": sharedChatGroups,
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
