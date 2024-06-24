import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management_muhmad_omar/providers/projects/project_main_task_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/project_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/project_sub_task_provider.dart';
import 'package:project_management_muhmad_omar/providers/user_task_provider.dart';
import 'package:project_management_muhmad_omar/models/team/project_main_task_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_sub_task_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_task_Model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/widgets/calender/widgets/circle_gradient_icon_widget.dart';
import 'package:project_management_muhmad_omar/widgets/calender/widgets/task_widget_widget.dart';

import '../Navigation/app_header_widget.dart';
import 'core/res/color.dart';

class TodaysTaskScreen extends StatefulWidget {
  const TodaysTaskScreen({Key? key}) : super(key: key);

  @override
  State<TodaysTaskScreen> createState() => _TodaysTaskScreenState();
}

class _TodaysTaskScreenState extends State<TodaysTaskScreen> {
  final todaysDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  late int _dateIndex;
  final double _width = 70;
  final double _margin = 15;
  final _scrollController = ScrollController();
  late int days;

  void getDates() {
    final date = DateTime(todaysDate.year, todaysDate.month);
    days = DateTimeRange(
      start: date,
      end: DateTime(todaysDate.year, todaysDate.month + 1),
    ).duration.inDays;
    _dateIndex = todaysDate.day;
    Future.delayed(
      const Duration(seconds: 1),
      () {
        _scroll();
      },
    );
    setState(() {});
  }


