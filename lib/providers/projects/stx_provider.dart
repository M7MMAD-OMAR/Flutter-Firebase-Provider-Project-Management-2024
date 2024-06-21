import 'package:flutter/cupertino.dart';

class STXProvider extends ChangeNotifier {
  bool _isTaked = false;

  bool get isTaked => _isTaked;

  void updateIsTaked(bool s) {
    _isTaked = s;
    notifyListeners();
  }
}
