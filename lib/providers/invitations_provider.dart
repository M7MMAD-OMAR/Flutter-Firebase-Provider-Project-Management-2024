import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../providers/projects/project_provider.dart';
import '../models/team/project_model.dart';
import 'auth_provider.dart';

class InvitationProvider with ChangeNotifier {
  int _selectedTab = 0;

  int get selectedTab => _selectedTab;

  Stream<QuerySnapshot<ProjectModel?>> getInvitationStream() {
    final userId = AuthProvider.firebaseAuth.currentUser!.uid;
    if (_selectedTab == 0) {
      return ProjectProvider()
          .getProjectsOfMemberWhereUserIsStream(userId: userId);
    } else if (_selectedTab == 1) {
      return ProjectProvider()
          .getProjectsOfMemberWhereUserIsStream(userId: userId);
    }

    return ProjectProvider().getProjectsOfUserStream(userId: userId);
    // Return an empty stream or another default stream if needed
  }

  void selectTab(int tab) {
    _selectedTab = tab;
    notifyListeners();
  }
}
