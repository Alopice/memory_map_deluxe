import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  int _value = 0;
  int get getValue => _value;
  bool get isDarkMode => _isDarkMode;
  Box box = Hive.box("ProviderValues");
  
  ThemeProvider(){
    if(box.get("/themeVal") != null){
      _value = box.get("/themeVal") as int;
    }
    
  }

  void toggleTheme(int choice) {
    _value = choice;
    if (choice == 0) {
      _isDarkMode = false;
    } else {
      _isDarkMode = true;
    }
    box.put("/themeVal", _value);
    notifyListeners();
  }
}