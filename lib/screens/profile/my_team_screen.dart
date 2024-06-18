import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/widgets/container_label_widget.dart';

import 'team_details_screen.dart';

class MyTeamScreen extends StatelessWidget {
  final String teamTitle;
  final String numberOfMembers;
  final String noImages;
  final TeamModel? teamModel;
  final ManagerModel? userAsManager;
  final List<UserModel> users;
  final VoidCallback? onTap;

  const MyTeamScreen(
      {super.key,
      required this.userAsManager,
      required this.onTap,
      required this.teamModel,
      required this.users,
      required this.teamTitle,
      required this.numberOfMembers,
      required this.noImages,
      required});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(teamTitle, style: AppTextStyles.header2.copyWith(fontSize: 35)),
        AppSpaces.verticalSpace10,
        ContainerLabel(label: "$numberOfMembersالأعضاء "),
        AppSpaces.verticalSpace10,
        InkWell(
          onTap: () {
            Get.to(() => TeamDetailsScreen(
                  userAsManager: userAsManager,
                  title: teamTitle,
                  team: teamModel,
                ));
          },
          child: Transform.scale(
              alignment: Alignment.centerLeft,
              scale: 0.7,
              child: buildStackedImages(
                  onTap: onTap,
                  users: users,
                  numberOfMembers: noImages,
                  addMore: true)),
        ),
      ],
    );
  }
}
