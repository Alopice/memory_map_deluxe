import 'package:flutter/material.dart';

class AboutText extends StatelessWidget {
  final String text;
  const AboutText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w900),
      textAlign: TextAlign.center,
    );
  }
}