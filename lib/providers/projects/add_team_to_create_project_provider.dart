import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';

class AddTeamToCreatProjectProvider extends ChangeNotifier {
  final List<TeamModel> _teams = [];

  List<TeamModel> get teams => _teams;

  void addUser(TeamModel user) {
    // Check if the user is already in the list
    if (!_teams.contains(user)) {
      _teams.add(user);
      notifyListeners(); // Notify listeners of the change
    }
  }

  void removeUsers() {
    _teams.clear();
    notifyListeners(); // Notify listeners of the change
  }

  @override
  void dispose() {
    removeUsers();
    super.dispose();
  }
}
