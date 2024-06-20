import 'package:flutter/cupertino.dart';

class ProfileOverviewProvider with ChangeNotifier {
  bool _isSelected = true;

  bool get isSelected => _isSelected;

  set isSelected(bool newValue) {
    _isSelected = newValue;
    notifyListeners(); // Notify listeners about the change
  }

  void toggleSelection() {
    _isSelected = !_isSelected;
    notifyListeners(); // Notify listeners about the change
  }
}
