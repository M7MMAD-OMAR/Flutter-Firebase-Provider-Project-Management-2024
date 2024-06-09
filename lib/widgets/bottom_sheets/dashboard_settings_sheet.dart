import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/widgets/toggle_option.dart';
import 'package:project_management_muhmad_omar/widgets/Buttons/primary_buttons.dart';
import 'package:project_management_muhmad_omar/widgets/Buttons/text_button.dart';

import '../bottom_sheets/bottom_sheet_holder.dart';

class DashboardSettingsBottomSheet extends StatelessWidget {
  final ValueNotifier<bool> totalTaskNotifier;
  final ValueNotifier<bool> totalDueNotifier;
  final ValueNotifier<bool> totalCompletedNotifier;
  final ValueNotifier<bool> workingOnNotifier;

  const DashboardSettingsBottomSheet(
      {super.key,
      required this.totalTaskNotifier,
      required this.totalDueNotifier,
      required this.totalCompletedNotifier,
      required this.workingOnNotifier});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppSpaces.verticalSpace10,
      const BottomSheetHolder(),
      AppSpaces.verticalSpace20,
      ToggleLabelOption(
          label: '    Total Task',
          notifierValue: totalTaskNotifier,
          icon: Icons.check_circle_outline),
      ToggleLabelOption(
          label: '    Task Due Soon',
          notifierValue: totalDueNotifier,
          icon: Icons.batch_prediction),
      ToggleLabelOption(
          label: '    Completed',
          notifierValue: totalCompletedNotifier,
          icon: Icons.check_circle),
      ToggleLabelOption(
          label: '    Working On',
          notifierValue: workingOnNotifier,
          icon: Icons.flag),
      const Spacer(),
      const Padding(
        padding: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          AppTextButton(
            buttonText: 'Clear All',
            buttonSize: 16,
          ),
          AppPrimaryButton(
            buttonHeight: 60,
            buttonWidth: 160,
            buttonText: "Save Changes",
          )
        ]),
      )
    ]);
  }
}
