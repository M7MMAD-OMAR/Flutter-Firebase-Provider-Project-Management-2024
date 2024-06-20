import 'package:flutter/cupertino.dart';

class TaskProvider extends ChangeNotifier {
  bool _isManager = false;

  bool get isManager => _isManager;

  void toggleManager() {
    _isManager = !_isManager;
    notifyListeners();
  }

  void setManager(bool value) {
    _isManager = value;
    notifyListeners();
  }
}
