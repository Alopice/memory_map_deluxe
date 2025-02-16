import 'package:flutter/material.dart';
import 'package:memory_map/utils/about_text.dart';

class AboutButton extends StatelessWidget {
  const AboutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(Icons.info_outline, size: 30,),
      onTap: (){
        showDialog(
          context: context, 
          builder: (context){
            return AlertDialog(
              content: SizedBox(
                height: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AboutText(text: "AR Memory Map is an app made with passion for pushing people for adventures"),
                    AboutText(text: "Programmed by: Sabeeh Ashraf T V"),
                    AboutText(text: "Designed by: Akhil Raj"),
                    AboutText(text: "Documented by: Sooraj"),
                    
                      Padding(
                        padding: const EdgeInsets.only(top: 200.0),
                        child: Column(
                          children: [
                            AboutText(text: "contact us for support"),
                            AboutText(text: "ourcompany@gmail.com"),
                          ],
                        ),
                      )
                      
                  ],
                ),
              ),
            );
          }
          
        );
      },
    );
  }
}