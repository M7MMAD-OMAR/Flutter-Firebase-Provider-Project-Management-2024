import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/app_constans.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';

class BarChartSample1 extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  BarChartSample1(
      {super.key, required this.percentages, required this.message});

  final List<double> percentages;
  final String message;

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = const Color(0xFFA06AFA);
  static const Color mainColor = Color(0xFFFAA3FF);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstants.completed_last_7_days_key.tr,
                    style: GoogleFonts.lato(
                      color: HexColor.fromHex("616575"),
                      fontSize: Utils.screenWidth * 0.04,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: const Color(0xff0f4a3c),
                    ),
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                        if (isPlaying) {
                          refreshState();
                        }
                      });
                    },
                  ),
                ],
              ),
              AppSpaces.verticalSpace10,
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                ),
              ),
              AppSpaces.verticalSpace10,
              Row(children: [
                Text(widget.message,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    )),
                AppSpaces.horizontalSpace20,
              ])
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      await refreshState();
    }
  }
}

class _BarChartTitle extends StatelessWidget {
  final String title;

  const _BarChartTitle(
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }
}
