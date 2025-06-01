import 'package:geolocator/geolocator.dart';

class MarkerData {
  final String id;
  List<String> images;
  Position position;
  String name;
  String userID;
  bool isPublic;
  String password;
  String weekday;
  String dayDate;
  String month;
  int viewed;
  Set viewedBy = {};
  MarkerData({
    required this.id, 
    required this.images, 
    required this.position,
    required this.name, 
    required this.userID, 
    required this.isPublic, 
    required this.password,
    required this.weekday,
    required this.dayDate,
    required this.month,
    required this.viewed,
    required this.viewedBy
    });
}
