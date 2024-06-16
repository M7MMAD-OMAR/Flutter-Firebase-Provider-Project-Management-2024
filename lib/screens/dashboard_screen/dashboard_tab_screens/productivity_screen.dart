import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/user_task_controller.dart';

import '../../../constants/app_constants.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/Dashboard/daily_goal_card_widget.dart';
import '../../../widgets/Dashboard/productivity_chart_widget.dart';

class DashboardProductivity extends StatefulWidget {
  const DashboardProductivity({Key? key}) : super(key: key);
  static String id = "/DashboardProductivityScreen";

  @override
  State<DashboardProductivity> createState() => _DashboardProductivityState();
}

class _DashboardProductivityState extends State<DashboardProductivity> {
  @override
  Widget build(BuildContext context) {
    List<double> precentage = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    DateTime todayDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    UserTaskController userTaskController = Get.put(UserTaskController());
    

    return Column(
      children: [
        // AppSpaces.verticalSpace10,
        DailyGoalCard(
          message: AppConstants.task_key.tr,
          allStream: userTaskController.getUserTasksStartInADayForAStatusStream(
              date: DateTime.now(),
              userId: AuthService.instance.firebaseAuth.currentUser!.uid,
              status: statusDone),
          forStatusStram: userTaskController.getUserTasksBetweenTowTimesStream(
              firstDate: todayDate,
              secondDate: todayDate.add(
                const Duration(days: 1),
              ),
              userId: AuthService.instance.firebaseAuth.currentUser!.uid),
        ),
        AppSpaces.verticalSpace20,
        StreamBuilder(
            stream: userTaskController
                .getPercentagesForLastSevenDaysforaUserforAStatusStream(
                    userId: AuthService.instance.firebaseAuth.currentUser!.uid,
                    startdate: DateTime.now(),
                    status: statusDone),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //
                precentage = snapshot.data!;
                return ProductivityChart(
                  percentages: precentage,
                  message: AppConstants.task_key.tr,
                );
              }
              return ProductivityChart(
                percentages: precentage,
                message: AppConstants.task_key.tr,
              );
            }),
      ],
    );
  }
}
