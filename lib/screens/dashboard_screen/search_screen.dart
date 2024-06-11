import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/widgets/Buttons/primary_tab_buttons.dart';
import 'package:project_management_muhmad_omar/widgets/Forms/search_box.dart';
import 'package:project_management_muhmad_omar/widgets/Search/task_card.dart';
import 'package:project_management_muhmad_omar/widgets/Shapes/app_settings_icon.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final settingsButtonTrigger = ValueNotifier(0);
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 60,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: SearchBox(
                        placeholder: 'Search Dashboard',
                        controller: searchController),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      height: 60,
                      child: Text(
                          textAlign: TextAlign.right,
                          "إلغاء",
                          style: GoogleFonts.lato(
                              color: HexColor.fromHex("616575"),
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    )),
              ],
            ),
            AppSpaces.verticalSpace10,
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PrimaryTabButton(
                      buttonText: "المهام",
                      itemIndex: 0,
                      notifier: settingsButtonTrigger),
                  PrimaryTabButton(
                      buttonText: "الإشارات",
                      itemIndex: 1,
                      notifier: settingsButtonTrigger),
                  PrimaryTabButton(
                      buttonText: "الملفات",
                      itemIndex: 2,
                      notifier: settingsButtonTrigger)
                ],
              ),
              Container(
                  alignment: Alignment.centerRight, child: AppSettingsIcon())
            ]),
            AppSpaces.verticalSpace20,
            Expanded(
              child: ListView(children: [
                SearchTaskCard(
                    activated: false,
                    header: "لوحة المعلومات",
                    subHeader: "in UI Design Kit",
                    date: "Dec 2"),
                SearchTaskCard(
                    activated: true,
                    header: "Unity Gaming",
                    subHeader: "Coded Template",
                    date: "Nov 4"),
                SearchTaskCard(
                    activated: false,
                    header: "Gitlab Landing Page",
                    subHeader: "in UI Design Kit",
                    date: "Nov 29"),
                SearchTaskCard(
                    activated: true,
                    header: "Portfolio Design",
                    subHeader: "Tesla Inc.",
                    date: "Nov 26"),
                SearchTaskCard(
                    activated: true,
                    header: "Stuart'\s Workplace",
                    subHeader: "Coded Template",
                    date: "Aug 1"),
              ]),
            )
          ]),
        ));
  }
}
