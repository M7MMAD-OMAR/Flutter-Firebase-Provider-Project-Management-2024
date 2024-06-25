import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/providers/manger_provider.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:project_management_muhmad_omar/screens/Projects/create_project_screen.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheet_holder_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';

import '../Onboarding/labelled_option_widget.dart';
import 'create_category_widget.dart';

class DashboardAddBottomSheet extends StatelessWidget {
  const DashboardAddBottomSheet({super.key});

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
            label: 'إنشاء مشروع',
            icon: Icons.device_hub,
            callback: () async {
              await _createProject();
            }),
        LabelledOption(
            label: 'إنشاء فريق',
            icon: Icons.people,
            callback: () {
              Navigator.pushNamed(
                  context, Routes.dashboardMeetingDetailsWidget);
            }),
        LabelledOption(
            label: 'إنشاء فئة',
            icon: Icons.category,
            callback: () {
              showAppBottomSheet(
                const CreateUserCategory(),
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
      ManagerModel? managerModel = await ManagerProvider().getMangerWhereUserIs(
          userId: AuthProvider.firebaseAuth.currentUser!.uid);
      if (managerModel == null) {}
      showAppBottomSheet(
        CreateProjectScreen(
          managerModel: managerModel,
          //   userTaskCategoryModel: widget.categoryModel,
          isEditMode: false,
        ),
        isScrollControlled: true,
        popAndShow: true,
      );
    } on Exception catch (e) {
      CustomSnackBar.showError("حدث خطأ ما , حاول لاحقا");
    }
  }
}
