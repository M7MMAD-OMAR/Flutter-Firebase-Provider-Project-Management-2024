import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';

class DashboardMeetingDetailsProvider extends ChangeNotifier {
  final List<UserModel> _users = [];

  List<UserModel> get users => _users;

  void addUser(UserModel user) {
    bool found = _users.any((element) => element.id == user.id);

    if (found) {
      CustomSnackBar.showError("This User Already added");
    } else {
      _users.add(user);
      notifyListeners(); // Notify listeners of the change
    }
  }

  void removeUsers() {
    _users.clear();
    notifyListeners(); // Notify listeners of the change
  }

  @override
  void dispose() {
    removeUsers();
    super.dispose();
  }
}
