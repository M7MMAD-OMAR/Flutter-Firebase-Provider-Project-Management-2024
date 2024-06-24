import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/providers/task_category_provider.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/select_color_dialog_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheet_holder_widget.dart';
import 'package:provider/provider.dart';

import 'package:project_management_muhmad_omar/providers/projects/project_main_task_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/project_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/project_sub_task_provider.dart';
import 'package:project_management_muhmad_omar/providers/team_member_provider.dart';
import 'package:project_management_muhmad_omar/providers/user_provider.dart';
import 'package:project_management_muhmad_omar/providers/user_task_provider.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';
import '../add_sub_icon_widget.dart';
import '../forms/form_input_with_label_widget.dart';
import '../user/new_sheet_goto_calender_widget.dart';

class NewCreateTaskBottomSheet extends StatefulWidget {
  NewCreateTaskBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<NewCreateTaskBottomSheet> createState() =>
      _NewCreateTaskBottomSheetState();
}

class _NewCreateTaskBottomSheetState extends State<NewCreateTaskBottomSheet> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();

  List<int> importancelist = [
    1,
    2,
    3,
    4,
    5,
  ];
  int? selectedDashboardOption;
  List<TeamMemberModel> membersList = [];
  String? teamMemberId;

  @override
  void initState() {
    super.initState();
    selectedDashboardOption = importancelist[0];
  }

  //void onChanged(String value) async {}

  DateTime startDate = DateTime.now();
  String color = "#FDA7FF";
  DateTime dueDate = DateTime.now();
  UserProvider userController =
      Provider.of<UserProvider>(context, listen: false);
  UserTaskProvider userTaskController =
      Provider.of<UserTaskProvider>(context, listen: false);
  ProjectMainTaskProvider projectMainTaskController =
      Provider.of<ProjectMainTaskProvider>(context, listen: false);
  TaskCategoryProvider taskCategoryController =
      Provider.of<TaskCategoryProvider>(context, listen: false);
  ProjectSubTaskProvider projectSubTaskController =
      Provider.of<ProjectSubTaskProvider>(context, listen: false);
  ProjectProvider projectController =
      Provider.of<ProjectProvider>(context, listen: false);
  TeamMemberProvider teamMemberController =
      Provider.of<TeamMemberProvider>(context, listen: false);
  bool isTaked = false;
  String name = "";
  String desc = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        AppSpaces.verticalSpace10,
        const BottomSheetHolder(),
        AppSpaces.verticalSpace10,
        Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("importance", style: AppTextStyles.header3),
                AppSpaces.horizontalSpace10,
                DropdownButton<String>(
                  icon: const Icon(Icons.label_important_outline_rounded),
                  dropdownColor: HexColor.fromHex("#181a1f"),
                  style: AppTextStyles.header3,
                  value: selectedDashboardOption.toString(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDashboardOption = int.parse(newValue!);
                    });
                  },
                  items:
                      importancelist.map<DropdownMenuItem<String>>((int num) {
                    return DropdownMenuItem<String>(
                      value: num.toString(),
                      child: Text(num.toString()),
                    );
                  }).toList(),
                )
              ],
            ),
            AppSpaces.verticalSpace10,

            AppSpaces.verticalSpace10,
            Row(
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ColorSelectionDialog(
                          onSelectedColorChanged: handleColorChanged,
                          initialColor: color,
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: HexColor.fromHex(color)),
                  ),
                ),
                AppSpaces.horizontalSpace20,
                Expanded(
                  child: LabelledFormInput(
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (isTaked) {
                          return "Please use another taskName";
                        }
                      }
                      return null;
                    },
                    onClear: () {
                      setState(() {
                        name = "";
                        _taskNameController.text = "";
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    label: "Name",
                    readOnly: false,
                    autovalidateMode: AutovalidateMode.always,
                    placeholder: "Task Name ....",
                    keyboardType: "text",
                    controller: _taskNameController,
                    obscureText: false,
                  ),
                ),
              ],
            ),
            AppSpaces.verticalSpace20,
            LabelledFormInput(
              validator: (p0) {
                if (p0 == " ") {
                  return "description cannot be empy spaces";
                }
                return null;
              },
              onChanged: (p0) {
                setState(() {
                  desc = p0;
                });
              },
              onClear: () {
                setState(() {
                  desc = "";
                  _taskDescController.text = "";
                });
              },
              label: "Description",
              readOnly: false,
              autovalidateMode: AutovalidateMode.always,
              placeholder: "Task Description ....",
              keyboardType: "text",
              controller: _taskDescController,
              obscureText: false,
            ),
            AppSpaces.verticalSpace20,
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              NewSheetGoToCalendarWidget(
                selectedDay: startDate,
                onSelectedDayChanged: handleStartDayChanged,
                cardBackgroundColor: HexColor.fromHex("7DBA67"),
                textAccentColor: HexColor.fromHex("A9F49C"),
                value: formatDateTime(startDate),
                label: 'Start Date',
              ),
              NewSheetGoToCalendarWidget(
                onSelectedDayChanged: handleDueDayChanged,
                selectedDay: dueDate,
                cardBackgroundColor: HexColor.fromHex("BA67A3"),
                textAccentColor: HexColor.fromHex("BA67A3"),
                value: "1",
                label: 'Due Date',
              )
            ]),
            // Spacer(),
            AppSpaces.verticalSpace20,
            AppSpaces.verticalSpace20,
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              AddSubIcon(
                icon: const Icon(Icons.add, color: Colors.white),
                scale: 1,
                color: AppColors.primaryAccentColor,
                callback: _addProject,
              ),
            ])
          ]),
        ),
      ]),
    );
  }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "Today ${DateFormat('h:mma').format(dateTime)}";
    } else {
      return DateFormat('dd h:mma').format(dateTime);
    }
  }

  void handleColorChanged(String selectedColor) {
    setState(() {
      // Update the selectedDay variable in the first screen
      color = selectedColor;
    });
  }

  void handleDueDayChanged(DateTime selectedDay) {
    setState(() {
      // Update the selectedDay variable in the first screen
      startDate = selectedDay;
    });
  }

  void handleStartDayChanged(DateTime selectedDay) {
    setState(() {
      // Update the selectedDay variable in the first screen
      dueDate = selectedDay;
    });
  }

  void _addProject() {}
