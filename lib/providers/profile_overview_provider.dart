import 'package:flutter/cupertino.dart';

class ProfileOverviewProvider with ChangeNotifier {
  bool _isSelected = true;

  bool get isSelected => _isSelected;

  void toggleSelection() {
    _isSelected = !_isSelected;
    notifyListeners(); // Notify listeners about the change
  }
}
