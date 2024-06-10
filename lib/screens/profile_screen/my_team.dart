import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/Constants/constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/projects_screen/widgets/project_card_vertical.dart';
import 'package:project_management_muhmad_omar/utils/data_model.dart';
import 'package:project_management_muhmad_omar/widgets/Navigation/app_header.dart';
import 'package:project_management_muhmad_omar/widgets/add_sub_icon.dart';
import 'package:project_management_muhmad_omar/widgets/container_label.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background.dart';

import 'team_details.dart';

class MyTeams extends StatelessWidget {
  const MyTeams({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      DarkRadialBackground(
        color: HexColor.fromHex("#181a1f"),
        position: "topLeft",
      ),
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                TaskezAppHeader(
                    title: "$tabSpace $tabSpace Team",
                    widget: const Row(children: [
                      const Icon(Icons.more_horiz,
                          size: 30, color: Colors.white),
                      AppSpaces.horizontalSpace20,
                      AddSubIcon()
                    ])),
                AppSpaces.verticalSpace40,
                const TeamStory(
                    teamTitle: "Marketing",
                    numberOfMembers: "12",
                    noImages: "8"),
                Container(
                  height: Utils.getScreenHeight(context) / 2,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 220,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (_, index) => ProjectCardVertical(
                      projectName: AppData.productData[index]['projectName'],
                      category: AppData.productData[index]['category'],
                      color: AppData.productData[index]['color'],
                      ratingsUpperNumber: AppData.productData[index]
                          ['ratingsUpperNumber'],
                      ratingsLowerNumber: AppData.productData[index]
                          ['ratingsLowerNumber'],
                    ),
                    itemCount: 2,
                  ),
                ),
                AppSpaces.verticalSpace40,
                const TeamStory(
                    teamTitle: "Design", numberOfMembers: "12", noImages: "8"),
                Container(
                  height: Utils.getScreenHeight(context) / 2,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 220,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (_, index) => ProjectCardVertical(
                      projectName: AppData.productData[index]['projectName'],
                      category: AppData.productData[index]['category'],
                      color: AppData.productData[index]['color'],
                      ratingsUpperNumber: AppData.productData[index]
                          ['ratingsUpperNumber'],
                      ratingsLowerNumber: AppData.productData[index]
                          ['ratingsLowerNumber'],
                    ),
                    itemCount: 4,
                  ),
                ),
                AppSpaces.verticalSpace40,
                const TeamStory(
                    teamTitle: "Accounting",
                    numberOfMembers: "12",
                    noImages: "8"),
                Container(
                  height: Utils.getScreenHeight(context) / 2,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 220,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (_, index) => ProjectCardVertical(
                      projectName: AppData.productData[index]['projectName'],
                      category: AppData.productData[index]['category'],
                      color: AppData.productData[index]['color'],
                      ratingsUpperNumber: AppData.productData[index]
                          ['ratingsUpperNumber'],
                      ratingsLowerNumber: AppData.productData[index]
                          ['ratingsLowerNumber'],
                    ),
                    itemCount: 1,
                  ),
                )
              ]))))
    ]));
  }
}

class TeamStory extends StatelessWidget {
  final String teamTitle;
  final String numberOfMembers;
  final String noImages;

  const TeamStory({
    Key? key,
    required this.teamTitle,
    required this.numberOfMembers,
    required this.noImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(teamTitle, style: AppTextStyles.header2.copyWith(fontSize: 35)),
        AppSpaces.verticalSpace10,
        ContainerLabel(label: "$numberOfMembers Members"),
        AppSpaces.verticalSpace10,
        InkWell(
          onTap: () {
            Get.to(() => TeamDetails(title: teamTitle));
          },
          child: Transform.scale(
              alignment: Alignment.centerLeft,
              scale: 0.7,
              child:
                  buildStackedImages(numberOfMembers: noImages, addMore: true)),
        ),
      ],
    );
  }
}
