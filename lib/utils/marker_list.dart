import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memory_map/pages/images_page.dart';
import 'package:memory_map/pages/settings_page.dart';
import 'package:memory_map/utils/marker_data.dart';
import 'package:memory_map/providers/marker_provider.dart';
import 'package:memory_map/utils/marker_list_tile.dart';
import 'package:provider/provider.dart';

class MarkerDrawer extends StatelessWidget {
  const MarkerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? "";
    List<MarkerData> markers = context.watch<MarkerProvider>().getMarkers;
    List<MarkerData> userMarkers = markers.where((marker) => marker.userID == userID).toList();

    return Drawer(  
      backgroundColor: Colors.lightBlue.shade300,
      width: 250,
      elevation: 20.0,
      child: Column(
  
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Your Markers", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Icon(Icons.arrow_downward_outlined),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userMarkers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MarkerListTile(marker: userMarkers[index], index: index,)
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings, size: 30,),
                  Text("Settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
              },
            ),
          )
        ],
      ),
    );
  }
}