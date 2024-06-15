import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';

import 'back_button.dart';

class TaskezAppHeader extends StatelessWidget {
  final String title;
  final bool? messagingPage;
  final Widget? widget;
  const TaskezAppHeader(
      {Key? key, this.widget, required this.title, this.messagingPage})
      : super(key: key);
// the Developer karem saad (KaremSD)
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const AppBackButton(),
        (messagingPage != null)
            ? Row(children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HexColor.fromHex("94D57B"),
                  ),
                ),
                SizedBox(
                    width: Utils.screenWidth *
                        0.01), // Adjust the percentage as needed

                Expanded(
                  child: Text(
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    title,
                    style: GoogleFonts.lato(
                        fontSize: Utils.screenWidth *
                            0.07, // Adjust the percentage as needed

                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ])
            : Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  title,
                  style: GoogleFonts.lato(
                      fontSize: Utils.screenWidth *
                          0.065, // Adjust the percentage as needed

                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
        widget!
      ]),
    );
  }
}