// void _addProject() async {
//   if (widget.taskType == "userTask") {
//     StatusController statusController = Get.put(StatusController());
//     StatusModel statusModel =
//         await statusController.getStatusByName(status: "notDone");
//     DocumentReference? taskfatherid;
//     if (widget.fathertask != null) {
//       DocumentSnapshot documentReference = await statusController.getDocById(
//           reference: usersTasksRef, id: widget.fathertask!.id);
//       taskfatherid = documentReference.reference;
//     }
//     UserTaskModel userTaskModel = UserTaskModel(
//         userIdParameter: firebaseAuth.currentUser!.uid,
//         folderIdParameter: widget.userTaskCategoryModel!.id,
//         taskFatherIdParameter: taskfatherid,
//         descriptionParameter: desc,
//         idParameter: usersTasksRef.doc().id,
//         nameParameter: name,
//         statusIdParameter: statusModel.id,
//         importanceParameter: selectedDashboardOption!,
//         createdAtParameter: DateTime.now(),
//         updatedAtParameter: DateTime.now(),
//         startDateParameter: startDate,
//         endDateParameter: dueDate);
//     userTaskController.addUserTask(userTaskModel: userTaskModel);
//   } else if (widget.taskType == "mainTask") {
//   } else if (widget.taskType == "subTask") {}
// }
}

class BottomSheetIcon extends StatelessWidget {
  final IconData icon;

  const BottomSheetIcon({
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      iconSize: 32,
      onPressed: null,
    );
  }
}
