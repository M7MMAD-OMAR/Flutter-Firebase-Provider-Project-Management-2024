import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_management_muhmad_omar/Screens/Projects/addTeamToCreateProjectScre.dart';
import 'package:project_management_muhmad_omar/Screens/Projects/createProject.dart';
import 'package:project_management_muhmad_omar/constants/app_constans.dart';
import 'package:project_management_muhmad_omar/controllers/manger_controller.dart';
import 'package:project_management_muhmad_omar/models/task/UserTaskCategory_model.dart';
import 'package:project_management_muhmad_omar/models/team/Manger_model.dart';
import 'package:project_management_muhmad_omar/services/auth_service.dart';
import 'package:project_management_muhmad_omar/widgets/Snackbar/custom_snackber.dart';

import '../../BottomSheets/bottom_sheets.dart';
import '../../Screens/Projects/set_members.dart';
import '../../Screens/Task/task_due_date.dart';
import '../../Values/values.dart';
import '../BottomSheets/bottom_sheet_holder.dart';
import '../Onboarding/labelled_option.dart';
import 'create_category.dart';

import 'dashboard_meeting_details.dart';
import 'new_create_task.dart';

class DashboardAddBottomSheet extends StatelessWidget {
  const DashboardAddBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        AppSpaces.verticalSpace10,
        const BottomSheetHolder(),
        AppSpaces.verticalSpace10,
        //TODO add this in the category and in the project
        // LabelledOption(
        //   label: 'Create Task',
        //   icon: Icons.add_to_queue,
        //   callback: _createTask2,
        // ),

        LabelledOption(
            label: AppConstants.create_project_key.tr,
            icon: Icons.device_hub,
            callback: () async {
              await _createProject();
            }),
        LabelledOption(
            label: AppConstants.create_team_key.tr,
            icon: Icons.people,
            callback: () {
              Get.to(() => const DashboardMeetingDetails());
            }),
        LabelledOption(
            label: AppConstants.create_category_key.tr,
            icon: Icons.category,
            callback: () {
              showAppBottomSheet(
                CreateUserCategory(),
                isScrollControlled: true,
                popAndShow: true,
              );
            }),
      ]),
    );
  }

  // void _createTask() {
  //   showAppBottomSheet(
  //     CreateTaskBottomSheet(),
  //     isScrollControlled: true,
  //     popAndShow: true,
  //   );
  // }

//   void _createTask2() {
//     showAppBottomSheet(
//       NewCreateTaskBottomSheet(),
//       isScrollControlled: true,
//       popAndShow: true,
//     );
//   }
// }

  Future<void> _createProject() async {
    try {
      ManagerModel? managerModel = await ManagerController()
          .getMangerWhereUserIs(
              userId: AuthService.instance.firebaseAuth.currentUser!.uid);
      if (managerModel == null) {
        print("object");
      }
      showAppBottomSheet(
        CreateProject(
          managerModel: managerModel,
          //   userTaskCategoryModel: widget.categoryModel,
          isEditMode: false,
        ),
        isScrollControlled: true,
        popAndShow: true,
      );
    } on Exception catch (e) {
      CustomSnackBar.showError("حدث خطأ غير متوقع");
    }
  }
}
