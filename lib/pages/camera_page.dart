
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:lottie/lottie.dart';
import 'package:memory_map/pages/images_page.dart';
import 'package:memory_map/providers/location_provider.dart';
import 'package:provider/provider.dart';

class CameraView extends StatefulWidget {
  final String imagePath = "";
  final double markerLatitude;
  final double markerLongitude;
  final double radius;

  const CameraView({
    super.key,
    required this.markerLatitude,
    required this.markerLongitude,
    required this.radius,
  });

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startLocationTracking();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        print('No cameras available');
        return;
      }

      final firstCamera = cameras.first;
      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.high,
      );

      _initializeControllerFuture = _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _startLocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled');
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return;
    }

    // Start location updates
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Update every 5 meters
      ),
    ).listen(
      (Position position) {
        if (mounted) {
          setState(() {
            _currentPosition = position;
          });
        }
      },
      onError: (e) {
        print('Error getting location updates: $e');
      },
    );
  }

  double calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Widget _buildImageOverlay(BuildContext context) {
    int index = context.watch<LocationProvider>().index;
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, compassSnapshot) {
        if (!compassSnapshot.hasData || _currentPosition == null) {
          return Container();
        }

        final heading = compassSnapshot.data!.heading ?? 0;

        // Calculate distance and bearing
        final distance = calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          widget.markerLatitude,
          widget.markerLongitude,
        );

        // Calculate the bearing to the marker from the user's position
        final bearing = Geolocator.bearingBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          widget.markerLatitude,
          widget.markerLongitude,
        );

        // Relative angle to the marker
        final relativeAngle = (bearing - heading) % 360;
        final adjustedAngle = relativeAngle < 0 ? relativeAngle + 360 : relativeAngle;

        // Calculate image horizontal alignment based on angle
        const divFactor = 30;
        final alignmentX = adjustedAngle >= 180
            ? (adjustedAngle - 360) / divFactor // Left
            : adjustedAngle / divFactor;       // Right

        // Only show image if within the specified radius
        if (distance <= widget.radius) {
          return Align(
            alignment: Alignment(alignmentX, 0), // Adjust horizontal alignment
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImagesPage(index: index)));
              },
              child: Lottie.asset(
              'assets/found_box.json',
              width: 100,
              height:  100,
              fit: BoxFit.cover
            ),
            ),
          );
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _initializeControllerFuture == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      if (_cameraController != null)
                        CameraPreview(_cameraController!),
                      _buildImageOverlay(context),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }
}
