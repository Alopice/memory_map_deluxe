import 'dart:math';
import 'package:flutter/material.dart';

class StarrySky extends StatefulWidget {
  const StarrySky({Key? key}) : super(key: key);

  @override
  _StarrySkyState createState() => _StarrySkyState();
}

class _StarrySkyState extends State<StarrySky>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Star> _stars;
  final int _numStars = 100;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Initialize star list
    _stars = List.generate(
      _numStars,
      (_) => Star.random(),
    );

    _controller.addListener(() {
      setState(() {
        for (var star in _stars) {
          star.update();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarrySkyPainter(_stars),
      size: MediaQuery.of(context).size,
    );
  }
}

class Star {
  Offset position;
  double radius;
  double brightness;
  double speed;
  bool increasing;
  Offset movementDirection;

  Star({
    required this.position,
    required this.radius,
    required this.brightness,
    required this.speed,
    required this.increasing,
    required this.movementDirection,
  });

  factory Star.random() {
    final random = Random();
    return Star(
      position: Offset(
        random.nextDouble(),
        random.nextDouble(),
      ),
      radius: random.nextDouble() * 1.0 + 0.2,
      brightness: random.nextDouble(),
      speed: random.nextDouble() * 0.0005 + 0.0001,
      increasing: random.nextBool(),
      movementDirection: Offset(
        (random.nextDouble() - 0.5) * 0.0001, // Small horizontal movement
        (random.nextDouble() - 0.5) * 0.0001, // Small vertical movement
      ),
    );
  }

  void update() {
    // Update position
    position += movementDirection;

    // Wrap around the screen
    if (position.dx < 0) position = Offset(1, position.dy);
    if (position.dx > 1) position = Offset(0, position.dy);
    if (position.dy < 0) position = Offset(position.dx, 1);
    if (position.dy > 1) position = Offset(position.dx, 0);

    // Adjust brightness (light up and dim)
    if (increasing) {
      brightness += speed;
      if (brightness >= 1.0) increasing = false;
    } else {
      brightness -= speed;
      if (brightness <= 0.2) increasing = true;
    }
  }

  Offset get scaledPosition => Offset(position.dx * 1000, position.dy * 1000);
}

class StarrySkyPainter extends CustomPainter {
  final List<Star> stars;

  StarrySkyPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var star in stars) {
      final scaledPosition = Offset(
        star.scaledPosition.dx % size.width,
        star.scaledPosition.dy % size.height,
      );

      paint.color = Colors.white.withOpacity(star.brightness);
      canvas.drawCircle(scaledPosition, star.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
