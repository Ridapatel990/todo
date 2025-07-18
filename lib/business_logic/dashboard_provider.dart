import 'package:flutter/material.dart';

class DashboardViewModel with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // Notify widgets to rebuild
  }
}
