import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/task_category_provider.dart';
import 'package:project_management_muhmad_omar/controllers/project_provider.dart';
import 'package:project_management_muhmad_omar/controllers/team_provider.dart';
import 'package:project_management_muhmad_omar/controllers/user_task_provider.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/dashboard_settings_sheet_widget.dart';
import 'package:provider/provider.dart';

import '../../../widgets/Dashboard/overview_task_container_widget.dart';
import '../../../widgets/Shapes/app_settings_icon_widget.dart';

class DashboardOverviewScreen extends StatefulWidget {
  const DashboardOverviewScreen({super.key});
  static String id = "/DashboardOverviewScreen";

  @override
  State<DashboardOverviewScreen> createState() =>
      _DashboardOverviewScreenState();
}

class _DashboardOverviewScreenState extends State<DashboardOverviewScreen> {
  final ValueNotifier<bool> _totalTaskTrigger = ValueNotifier(true);

  final ValueNotifier<bool> _totalTaskToDoTrigger = ValueNotifier(true);

  final ValueNotifier<bool> _totalCompletedTrigger = ValueNotifier(true);
  final ValueNotifier<bool> _totalNotDoneTrigger = ValueNotifier(true);

  final ValueNotifier<bool> _totalCategoriesTrigger = ValueNotifier(true);

  final ValueNotifier<bool> _totalTeamsTrigger = ValueNotifier(true);

  final ValueNotifier<bool> _totalProjectsTrigger = ValueNotifier(true);

  final ValueNotifier<bool> _workingOnTrigger = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    TaskCategoryProvider taskCategoryController =
        Provider.of<TaskCategoryProvider>(context);
    UserTaskProvider userTaskController =
        Provider.of<UserTaskProvider>(context);
    ProjectProvider projectController = Provider.of<ProjectProvider>(context);
    TeamProvider teamController = Provider.of<TeamProvider>(context);
    int catNumber = 0;
    int totalTaskNumber = 0;
    int toDoTaskNumber = 0;
    int notDoneTaskNumber = 0;
    int completedtaskNumber = 0;
    int projectNumber = 0;
    int teamsNumber = 0;
    int workingOnNumber = 0;
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 30,
                  alignment: Alignment.centerRight,
                  child: AppSettingsIcon(
                    callback: () {
                      showAppBottomSheet(
                        DashboardSettingsBottomSheet(
                          totalTaskToDoTrigger: _totalTaskToDoTrigger,
                          totalCategoriesTrigger: _totalCategoriesTrigger,
                          totalProjectsTrigger: _totalProjectsTrigger,
                          totalTeamsTrigger: _totalTeamsTrigger,
                          totalTaskNotifier: _totalTaskTrigger,
                          totalworkingOnNotifier: _workingOnTrigger,
                          totalCompletedNotifier: _totalCompletedTrigger,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            triggerShow(
                valueListenable: _totalTaskTrigger,
                number: totalTaskNumber,
                stream: userTaskController
                    .getUserTasksStream(
                      userId: AuthProvider.firebaseAuth.currentUser!.uid,
                    )
                    .asBroadcastStream(),
                name: 'كل المهام',
                colorHex: "EFA17D",
                imageUrl: "assets/project.png"),
            triggerShow(
                valueListenable: _totalTaskToDoTrigger,
                number: toDoTaskNumber,
                stream: userTaskController
                    .getUserTasksStartInADayForAStatusStream(
                        date: DateTime.now(),
                        userId: AuthProvider.firebaseAuth.currentUser!.uid,
                        status: statusNotStarted)
                    .asBroadcastStream(),
                name: 'للقيام به اليوم',
                colorHex: "EFA17D",
                imageUrl: "assets/orange_pencil.png"),
            triggerShow(
                valueListenable: _workingOnTrigger,
                number: workingOnNumber,
                stream: userTaskController
                    .getUserTasksForAStatusStream(
                        userId: AuthProvider.firebaseAuth.currentUser!.uid,
                        status: statusDoing)
                    .asBroadcastStream(),
                name: 'تعمل على',
                colorHex: "EFA17D",
                imageUrl: "assets/working_on.png"),
            triggerShow(
                valueListenable: _totalCompletedTrigger,
                number: completedtaskNumber,
                stream: userTaskController
                    .getUserTasksForAStatusStream(
                        userId: AuthProvider.firebaseAuth.currentUser!.uid,
                        status: statusDone)
                    .asBroadcastStream(),
                name: 'المهام المكتملة',
                colorHex: "7FBC69",
                imageUrl: "assets/task_done.png"),
            triggerShow(
                valueListenable: _totalNotDoneTrigger,
                number: notDoneTaskNumber,
                stream: userTaskController
                    .getUserTasksForAStatusStream(
                        userId: AuthProvider.firebaseAuth.currentUser!.uid,
                        status: statusNotDone)
                    .asBroadcastStream(),
                name: 'المهام غير المنجزة',
                colorHex: "FF0000", 
                imageUrl: "assets/task_done.png"),
            triggerShow(
                valueListenable: _totalCategoriesTrigger,
                number: catNumber,
                stream: taskCategoryController
                    .getUserCategoriesStream(
                        userId: AuthProvider.firebaseAuth.currentUser!.uid)
                    .asBroadcastStream(),
                name: 'عدد الفئات الكلي',
                colorHex: "EDA7FA",
                imageUrl: "assets/category.png"),
            triggerShow(
                valueListenable: _totalProjectsTrigger,
                number: projectNumber,
                stream: projectController
                    .getProjectsOfUserStream(
                        userId: AuthProvider.firebaseAuth.currentUser!.uid)
                    .asBroadcastStream(),
                name: 'مجموع المشاريع',
                colorHex: "EDA7FA",
                imageUrl: "assets/project.png"),
            triggerShow(
                valueListenable: _totalTeamsTrigger,
                number: teamsNumber,
                stream: teamController
                    .getTeamsOfUserStream(
                        userId: AuthProvider.firebaseAuth.currentUser!.uid)
                    .asBroadcastStream(),
                name: 'مجموع الفرق',
                colorHex: "EDA7FA",
                imageUrl: "assets/team.png"),
          ],
        ),
      ],
    );
  }

  ValueListenableBuilder<bool> triggerShow({
    required ValueListenable<bool> valueListenable,
    required int number,
    required Stream stream,
    required String name,
    required String colorHex,
    required String imageUrl,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueListenable,
      builder: (BuildContext context, bool value, Widget? child) {
        return Visibility(
          visible: value,
          child: StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  number = snapshot.data!.size;
                }
                return OverviewTaskContainer(
                    cardTitle: name,
                    numberOfItems: number.toString(),
                    imageUrl: imageUrl,
                    backgroundColor: HexColor.fromHex(colorHex));
              }),
        );
      },
    );
  }
}
