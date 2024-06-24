// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/providers/user_task_provider.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class DailyGoalCard extends StatefulWidget {
  DailyGoalCard({super.key,
      required this.message,
      required this.allStream,
      required this.forStatusStram});
  String message;
  Stream allStream;
  Stream forStatusStram;
  @override
  State<DailyGoalCard> createState() => _DailyGoalCardState();
}

class _DailyGoalCardState extends State<DailyGoalCard> {
  @override
  Widget build(BuildContext context) {
    UserTaskProvider userTaskController =
        Provider.of<UserTaskProvider>(context, listen: false);
    DateTime nowDate = DateTime.now();
    int first = 0;
    int second = 0;
    double percent = 0.0;
    DateTime todayDate = DateTime(
      nowDate.year,
      nowDate.month,
      nowDate.day,
      0,
      0,
      0,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13.0),
      height: Utils.screenHeight * 0.2,
      // Adjust percentage as needed,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          color: AppColors.primaryBackgroundColor),
      child: StreamBuilder(
        stream: userTaskController.getUserTasksBetweenTowTimesStream(
            firstDate: todayDate,
            secondDate: todayDate.add(
              const Duration(days: 1),
            ),
            userId: AuthProvider.firebaseAuth.currentUser!.uid),
        builder: (context, allTasks) {
          if (allTasks.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (allTasks.hasError) {
            return Text('Error: ${allTasks.error}');
          }
          if (allTasks.hasData) {
            return StreamBuilder(
              stream:
                  userTaskController.getUserTasksStartInADayForAStatusStream(
                      date: DateTime.now(),
                      userId: AuthProvider.firebaseAuth.currentUser!.uid,
                      status: statusDone),
              builder: (context, doneTasks) {
                if (doneTasks.hasData) {
                  first = doneTasks.data!.size;
                  second = allTasks.data!.size;
                  percent = (second != 0 ? ((first / second) * 100) : 0);
                  percent = percent / 100;
                  return dailygoal(
                    first: first,
                    second: second,
                    percent: percent,
                    message: widget.message,
                  );
                }
                return dailygoal(
                  first: first,
                  second: second,
                  percent: percent,
                  message: widget.message,
                );
              },
            );
          }
          return dailygoal(
            first: first,
            second: second,
            percent: percent,
            message: widget.message,
          );
        },
      ),
    );
  }
}

class dailygoal extends StatelessWidget {
  dailygoal({
    super.key,
    required this.first,
    required this.second,
    required this.percent,
    required this.message,
  });

  final int first;
  final int second;
  final double percent;
  String message;

  @override
  Widget build(BuildContext context) {
    //  final screenHeight = MediaQuery.of(context).size.height;
    //final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //left side
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الهدف اليومي',
              style: GoogleFonts.lato(
                  color: HexColor.fromHex("616575"),
                  fontSize: Utils.screenWidth * 0.05,
                  fontWeight: FontWeight.w500),
            ),
            AppSpaces.verticalSpace10,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 25,
                  decoration: BoxDecoration(
                      color: HexColor.fromHex("8ACA72"),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20.0),
                      )),
                  child: Center(
                    child: Text(
                      '$first/$second',
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: Utils.screenWidth * 0.05,
                      ),
                    ),
                  ),
                ),
                AppSpaces.horizontalSpace10,
                Text(
                  "المهام",
                  style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: Utils.screenWidth * 0.05,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            // AppSpaces.verticalSpace10,
            Text(
              "  $first  $message  تم إنجازها 🎉  ",
              style: GoogleFonts.lato(
                  color: HexColor.fromHex("616575"),
                  fontSize: Utils.screenWidth * 0.040,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Stack(
          children: [
            Container(
              width:
                  Utils.screenWidth * 0.27, // Adjust the percentage as needed
              height: Utils.screenWidth * 0.27,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: Utils.screenWidth * 0.02,
                  color: HexColor.fromHex("434552"),
                ),
              ),
              child: Center(
                child: Container(
                  width: Utils.screenWidth *
                      0.4, // Adjust the percentage as needed
                  height: Utils.screenWidth * 0.15,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const ClipOval(
                    child: Image(
                      fit: BoxFit.contain,
                      image: AssetImage(
                        "assets/icon/logo.png",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: Utils.screenHeight * 0.01, // Adjust the percentage as needed
              left: Utils.screenWidth * 0.01, // Adjust the percentage as needed
              child: RotatedBox(
                quarterTurns: 4,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 0.80),
                  duration: const Duration(milliseconds: 1000),
                  builder: (context, value, _) => SizedBox(
                    width: Utils.screenWidth *
                        0.1, // Adjust the percentage as needed
                    height: Utils.screenWidth * 0.1,
                    child: CircularProgressIndicator(
                      strokeWidth: Utils.screenWidth * 0.02,
                      value: percent,
                      color: HexColor.fromHex("8FFFCF"),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
