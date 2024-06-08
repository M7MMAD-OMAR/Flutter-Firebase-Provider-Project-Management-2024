import 'package:get/get.dart';
import '../../models/User/User_model.dart';
import '../../widgets/snackbar/my_snackber.dart';

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
      MySnackBar.showError("This User Already added");
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
