import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:memory_map/pages/images_page.dart';
import 'package:memory_map/pages/settings_page.dart';
import 'package:memory_map/utils/dialogue_box.dart';
import 'package:memory_map/utils/marker_data.dart';
import 'package:memory_map/providers/marker_provider.dart';
import 'package:memory_map/utils/marker_list_tile.dart';
import 'package:provider/provider.dart';

class MarkerListPage extends StatelessWidget {
  const MarkerListPage({super.key});
  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DialogBox(),
    );
  }
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user?.uid ?? "";
    List<MarkerData> markers = context.watch<MarkerProvider>().getMarkers;
    List<MarkerData> userMarkers = markers.where((marker) => marker.userID == userID).toList();

    return Scaffold(  
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: ()=>openDialog(context),
              icon: Icon(Icons.add_circle_outline_sharp, color: Colors.indigoAccent, size: 30,),
            ),
          ),
        ],
      ),
      body: userMarkers.isNotEmpty? Column(
  
        children: [
          
            
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
         
        ],
      ):
      Center(child: Lottie.asset("assets\\background_animations\\emptyboxgirl.json", height: 300)),
    );
  }
}