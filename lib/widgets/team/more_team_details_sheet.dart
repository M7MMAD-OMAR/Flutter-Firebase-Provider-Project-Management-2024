import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheet_holder.dart';

import '../container_label.dart';
import '../forms/labelled_form_input_widget.dart';

class MoreTeamDetailsSheet extends StatelessWidget {
  const MoreTeamDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final workSpaceNameController = TextEditingController();
    final teamNameController = TextEditingController();
    return Column(children: [
      AppSpaces.verticalSpace10,
      const BottomSheetHolder(),
      AppSpaces.verticalSpace40,
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelledFormInputWidget(
              placeholder: "Blake Gordon",
              keyboardType: "text",
              value: "Blake Gordon",
              controller: workSpaceNameController,
              obscureText: false,
              label: "WorkSpace",
              autovalidateMode: null,
              readOnly: false,
            ),
            AppSpaces.verticalSpace20,
            LabelledFormInputWidget(
              placeholder: "Marketing",
              keyboardType: "text",
              controller: teamNameController,
              obscureText: true,
              label: "TEAM NAME",
              autovalidateMode: null,
              readOnly: false,
            ),
            AppSpaces.verticalSpace20,
            const ContainerLabel(label: "Members"),
            AppSpaces.verticalSpace10,
            Transform.scale(
                alignment: Alignment.centerLeft,
                scale: 0.7,
                child: buildStackedImages(numberOfMembers: "8", addMore: true)),
          ],
        ),
      ),
    ]);
  }
}
