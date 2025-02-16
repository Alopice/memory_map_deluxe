import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:memory_map/providers/marker_provider.dart';
import 'package:memory_map/utils/marker_data.dart';
import 'package:workmanager/workmanager.dart';

class LocationProvider extends ChangeNotifier {
  StreamSubscription<Position>? _positionStream;
  double distanceInMeters = 0;
  double distan = 10.0;
  bool isWithin = false;
  int _index = 0;
  Set foundMarkers = {};
  Position _userPosition = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
  MarkerData _markerData = MarkerData(
    id: "",
    images: [],
    position: Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    ),
    userID: "",
    isPublic: true,
    name: " ",
    password: "",
    weekday: "",
    dayDate: "",
    month: "",
    viewed: 0,
    viewedBy: {},
  );
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();
  Position get pos => _userPosition;
  double get distance => distanceInMeters;
  double get dist => distan;
  MarkerData get marker => _markerData;
  int get index => _index;
  Set get found => foundMarkers;

LocationProvider(){
getFound();
}


  /// Starts listening for location updates and checks proximity to markers in real time.
 void startListeningForProximity(List<MarkerData> markers) async {
  stopListening(); // Stop previous stream if any
  _userPosition = await Geolocator.getCurrentPosition(); // Get immediate update
  checkProximityToMarkers(markers);

  _positionStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best, // Best possible accuracy
      timeLimit: Duration(seconds: 5), // Optional: refresh every 5 seconds
    ),
  ).listen((Position position) {
    _userPosition = position;
    checkProximityToMarkers(markers);
  });
}

  void getUserLocation() async {
    _userPosition = await Geolocator.getCurrentPosition();
    notifyListeners();
  }
  /// Stops listening to location updates.
  void stopListening() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  /// Checks proximity to all markers and updates isWithin accordingly.
  void checkProximityToMarkers(List<MarkerData> markers) {
    
    User? user = FirebaseAuth.instance.currentUser;
    
    String userID = user?.uid ?? "";
    bool foundNearbyMarker = false;

    for (var i = 0; i < markers.length; i++) {
      var marker = markers[i];
      double distance = Geolocator.distanceBetween(
        _userPosition.latitude,
        _userPosition.longitude,
        marker.position.latitude,
        marker.position.longitude,
      );

      if (distance < distan && marker.userID != userID) {
        foundMarkers.add(marker.id);
        addFound(foundMarkers);
        isWithin = true;
        _markerData = marker;
        _index = i;
        foundNearbyMarker = true;
        break;
      }
    }

    if (!foundNearbyMarker) {
      isWithin = false;
    }
   
    notifyListeners();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
  void addFound(Set foundMarkersSet) async{


    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? "";

    await FirebaseFirestore.instance.collection('users').doc(userID).set({
    'foundMarkers': foundMarkersSet.toList(),
  
  });
  }
  void getFound() async{
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? "";
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(userID).get();
    foundMarkers = documentSnapshot.get('foundMarkers').toSet();
    notifyListeners();
  }

}