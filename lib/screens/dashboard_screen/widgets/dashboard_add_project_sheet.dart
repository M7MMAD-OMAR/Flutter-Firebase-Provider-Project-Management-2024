import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/chat_screen/widgets/badged_title.dart';
import 'package:project_management_muhmad_omar/widgets/Buttons/rect_primary_button.dart';
import 'package:project_management_muhmad_omar/widgets/Forms/form_input_unlabelled.dart';
import 'package:project_management_muhmad_omar/widgets/add_sub_icon.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheet_holder.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';

import '../../../screens/dashboard_screen/widgets/dashboard_design_meeting_sheet.dart';
import '../../../screens/dashboard_screen/widgets/in_bottomsheet_subtitle.dart';

class DashboardAddProjectSheet extends StatelessWidget {
  const DashboardAddProjectSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsButtonTrigger = ValueNotifier(0);
    final projectNameController = new TextEditingController();

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
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight,
                              colors: [
                                HexColor.fromHex("FECE91"),
                                HexColor.fromHex("FAEDB9"),
                                HexColor.fromHex("2572FE")
                              ]))),
                  AppSpaces.horizontalSpace20,
                  Expanded(
                    child: UnlabelledFormInput(
                      placeholder: "Project Name ....",
                      autofocus: true,
                      keyboardType: "text",
                      controller: projectNameController,
                      obscureText: false,
                    ),
                  ),
                ],
              ),
              AppSpaces.verticalSpace20,
              const InBottomSheetSubtitle(title: "SELECT LAYOUT"),
              AppSpaces.verticalSpace10,
              Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HexColor.fromHex("181A1F")),
                  child: Row(children: [
                    Expanded(
                      flex: 1,
                      child: RectPrimaryButtonWithIcon(
                          buttonText: "List",
                          icon: Icons.checklist,
                          itemIndex: 0,
                          notifier: settingsButtonTrigger),
                    ),
                    Expanded(
                      flex: 1,
                      child: RectPrimaryButtonWithIcon(
                          buttonText: "Board",
                          icon: Icons.checklist,
                          itemIndex: 1,
                          notifier: settingsButtonTrigger),
                    )
                  ])),
              AppSpaces.verticalSpace20,
              Row(children: [
                const BadgedTitle(
                  title: "Design",
                  color: 'FCA3FF',
                  number: '6',
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.white),
                  onPressed: () {},
                )
              ]),
              AppSpaces.verticalSpace10,
              Transform.scale(
                  scale: 0.8,
                  alignment: Alignment.centerLeft,
                  child: buildStackedImages(numberOfMembers: "2")),
              AppSpaces.verticalSpace20,
              const InBottomSheetSubtitle(title: "PRIVACY"),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    Text("Public to Design Team  ",
                        style: GoogleFonts.lato(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                    const Icon(Icons.expand_more, color: Colors.white),
                  ],
                ),
                AddSubIcon(
                  scale: 0.8,
                  color: AppColors.primaryAccentColor,
                  callback: () => _addMeeting(context),
                ),
              ]),
            ]))
      ]),
    );
  }

  void _addMeeting(BuildContext context) {
    showAppBottomSheet(
      context,
      const DashboardDesignMeetingSheet(),
      isScrollControlled: true,
      popAndShow: true,
    );
  }
}
