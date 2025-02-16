// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:memory_map/pages/google_login_page.dart';
import 'package:memory_map/pages/home_page.dart';
import 'package:memory_map/pages/map_page.dart';
import 'package:memory_map/pages/settings_page.dart';
import 'package:memory_map/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:memory_map/providers/marker_provider.dart';
import 'package:memory_map/providers/notification_provider.dart';
import 'package:memory_map/providers/theme_provider.dart';
import 'package:memory_map/utils/page_viewer.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'utils/notification_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await BackgroundLocationService.initialize();
  await Hive.initFlutter();
  await Hive.openBox("ProviderValues");
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: 'https://jeucwwbmdhbdeywonknd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpldWN3d2JtZGhiZGV5d29ua25kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU1NzE1OTQsImV4cCI6MjA1MTE0NzU5NH0.1lTgDsBmkERvbPvlxk38jOEAEyfj6DXndh0yleqNDqg',
  );
  runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => MarkerProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner:  false,
      home: FirebaseAuth.instance.currentUser != null?PageViewer():GoogleLoginPage(),
      routes: {
        '/map': (context) => MapPage(),
        '/home': (context) => HomePage(),
        '/settings': (context) => SettingsPage(),
      },
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
    );
  }
}
