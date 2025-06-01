
// background_location_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BackgroundLocationService {
  static const double PROXIMITY_RADIUS = 10.0; // meters
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'nearby_markers',
    'Nearby Markers',
    description: 'Notifications for nearby AR markers',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Initialize Workmanager
    await Workmanager().initialize(callbackDispatcher);

    // Request notification permissions
    await requestNotificationPermissions();

    // Initialize local notifications
    await initializeLocalNotifications();

    // Start periodic background task
    await Workmanager().registerPeriodicTask(
      'locationCheck',
      'checkNearbyMarkers',
      frequency: const Duration(minutes: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  static Future<void> requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> initializeLocalNotifications() async {
    await _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}

// This function must be top-level (outside any class)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Initialize Firebase
      await Firebase.initializeApp();

      // Get current location
      Position position = await Geolocator.getCurrentPosition();

      // Get nearby markers from Firestore
      QuerySnapshot markers =
          await FirebaseFirestore.instance.collection('markers').get();

      for (var doc in markers.docs) {
        Map<String, dynamic> markerData = doc.data() as Map<String, dynamic>;

        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          markerData['position']['latitude'],
          markerData['position']['longitude'],
        );

        if (distance <= BackgroundLocationService.PROXIMITY_RADIUS) {
          // Show notification for nearby marker
          await FlutterLocalNotificationsPlugin().show(
            doc.id.hashCode,
            'Nearby AR Marker',
            'You are near "${markerData['name']}"',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'nearby_markers',
                'Nearby Markers',
                channelDescription: 'Notifications for nearby AR markers',
                importance: Importance.high,
                priority: Priority.high,
              ),
            ),
          );
        }
      }

      return true;
    } catch (e) {
      print('Background task failed: $e');
      return false;
    }
  });
}
