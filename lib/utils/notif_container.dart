import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:memory_map/pages/ar_page.dart';
import 'package:memory_map/utils/marker_data.dart';
import 'package:memory_map/utils/password_dialog_box.dart';

class NotifContainer extends StatelessWidget {
  final MarkerData marker;
  const NotifContainer({super.key, required this.marker});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: Colors.transparent,
      child: Column(
        children: [
           Text(marker.name),
          GestureDetector(
            onTap: () {
              if (marker.isPublic == false) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return PasswordDialogBox(marker: marker);
                  },
                );
              } else {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ARViewScreen()));
              }
            },
            child: Lottie.asset('assets/found_box.json',
                width: 300, height: 300, fit: BoxFit.contain),
          )
        ],
      ),
    );
  }
}
