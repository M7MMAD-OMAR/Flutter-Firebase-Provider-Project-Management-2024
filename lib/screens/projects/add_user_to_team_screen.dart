import 'package:get/get.dart';
import 'package:project_management_muhmad_omar/models/User/User_model.dart';
import 'package:project_management_muhmad_omar/widgets/Snackbar/custom_snackber_widget.dart';

class DashboardMeetingDetailsScreenController extends GetxController {
  RxList<UserModel> users = <UserModel>[].obs;

  void addUser(UserModel user) {
    bool found = false;
    for (var element in users) {
      if (user.id == element.id) {
        found = true;
        break;
      }
    }

    if (found) {
      CustomSnackBar.showError("This User Already added");
    } else {
      users.add(user);
      update();
    }

    update();
  }

  void removeUsers() {
    users.clear();
    update();
  }

  @override
  void onClose() {
    removeUsers();
    super.onClose();
  }
}
// the Developer karem saad 