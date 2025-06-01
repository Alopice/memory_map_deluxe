import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final Widget addingWidget;
  final String topText;
  final String bottomText;
  const SettingsTile({super.key, required this.addingWidget, required this.topText, required this.bottomText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          height: 70,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white70,
            border: Border.all(
              color: Colors.black
            ),
            borderRadius: BorderRadius.circular(8.5)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
            
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                                    bottomText,
                                    style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20
                                    ),
                                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: addingWidget,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}