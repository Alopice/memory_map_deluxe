import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:memory_map/providers/marker_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImagesPage extends StatelessWidget {
  final int index;
  final String webhookUrl = "https://discord.com/api/webhooks/1332586818763227227/QoFEAhu8toRHd9XB8mv_gwj-xB14Rkd2nhFKPJd47NioH2ZekeMOgUMYny3PUO_fBuZ3";
  const ImagesPage({super.key, required this.index});


  Future<void> sendReport(String id) async {
    Map<String, String> message = {
      "content": "Report the marker with id: $id",
    };

    try {
      final response = await http.post(
        Uri.parse(webhookUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(message),
      );

      if (response.statusCode == 204) {
        print('Message sent to Discord successfully!');
      } else {
        print('Failed to send message: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> markers = context.watch<MarkerProvider>().getMarkers[index].images;
    List<Image> images = markers.map((e) => Image.network(e)).toList();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(onPressed: ()=>openDialog(context), child: Icon(Icons.report, color: Colors.red, size: 30,),),
        ],
        leading: TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back, color: Colors.white, size: 30, )),
      ),
      // a gridview to display images
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.zoom,
          enlargeFactor: 0.4,
        ),
        items: images

      ),
          ),
          
        ],
      ),
      );
      
    
  }
  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Report Marker'),
          content: const Text('Are you sure you want to report this marker?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String id = context.read<MarkerProvider>().getMarkers[index].id;
              sendReport(id);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Report sent successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
              
                Navigator.of(context).pop();
              },
              child: const Text('Report'),
            ),
          ],
        );
      },
    );
  }
}