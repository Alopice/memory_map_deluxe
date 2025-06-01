import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:memory_map/utils/marker_data.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class MarkerProvider extends ChangeNotifier {
  List<MarkerData> _markers = [];
  final Uuid _uuid = const Uuid();
  List<Marker> _pointMarkers = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<MarkerData> get getMarkers => _markers;
  List<Marker> get getPointMarkers => _pointMarkers;

  MarkerProvider() {
    retrieveData();
  }

  Future<void> addMarker(String name, bool isPublic, List<XFile> images, String password) async {
    DateTime now = DateTime.now();
    String weekday = DateFormat('EEEE').format(now);
    String dayDate = DateFormat('dd').format(now);
    String month = DateFormat('MMMM').format(now);
    
    final id = _uuid.v4();
    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    String userID = "";

    if (user != null) {
      userID = user.uid;
    }

    Position position = await Geolocator.getCurrentPosition();
    List<String> imageUrls = await uploadImages(images);

    MarkerData newMarker = MarkerData(
        id: id,
        images: imageUrls,
        position: position,
        userID: userID,
        isPublic: isPublic,
        name: name,
        password: password,
        weekday: weekday,
        dayDate: dayDate,
        month: month,
        viewed: 0,
        viewedBy: {}
        );

    _markers.add(newMarker);
    _pointMarkers.add(Marker(
      point: LatLng(position.latitude, position.longitude),
      child: const FlutterLogo(),
    ));

    // Save to global 'markers' collection
    await firestore.collection("markers").add({
      "id": id,
      "images": imageUrls,
      "position": {
        "latitude": position.latitude,
        "longitude": position.longitude,
      },
      "userID": userID,
      "isPublic": isPublic,
      "name": name,
      "password": password,
      "weekday": weekday,
      "dayDate": dayDate,
      "month": month,
      "viewed": 0,
      "viewedBy": {}

    });

    notifyListeners();
  }

  Future<void> removeMarker(int index) async {
    firebase_auth.User? user = FirebaseAuth.instance.currentUser;
    String userID = "";

    if (user != null) {
      userID = user.uid;
    }

    MarkerData markerToRemove = _markers[index];
    _markers.removeAt(index);
    _pointMarkers.removeAt(index);

    // Remove from Firestore global 'markers' collection
    QuerySnapshot query = await firestore
        .collection("markers")
        .where("id", isEqualTo: markerToRemove.id)
        .where("userID", isEqualTo: userID)
        .get();

    for (var doc in query.docs) {
      await doc.reference.delete();
    }

    notifyListeners();
  }

  Future<List<String>> uploadImages(List<XFile> imageFiles) async {
    final supabase = Supabase.instance.client;
    List<String> downloadUrls = [];

    try {
      for (XFile xfile in imageFiles) {
        final file = File(xfile.path);

        // Generate a unique file path (you can customize it)
        final filePath =
            'images/${DateTime.now().millisecondsSinceEpoch}_${file.hashCode}.jpg';

        // Upload the file to Supabase storage
        final response =
            await supabase.storage.from('images').upload(filePath, file);

        if (response.isNotEmpty) {
          print("Empty");
        }

        // Retrieve the public URL of the uploaded image
        final String downloadUrl =
            supabase.storage.from('images').getPublicUrl(filePath);
        downloadUrls.add(downloadUrl);
      }

      return downloadUrls;
    } catch (e) {
      print('Failed to upload images: $e');
      throw e;
    }
  }

  Future<void> retrieveData() async {
    // Listen for real-time updates to the 'markers' collection
    firestore.collection('markers').snapshots().listen((querySnapshot) {
      // Map the Firestore documents to MarkerData
      print("fafefafeaf");
      _markers = querySnapshot.docs.map((doc) {
        var data = doc.data();
        return MarkerData(
            id: data['id'],
            images: List<String>.from(data['images']),
            position: Position(
              latitude: data['position']['latitude'],
              longitude: data['position']['longitude'],
              timestamp: DateTime.now(),
              accuracy: 0,
              altitude: 0,
              altitudeAccuracy: 0,
              heading: 0,
              headingAccuracy: 0,
              speed: 0,
              speedAccuracy: 0,
            ),
            userID: data['userID'],
            isPublic: data['isPublic'],
            name: data["name"],
            password: data["password"],
            weekday: data["weekday"],
            dayDate: data["dayDate"],
            month: data["month"],
            viewed: data["viewed"],
            viewedBy: data["viewedBy"]
            
            );
      }).toList();

      // Convert MarkerData to FlutterMap markers
      _pointMarkers = _markers.map((marker) {
        return Marker(
          point: LatLng(marker.position.latitude, marker.position.longitude),
          child: const FlutterLogo(),
        );
      }).toList();
      print(_markers);
      // Notify listeners to update the UI
      notifyListeners();
    });
  }


  void updateViewed(int index) {
    firebase_auth.User? user = FirebaseAuth.instance.currentUser;
    if(user!.uid != _markers[index].userID){
       _markers[index].viewedBy.add(user.uid);
      _markers[index].viewed = _markers[index].viewedBy.length;
    }
   

    updateMarker(_markers[index], index);
    notifyListeners();
  }
  Future<void> updateMarker(MarkerData marker, int index) async {
  try {
    // Update Firestore first
    await firestore.collection("markers").doc(marker.id).update({
      "images": marker.images,
      "name": marker.name,
      "isPublic": marker.isPublic,
      "password": marker.password,
      "weekday": marker.weekday,
      "dayDate": marker.dayDate,
      "month": marker.month,
      "viewed": marker.viewed
    });

    // Only update local list if Firestore update succeeds
    _markers[index] = marker;
    notifyListeners();
  } catch (e) {
    print("Failed to update marker: $e");
  }
}
 
}
