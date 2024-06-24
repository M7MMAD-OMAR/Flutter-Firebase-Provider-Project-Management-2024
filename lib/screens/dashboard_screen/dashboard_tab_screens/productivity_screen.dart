import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/providers/user_task_provider.dart';
import 'package:provider/provider.dart';

import '../../../widgets/Dashboard/daily_goal_card_widget.dart';
import '../../../widgets/Dashboard/productivity_chart_widget.dart';

class DashboardProductivityScreen extends StatefulWidget {
  const DashboardProductivityScreen({super.key});
  static String id = "/DashboardProductivityScreen";

  @override
  State<DashboardProductivityScreen> createState() =>
      _DashboardProductivityScreenState();
}

class _DashboardProductivityScreenState
    extends State<DashboardProductivityScreen> {
  @override
  Widget build(BuildContext context) {
    List<double> precentage = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    DateTime todayDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    UserTaskProvider userTaskController =
        Provider.of<UserTaskProvider>(context);

    return Column(
      children: [
        // AppSpaces.verticalSpace10,
        DailyGoalCard(
          message: 'مهمة',
          allStream: userTaskController.getUserTasksStartInADayForAStatusStream(
              date: DateTime.now(),
              userId: AuthProvider.firebaseAuth.currentUser!.uid,
              status: statusDone),
          forStatusStram: userTaskController.getUserTasksBetweenTowTimesStream(
              firstDate: todayDate,
              secondDate: todayDate.add(
                const Duration(days: 1),
              ),
              userId: AuthProvider.firebaseAuth.currentUser!.uid),
        ),
        AppSpaces.verticalSpace20,
        StreamBuilder(
            stream: userTaskController
                .getPercentagesForLastSevenDaysforaUserforAStatusStream(
                    userId: AuthProvider.firebaseAuth.currentUser!.uid,
                    startdate: DateTime.now(),
                    status: statusDone),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //
                precentage = snapshot.data!;
                return ProductivityChart(
                  percentages: precentage,
                  message: 'مهمة',
                );
              }
              return ProductivityChart(
                percentages: precentage,
                message: 'مهمة',
              );
            }),
      ],
    );
  }
}
