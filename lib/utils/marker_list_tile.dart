import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:memory_map/pages/images_page.dart';
import 'package:memory_map/providers/marker_provider.dart';
import 'package:memory_map/utils/marker_data.dart';
import 'package:provider/provider.dart';

class MarkerListTile extends StatefulWidget {
  final MarkerData marker;
  final int index;
  const MarkerListTile({super.key,required this.marker, required this.index});

  @override
  State<MarkerListTile> createState() => _MarkerListTileState();
}

class _MarkerListTileState extends State<MarkerListTile> {
 bool visible = true;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 90,
          width: 1000,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    Text(widget.marker.weekday.substring(0,3), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,color: Colors.grey),),
                    Text(widget.marker.dayDate, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700,color: Colors.deepPurpleAccent), ),
                    Text(widget.marker.month.substring(0,3), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,color: Colors.indigoAccent),),
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0, right: 1.0),
                child: VerticalDivider(color: Colors.black,),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: SizedBox(
                      width: 160,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.marker.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20
                          ),
                          ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                     
                      children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 50.0),
                        child: Text("Views: ${widget.marker.viewed}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,color: Colors.grey),),
                      ),
                      Text("Images: ${widget.marker.images.length}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,color: Colors.grey),),
                    ],),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: DropdownButton(
                  
                  items: [
                    DropdownMenuItem(value: "delete", child: Text("Delete"),),
                    DropdownMenuItem(value: "images", child: Text("images"),),
                  ], 
                  onChanged: (value){
                    if(value == "delete"){
                      setState(() {
                        visible = false;
                      });
                      Provider.of<MarkerProvider>(context, listen: false).removeMarker(widget.index);
                    }else if(value == "images"){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ImagesPage(index: widget.index,)));
                    }
                  }, icon: Icon(Icons.more_horiz_outlined),),
              )
            ],
          ),
        ),
      ),
    );
  }
}