import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/controllers/projectController.dart';
import 'package:project_management_muhmad_omar/models/team/project_model.dart';
import 'package:project_management_muhmad_omar/services/auth_service.dart';

class ProjectScreenController extends GetxController {
  RxInt selectedTab = 0.obs;

  Stream<QuerySnapshot<ProjectModel?>> getProjectsStream() {
    if (selectedTab.value == 0) {
      return ProjectController().getProjectsOfMemberWhereUserIsStream(
          userId: AuthProvider.instance.firebaseAuth.currentUser!.uid);
    } else if (selectedTab.value == 1) {
      return ProjectController().getProjectsOfMemberWhereUserIsStream(
          userId: AuthProvider.instance.firebaseAuth.currentUser!.uid);
    }

    return ProjectController().getProjectsOfUserStream(
        userId: AuthProvider.instance.firebaseAuth.currentUser!.uid);
// Return an empty stream or another default stream if needed
  }

  void selectTab(int tab) {
    selectedTab.value = tab;
    update();
  }
}
