import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/widgets/Projects/project_badge_widget.dart';

class ProjectCardVertical extends StatelessWidget {
  final String projectName;
  final String idk;
  final String teamName;
  final String projeImagePath;
  final DateTime endDate;
  final DateTime startDate;
  final String status;
  String startDateString = "";
  String endDateString = "";

  ProjectCardVertical({
    Key? key,
    required this.idk,
    required this.status,
    required this.projeImagePath,
    required this.projectName,
    required this.teamName,
    required this.endDate,
    required this.startDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Utils.screenWidth * 0.03,
        vertical: Utils.screenHeight * 0.02,
      ),
      decoration: BoxDecoration(
        color: HexColor.fromHex("20222A"),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ColouredProjectBadge(projeImagePath: projeImagePath),
        SizedBox(height: Utils.screenHeight * 0.01),
        Text(
          projectName,
          style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: Utils.screenWidth * 0.05,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(height: Utils.screenHeight * 0.01),
        Row(children: [
          InkWell(
            child: Text(
              "${AppConstants.team_key.tr} : ",
              style: TextStyle(
                color: HexColor.fromHex("246CFE"),
              ),
            ),
          ),
          Text(
            teamName,
            style: TextStyle(
              color: HexColor.fromHex("626677"),
            ),
          ),
        ]),
        AppSpaces.horizontalSpace10,
        Row(
          children: [
            Text(
              "${AppConstants.status_key.tr} : ",
              style: GoogleFonts.lato(
                color: HexColor.fromHex("246CFE"),
              ),
            ),
            Text(
              status,
              style: GoogleFonts.lato(
                color: HexColor.fromHex("626677"),
              ),
            ),
          ],
        ),
        Text(
          AppConstants.start_date_key.tr,
          style: GoogleFonts.lato(
            color: HexColor.fromHex("246CFE"),
          ),
        ),
        Text(
          "${formatDateTime(startDate)} ",
          style: GoogleFonts.lato(
            color: HexColor.fromHex("626677"),
          ),
        ),
        Text(
          AppConstants.end_date_key.tr,
          style: GoogleFonts.lato(
            color: HexColor.fromHex("246CFE"),
          ),
        ),
        Text(
          "${formatDateTime(endDate)} ",
          style: GoogleFonts.lato(
            color: HexColor.fromHex("626677"),
          ),
        ),
      ]),
    );
  }
}

String formatDateTime(DateTime dateTime) {
  DateTime now = DateTime.now();

  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    return "${AppConstants.today_key.tr} ${DateFormat('h:mm a').format(dateTime)}";
  } else {
    return DateFormat('dd/MM h:mm a').format(dateTime);
  }
}
