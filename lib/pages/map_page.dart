import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:memory_map/providers/location_provider.dart';
import 'package:memory_map/providers/marker_provider.dart';
import 'package:provider/provider.dart';

class MapPage extends StatelessWidget {
  
 const MapPage({super.key});

  @override
Widget build(BuildContext context) {
  

  Provider.of<LocationProvider>(context, listen: false).getUserLocation();
  
  Position pos = context.watch<LocationProvider>().pos;

  return MaterialApp(
    home: Scaffold(
      
    body: FlutterMap(
      options:  MapOptions(
        initialCenter: LatLng(pos.latitude, pos.longitude), // Center the map over London
        initialZoom: 15.0,
      ),
      children: [
        TileLayer( // Display map tiles from any source
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
          userAgentPackageName: 'com.example.app',
          // And many more recommended properties!
        ),
        
        MarkerLayer(
          markers: context.watch<MarkerProvider>().getPointMarkers,
        )
      ],
    ),
    ),
  );
}
}