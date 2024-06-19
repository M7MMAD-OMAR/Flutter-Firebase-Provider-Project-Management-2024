import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controllers/projectController.dart';
import '../models/team/project_model.dart';
import 'auth_provider.dart';

class InvitationProvider with ChangeNotifier {
  int _selectedTab = 0;

  int get selectedTab => _selectedTab;

  Stream<QuerySnapshot<ProjectModel?>> getInvitationStream() {
    final userId = AuthProvider.instance.firebaseAuth.currentUser!.uid;
    if (_selectedTab == 0) {
      return ProjectController()
          .getProjectsOfMemberWhereUserIsStream(userId: userId);
    } else if (_selectedTab == 1) {
      return ProjectController()
          .getProjectsOfMemberWhereUserIsStream(userId: userId);
    }

    return ProjectController().getProjectsOfUserStream(userId: userId);
    // Return an empty stream or another default stream if needed
  }

  void selectTab(int tab) {
    _selectedTab = tab;
    notifyListeners();
  }
}
