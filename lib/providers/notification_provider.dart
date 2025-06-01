import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationProvider extends ChangeNotifier{
  int _value = 0;
  int get getValue => _value; 
  Box box = Hive.box("ProviderValues");

  NotificationProvider(){
    if(box.get("/notifVal") != null){
      _value = box.get("/notifVal") as int;
    }
  }

  void toggleNotification(int choice){
    _value = choice;
    box.put("/notifVal", _value);
    if(choice == 0){
      enableFCMNotifications();
    }
    else{
      disableFCMNotifications();
    }
    notifyListeners();
  }

  void disableFCMNotifications() async {
  try {
    await FirebaseMessaging.instance.deleteToken();
    print('FCM notifications disabled by deleting the token.');
  } catch (e) {
    print('Failed to delete FCM token: $e');
  }
}

void enableFCMNotifications() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    print('FCM notifications enabled. Token: $token');
  } catch (e) {
    print('Failed to regenerate FCM token: $e');
  }
}
}