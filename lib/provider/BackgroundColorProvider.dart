import 'package:flutter/material.dart';

class BackgroundColorProvider with ChangeNotifier {
  Color _backgroundColor = Color(0xFFEFEFEF); // Default background color

  Color get backgroundColor => _backgroundColor;

  void updateBackgroundColor(Color newColor) {
    _backgroundColor = newColor;
    notifyListeners(); // Notify listeners to rebuild UI
  }
}