  void _scroll() {
    _scrollController.animateTo(
      (days * _dateIndex.toDouble()) +
          (_dateIndex.toDouble() * _width) -
          (_dateIndex * _margin) * 0.4,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  void _selectDate(int index) {
    setState(() {
      _dateIndex = index;
    });
 
    // Perform any additional operations with the selected date here
    selectedDate = DateTime(todaysDate.year, todaysDate.month, index + 1);
    // Do something with the selectedDate, e.g., store it in a variable
    setState(() {
      selectedDate;
    });
  }

  @override
  void initState() {
    getDates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex("#181a1f"),
      body: _buildBody(context),
    );
  }

  Container _buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: TaskezAppHeader(
              title: "Today's Task",
              widget: Container(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildDateHeader(context),
          const SizedBox(
            height: 20,
          ),
          _buildDateDays(),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  // const GlowText(
                  //   "User Tasks",
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white38
                  //     //  Colors.grey[800]
                  //     ,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot<UserTaskModel>>(
                    stream: UserTaskProvider().getUserTasksStartInADayStream(
                        userId: AuthProvider.firebaseAuth.currentUser!.uid,
                        date: selectedDate),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var varo = snapshot.data!.docs;
                        List<UserTaskModel> _tasksList = [];
                        for (var element in varo) {
                          _tasksList.add(element.data());
                        }
                        return Column(
                          children: _tasksList
                              .map(
                                (e) => TaskWidgetCalender(
                                  name: e.name!,
                                  startDate: e.startDate,
                                  endDate: e.endDate!,
                                ),
                              )
                              .toList(),
                        );
                      }
                      if (snapshot.hasError) {
                        // return GlowText(
                        //   removeException(snapshot.error.toString()),
                        //   style: const TextStyle(
                        //       fontSize: 24, color: Colors.redAccent),
                        //   textAlign: TextAlign.center,
                        // );
                      }
                      if (!snapshot.hasData) {
                        // return const GlowText(
                        //   "no personal tasks",
                        //   style:
                        //       TextStyle(fontSize: 24, color: Colors.redAccent),
                        //   textAlign: TextAlign.center,
                        // );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // const GlowText(
                  //   "sub tasks",
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white38
                  //     // Colors.grey[800]
                  //     ,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot<ProjectSubTaskModel>>(
                    stream: ProjectSubTaskProvider()
                        .getProjectSubTasksForAUserStartInADayStream(
                            date: selectedDate),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var varo = snapshot.data!.docs;
                        List<ProjectSubTaskModel> _tasksList = [];
                        for (var element in varo) {
                          _tasksList.add(element.data());
                        }
                        return Column(
                          children: _tasksList
                              .map(
                                (e) => TaskWidgetCalender(
                                  name: e.name!,
                                  startDate: e.startDate,
                                  endDate: e.endDate!,
                                ),
                              )
                              .toList(),
                        );
                      }
                      if (snapshot.hasError) {
                        // return GlowText(
                        // removeException(snapshot.error.toString()),
                        // style: const TextStyle(
                        //     fontSize: 24, color: Colors.redAccent),
                        // textAlign: TextAlign.center,
                        // );
                      }
                      if (!snapshot.hasData) {
                        // return const GlowText(
                        //   "no sub tasks assigned to me",
                        //   style:
                        //       TextStyle(fontSize: 24, color: Colors.redAccent),
                        //   textAlign: TextAlign.center,
                        // );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // const GlowText(
                  //   "Main Tasks for projects iam a member into",
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white38
                  //     // Colors.grey[800]
                  //     ,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot<ProjectMainTaskModel>>(
                    stream: ProjectMainTaskProvider()
                        .getUserAsMemberMainTasksInADayStream(
                            date: selectedDate),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var varo = snapshot.data!.docs;
                        List<ProjectMainTaskModel> _tasksList = [];
                        for (var element in varo) {
                          _tasksList.add(element.data());
                        }
                        return Column(
                          children: _tasksList
                              .map(
                                (e) => TaskWidgetCalender(
                                  name: e.name!,
                                  startDate: e.startDate,
                                  endDate: e.endDate!,
                                ),
                              )
                              .toList(),
                        );
                      }
                      if (snapshot.hasError) {
                        // return GlowText(
                        //   removeException(snapshot.error.toString()),
                        //   style: const TextStyle(
                        //       fontSize: 24, color: Colors.redAccent),
                        //   textAlign: TextAlign.center,
                        // );
                      }
                      if (!snapshot.hasData) {
                        // return const GlowText(
                        //   "no Main tasks for projects iam a member into",
                        //   style:
                        //       TextStyle(fontSize: 24, color: Colors.redAccent),
                        //   textAlign: TextAlign.center,
                        // );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // const GlowText(
                  //   "Main Tasks for projects iam a manager of it",
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white38
                  //     // Colors.grey[800]
                  //     ,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot<ProjectMainTaskModel>>(
                    stream: ProjectMainTaskProvider()
                        .getUserAsManagerMainTasksInADayStream(
                            date: selectedDate),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var varo = snapshot.data!.docs;
                        List<ProjectMainTaskModel> _tasksList = [];
                        for (var element in varo) {
                          _tasksList.add(element.data());
                        }
                        return Column(
                          children: _tasksList
                              .map(
                                (e) => TaskWidgetCalender(
                                  name: e.name!,
                                  startDate: e.startDate,
                                  endDate: e.endDate!,
                                ),
                              )
                              .toList(),
                        );
                      }
                      if (snapshot.hasError) {
                        // return GlowText(
                        //   removeException(snapshot.error.toString()),
                        //   style: const TextStyle(
                        //       fontSize: 24, color: Colors.redAccent),
                        //   textAlign: TextAlign.center,
                        // );
                      }
                      if (!snapshot.hasData) {
                        // return const GlowText(
                        //   "no Main tasks for projects iam a member into",
                        //   style:
                        //       TextStyle(fontSize: 24, color: Colors.redAccent),
                        //   textAlign: TextAlign.center,
                        // );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // const GlowText(
                  //   "projects iam a member of it",
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white38
                  //     // Colors.grey[800]
                  //     ,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot<ProjectModel>>(
                    stream: ProjectProvider()
                        .getProjectsOfMemberWhereUserIsInADayStream(
                            userId: AuthProvider.firebaseAuth.currentUser!.uid,
                            date: selectedDate),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var varo = snapshot.data!.docs;
                        List<ProjectModel> _tasksList = [];
                        for (var element in varo) {
                          _tasksList.add(element.data());
                        }
                        return Column(
                          children: _tasksList
                              .map(
                                (e) => TaskWidgetCalender(
                                  name: e.name!,
                                  startDate: e.startDate,
                                  endDate: e.endDate!,
                                ),
                              )
                              .toList(),
                        );
                      }
                      if (snapshot.hasError) {
                        // return GlowText(
                        //   removeException(snapshot.error.toString()),
                        //   style: const TextStyle(
                        //       fontSize: 24, color: Colors.redAccent),
                        //   textAlign: TextAlign.center,
                        // );
                      }
                      if (!snapshot.hasData) {
                        // return const GlowText(
                        //   "no projects iam a member of it",
                        //   style:
                        //       TextStyle(fontSize: 24, color: Colors.redAccent),
                        //   textAlign: TextAlign.center,
                        // );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // const GlowText(
                  //   "projects iam a manager of it",
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white38
                  //     // Colors.grey[800]
                  //     ,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot<ProjectModel>>(
                    stream: ProjectProvider()
                        .getProjectsOfManagerWhereUserIsInADayStream(
                            userId: AuthProvider.firebaseAuth.currentUser!.uid,
                            date: selectedDate),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var varo = snapshot.data!.docs;
                        List<ProjectModel> _tasksList = [];
                        for (var element in varo) {
                          _tasksList.add(element.data());
                        }
                        return Column(
                          children: _tasksList
                              .map(
                                (e) => TaskWidgetCalender(
                                  name: e.name!,
                                  startDate: e.startDate,
                                  endDate: e.endDate!,
                                ),
                              )
                              .toList(),
                        );
                      }
                      if (snapshot.hasError) {
                        // return GlowText(
                        //   removeException(snapshot.error.toString()),
                        //   style: const TextStyle(
                        //       fontSize: 24, color: Colors.redAccent),
                        //   textAlign: TextAlign.center,
                        // );
                      }
                      if (!snapshot.hasData) {
                        // return const GlowText(
                        //   "projects iam a manager of it",
                        //   style:
                        //       TextStyle(fontSize: 24, color: Colors.redAccent),
                        //   textAlign: TextAlign.center,
                        // );
                      }

                      return CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildDateHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GlowText(
            //   DateFormat("MMMM, dd").format(todaysDate),
            //   style: const TextStyle(
            //     color: Colors.white,
            //     // Colors.grey[800]
            //     fontSize: 30,
            //   ),
            // ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CircleGradientIcon(
            onTap: () {},
            icon: Icons.calendar_month,
            color: Colors.purple,
            iconSize: 24,
            size: 50,
          ),
        ),
      ],
    );
  }

  SizedBox _buildDateDays() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days,
        controller: _scrollController,
        itemBuilder: (context, index) {
          final monthDate =
              DateTime(todaysDate.year, todaysDate.month, index + 1);
          return InkWell(
            onTap: () {
              _selectDate(index);
              _scroll();
            },
            child: Container(
              width: _width,
              margin: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: _margin,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: todaysDate.day == (index + 1)
                    ? AppColors2.getDarkLinearGradient(
                        convertToMaterialColor(Colors.cyan))
                    : selectedDate.day == (index + 1)
                        ? AppColors2.getDarkLinearGradient(
                            convertToMaterialColor(
                                const Color.fromARGB(255, 216, 7, 171)))
                        : null,
                borderRadius: BorderRadius.circular(65),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0.2,
                    //   offset: const Offset(2, 2),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${index + 1}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: todaysDate.day == (index + 1)
                            ? Colors.white
                            : null),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    DateFormat('EEE').format(monthDate),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: todaysDate.day == (index + 1)
                            ? Colors.white
                            : null),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String removeException(String text) {
    return text.replaceAll("Exception:", '');
  }
}

MaterialColor convertToMaterialColor(Color color) {
  final int primary = color.value;

  return MaterialColor(primary, {
    50: color.withOpacity(0.1),
    100: color.withOpacity(0.2),
    200: color.withOpacity(0.3),
    300: color.withOpacity(0.4),
    400: color.withOpacity(0.5),
    500: color.withOpacity(0.6),
    600: color.withOpacity(0.7),
    700: color.withOpacity(0.8),
    800: color.withOpacity(0.9),
    900: color.withOpacity(1),
  });
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
