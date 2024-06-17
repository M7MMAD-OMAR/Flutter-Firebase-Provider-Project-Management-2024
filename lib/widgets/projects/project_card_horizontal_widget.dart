import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/widgets/Projects/project_badge_widget.dart';

class ProjectCardHorizontal extends StatelessWidget {
  final String projectName;
  final String projeImagePath;
  final String teamName;
  final DateTime endDate;
  final DateTime startDate;
  final String status;
  final String idk;
  String startDateString = "";
  String endDateString = "";
  ProjectCardHorizontal({
    Key? key,
    required this.idk,
    required this.status,
    required this.teamName,
    required this.projectName,
    required this.projeImagePath,
    required this.endDate,
    required this.startDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Utils.screenWidth * 0.03,
        vertical: Utils.screenHeight * 0.005,
      ),
      decoration: BoxDecoration(
        color: HexColor.fromHex("20222A"),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                ColouredProjectBadge(projeImagePath: projeImagePath),
                AppSpaces.horizontalSpace20,
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        "الفريق : ",
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
                  Row(
                    children: [
                      Text(
                        "الحالة : ",
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
                  Row(
                    children: [
                      Text(
                        "تاريخ البدء  : ",
                        style: GoogleFonts.lato(
                          color: HexColor.fromHex("246CFE"),
                        ),
                      ),
                      Text(
                        formatDateTime(startDate),
                        style: GoogleFonts.lato(
                          color: HexColor.fromHex("626677"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "تاريخ الانتهاء : ",
                        style: GoogleFonts.lato(
                          color: HexColor.fromHex("246CFE"),
                        ),
                      ),
                      Text(
                        formatDateTime(endDate),
                        style: GoogleFonts.lato(
                          color: HexColor.fromHex("626677"),
                        ),
                      ),
                    ],
                  ),
                ])
              ]),
            ]),
        AppSpaces.verticalSpace10,
      ]),
    );
  }
}

String formatDateTime(DateTime dateTime) {
  DateTime now = DateTime.now();

  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    return "اليوم ${DateFormat('h:mm a').format(dateTime)}";
  } else {
    return DateFormat('dd/MM h:mm a').format(dateTime);
  }
}
