import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/widgets/labelled_option.dart';
import 'package:project_management_muhmad_omar/screens/projects_screen/create_project_screen.dart';
import 'package:project_management_muhmad_omar/screens/projects_screen/select_members_screen.dart';
import 'package:project_management_muhmad_omar/screens/task_screen/task_due_date_screen.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheet_holder.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';

import 'create_task.dart';

class DashboardAddBottomSheet extends StatelessWidget {
  const DashboardAddBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppSpaces.verticalSpace10,
      const BottomSheetHolder(),
      AppSpaces.verticalSpace10,
      LabelledOption(
        label: 'Create Task',
        icon: Icons.add_to_queue,
        callback: _createTask,
      ),
      LabelledOption(
          label: 'Create Project',
          icon: Icons.device_hub,
          callback: () {
            Get.to(() => const CreateProjectScreen());
          }),
      LabelledOption(
          label: 'Create team',
          icon: Icons.people,
          callback: () {
            Get.to(() => SelectMembersScreen());
          }),
      LabelledOption(
          label: 'Create Event',
          icon: Icons.fiber_smart_record,
          callback: () {
            Get.to(() => TaskDueDateScreen());
          }),
    ]);
  }

  void _createTask() {
    showAppBottomSheet(
      CreateTaskBottomSheet(),
      isScrollControlled: true,
      popAndShow: true,
    );
  }
}
