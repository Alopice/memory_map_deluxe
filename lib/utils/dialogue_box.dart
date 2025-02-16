import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_map/providers/marker_provider.dart';
import 'package:provider/provider.dart';

class DialogBox extends StatefulWidget {
  const DialogBox({super.key});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  String selectedRadio = "none";
  @override
  Widget build(BuildContext context) {
    TextEditingController pController = TextEditingController();
    TextEditingController tcontroller = TextEditingController();
    var pointOps = context.read<MarkerProvider>();
    final ImagePicker picker = ImagePicker();
    List<XFile> images = [];

    void addMarkers() async{
      String name = tcontroller.text;
      String password = pController.text;
      bool isPublic;
      if(selectedRadio == "private"){
        isPublic = false;
      }
      else{
        isPublic = true;
      }
      pointOps.addMarker(name, isPublic, images, password);
    }

    return AlertDialog(
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 300,
       
        child: Center(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                controller: tcontroller,
              ),
        
              GroupButton(

                isRadio:true,
                buttons: const ["private", "public"],
                onSelected: (value, index, isSelected) {
                  setState(() {
                    selectedRadio = value;
                  });
                },
              ),

              Visibility(
                visible: selectedRadio == "private",
                child: FancyPasswordField(
                  controller: pController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              TextButton(onPressed: ()async{
                List<XFile> tempImages = await picker.pickMultiImage(limit: 20);
                if(tempImages.isNotEmpty){
                  images = tempImages;
                }
                else{
                  images.clear();
                }
              }, child: const Text("select images"))
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: (){
            
              if(tcontroller.text.trim() == ""){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:  Text('Please enter a name'),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(top: 10.0),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
              else if(selectedRadio == "none"){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:  Text('Please select visibility'),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(top: 10.0),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
              else{
                addMarkers();
                Navigator.of(context).pop();
              }
            }, 
            child: const Text("OK")),


            TextButton(onPressed: (){
              Navigator.of(context).pop();
            },
             child: const Text("CANCEL")),
          ],
        ),
      ],
    );
  }
}