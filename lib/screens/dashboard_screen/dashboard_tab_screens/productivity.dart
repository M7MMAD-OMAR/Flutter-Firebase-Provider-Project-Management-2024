import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/widgets/daily_goal_card.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/widgets/productivity_chart.dart';

class DashboardProductivity extends StatelessWidget {
  const DashboardProductivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        DailyGoalCard(),
        AppSpaces.verticalSpace20,
        const ProductivityChart()
      ],
    );
  }
}
