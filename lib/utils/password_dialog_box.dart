import 'package:flutter/material.dart';
import 'package:memory_map/pages/camera_page.dart';
import 'package:memory_map/utils/marker_data.dart';

class PasswordDialogBox extends StatelessWidget {
  final MarkerData marker;
  const PasswordDialogBox({super.key, required this.marker});

  bool checkPassword(String password) {
    if (password == marker.password) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController tcontroller = TextEditingController();

    return AlertDialog(
      content: SizedBox(
        height: 200,
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: tcontroller,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  if (checkPassword(tcontroller.text)) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CameraView(
                            markerLatitude: marker.position.latitude,
                            markerLongitude: marker.position.longitude,
                            radius: 10.0)));
                  } else {
                    const SnackBar(
                        content: Text("Incorrect Password"),
                        duration: Duration(seconds: 2));
                  }
                },
                child: const Text("OK")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("CANCEL")),
          ],
        ),
      ],
    );
  }
}
