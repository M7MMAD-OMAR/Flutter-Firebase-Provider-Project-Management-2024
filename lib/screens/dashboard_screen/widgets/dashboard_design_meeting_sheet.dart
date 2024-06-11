import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/widgets/sheet_goto_calendar.dart';
import 'package:project_management_muhmad_omar/widgets/Forms/form_input_unlabelled.dart';
import 'package:project_management_muhmad_omar/widgets/add_sub_icon.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheet_holder.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';

import '../../../screens/dashboard_screen/widgets/dashboard_meeting_details.dart';
import '../../../screens/dashboard_screen/widgets/filled_selectable_container.dart';
import '../../../screens/dashboard_screen/widgets/in_bottomsheet_subtitle.dart';

class DashboardDesignMeetingSheet extends StatelessWidget {
  const DashboardDesignMeetingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final meetingNameController = TextEditingController();

    return SingleChildScrollView(
      child: Column(children: [
        AppSpaces.verticalSpace10,
        const BottomSheetHolder(),
        AppSpaces.verticalSpace10,
        Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight,
                              colors: [
                                HexColor.fromHex("8DCB73"),
                                HexColor.fromHex("8DCB73"),
                              ]))),
                  AppSpaces.horizontalSpace20,
                  Expanded(
                    child: UnlabelledFormInput(
                      placeholder: "Design Meeting",
                      keyboardType: "text",
                      autofocus: true,
                      controller: meetingNameController,
                      obscureText: false,
                    ),
                  ),
                ],
              ),
              AppSpaces.verticalSpace20,
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SheetGoToCalendarWidget(
                  cardBackgroundColor: AppColors.primaryAccentColor,
                  textAccentColor: HexColor.fromHex("90E7E7"),
                  value: 'Today 3PM',
                  label: 'Due Date',
                ),
                SheetGoToCalendarWidget(
                  cardBackgroundColor: HexColor.fromHex("C25DFF"),
                  textAccentColor: HexColor.fromHex("E699E9"),
                  value: 'Today 4:30PM',
                  label: 'End',
                )
              ]),
              AppSpaces.verticalSpace20,
              const InBottomSheetSubtitle(title: "INVITES"),
              AppSpaces.verticalSpace10,
              const FilledSelectableContainer(),
              AppSpaces.verticalSpace20,
              Align(
                alignment: Alignment.centerRight,
                child: AddSubIcon(
                  scale: 0.8,
                  color: AppColors.primaryAccentColor,
                  callback: () => _addMeetingDetails(context),
                ),
              ),
            ]))
      ]),
    );
  }

  void _addMeetingDetails(BuildContext context) {
    showAppBottomSheet(
      context,
      const DashboardMeetingDetails(),
      isScrollControlled: true,
      popAndShow: true,
    );
  }
}
