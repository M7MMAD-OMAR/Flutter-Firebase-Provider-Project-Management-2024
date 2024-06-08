import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_management_muhmad_omar/Screens/Projects/create_project.dart';
import 'package:project_management_muhmad_omar/Screens/Projects/set_members.dart';
import 'package:project_management_muhmad_omar/Screens/Task/task_due_date.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/widgets/BottomSheets/bottom_sheet_holder.dart';
import 'package:project_management_muhmad_omar/widgets/Onboarding/labelled_option.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets.dart';

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
            Get.to(() => TaskDueDate());
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
