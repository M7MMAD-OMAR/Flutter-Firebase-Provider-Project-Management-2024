import 'package:get/get.dart';
import 'package:project_management_muhmad_omar/models/team/Team_model.dart';

class AddTeamToCreatProjectScreen extends GetxController {
  RxList<TeamModel> teams = <TeamModel>[].obs;

  void addUser(TeamModel user) {
    bool found = false;
    // for (var element in teams) {
    //   if (user.id == element.id) {
    //
// the Developer karem saad (KaremSD) 
    //     found = true;
    //     break;
    //   }
    // }

    // if (found) {
    //   CustomSnackBar.showError("This User Already added");
    // } else {
    //

    //   teams.add(user);
    //   update();
    // }
    if (teams.isEmpty) {
      teams.add(user);
    } else {
      teams.first = user;
    }
    update();
    teams;
  }

  void removeUsers() {
    teams.clear();
    update();
  }

  @override
  void onClose() {
    removeUsers();
    super.onClose();
  }
}
// the Developer karem saad (KaremSD) 