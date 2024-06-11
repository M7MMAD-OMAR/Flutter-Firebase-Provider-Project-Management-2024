import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/widgets/labelled_option.dart';
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
        callback: () => _createTask(context),
      ),
      LabelledOption(
          label: 'Create Project',
          icon: Icons.device_hub,
          callback: () {
            Navigator.pushNamed(context, Routes.createProjectScreen);
          }),
      LabelledOption(
          label: 'Create team',
          icon: Icons.people,
          callback: () {
            Navigator.pushNamed(context, Routes.selectMembersScreen);
          }),
      LabelledOption(
          label: 'Create Event',
          icon: Icons.fiber_smart_record,
          callback: () {
            Navigator.pushNamed(context, Routes.taskDueDateScreen);
          }),
    ]);
  }

  void _createTask(BuildContext context) {
    showAppBottomSheet(
      context,
      CreateTaskBottomSheet(),
      isScrollControlled: true,
      popAndShow: true,
    );
  }
}
