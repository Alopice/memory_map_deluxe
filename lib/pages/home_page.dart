import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:memory_map/pages/ar_page.dart';
import 'package:memory_map/pages/map_page.dart';
import 'package:memory_map/providers/location_provider.dart';
import 'package:memory_map/providers/marker_provider.dart';
import 'package:memory_map/utils/dialogue_box.dart';
import 'package:memory_map/utils/marker_data.dart';
import 'package:memory_map/utils/marker_list.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MarkerData> _previousMarkers = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final prefs = await SharedPreferences.getInstance();
    bool? hasRequested = prefs.getBool("location_permission_requested");

    if (hasRequested == null || !hasRequested) {
      await Geolocator.requestPermission();
      await prefs.setBool("location_permission_requested", true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var markers = Provider.of<MarkerProvider>(context).getMarkers;

    if (!const DeepCollectionEquality().equals(markers, _previousMarkers)) {
      _previousMarkers = List.from(markers);
      context.read<LocationProvider>().startListeningForProximity(markers);
    }
  }

  

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    bool isWithin = context.watch<LocationProvider>().isWithin;
    List<MarkerData> markers = context.watch<MarkerProvider>().getMarkers;
    List<MarkerData> userMarkers = markers.where((marker) => marker.userID == user!.uid).toList();
    Set foundMarkers = context.watch<LocationProvider>().found;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
            Text(user?.displayName!.split(" ")[0]??"", style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 20,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Center(child: Text("Markers placed: ${userMarkers.length}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),))),
                 Container(
                    height: 20,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Center(child: Text("Markers found: ${foundMarkers.length}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),))),
                ],),
            ),
            isWithin?
            Column(
              children: [
                Lottie.asset("assets\\background_animations\\box_jumping.json", height: 300, width: 300, fit: BoxFit.contain,),
                Text("Found a marker!", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),),
              ],
            )
            :
            Expanded(
              child: Column(
                children: [
                  Lottie.asset("assets\\background_animations\\searchingonboat.json", height: 300, width: 300, fit: BoxFit.contain,),
                  Text("Markers await your discovery!", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),),
                ],
              ),
            )
          ],
        ),
      )
      

      
    );
  }

}
