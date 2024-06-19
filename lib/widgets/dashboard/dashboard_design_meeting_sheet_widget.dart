import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/sheet_goto_calendar_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheet_holder_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';

import '../add_sub_icon_widget.dart';
import '../forms/form_input_unlabelled_widget.dart';
import 'dashboard_meeting_details_widget.dart';
import 'filled_selectable_container_widget.dart';
import 'in_bottomsheet_subtitle_widget.dart';

class DashboardDesignMeetingSheet extends StatelessWidget {
  const DashboardDesignMeetingSheet({Key? key}) : super(key: key);

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
                        ],
                      ),
                    ),
                  ),
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
                  icon: const Icon(Icons.add, color: Colors.white),
                  scale: 0.8,
                  color: AppColors.primaryAccentColor,
                  callback: _addMeetingDetails,
                ),
              ),
            ]))
      ]),
    );
  }

  void _addMeetingDetails() {
    showAppBottomSheet(
      const DashboardMeetingDetailsWidget(),
      isScrollControlled: true,
      popAndShow: true,
    );
  }
}
