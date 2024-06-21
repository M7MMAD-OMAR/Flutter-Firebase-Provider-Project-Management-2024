import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/task_category_provider.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/select_color_dialog_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheet_holder_widget.dart';
import 'package:provider/provider.dart';

import '../../controllers/user_task_provider.dart';
import '../../models/team/project_main_task_model.dart';
import '../../models/team/project_model.dart';
import '../../models/team/team_members_model.dart';
import '../add_sub_icon_widget.dart';
import '../forms/form_input_with_label_widget.dart';
import '../user/new_sheet_goto_calender_widget.dart';

class CreateMainTask extends StatefulWidget {
  CreateMainTask(
      {required this.addTask,
      Key? key,
      required this.projectModel,
      this.projectMainTaskModel,
      required this.isEditMode,
      required this.checkExist})
      : super(key: key);
  ProjectModel projectModel;
  final bool isEditMode;
  ProjectMainTaskModel? projectMainTaskModel;
  final Future<void> Function(
      {required int priority,
      required String taskName,
      required DateTime startDate,
      required DateTime dueDate,
      required String? desc,
      required String color}) addTask;
  final Future<bool> Function({String name}) checkExist;

  @override
  State<CreateMainTask> createState() => _CreateMainTaskState();
}

class _CreateMainTaskState extends State<CreateMainTask> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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

    if (widget.isEditMode && widget.projectMainTaskModel != null) {
      _taskNameController.text = widget.projectMainTaskModel!.name!;
      _taskDescController.text = widget.projectMainTaskModel!.description!;
      name = widget.projectMainTaskModel!.name!;
      desc = widget.projectMainTaskModel!.description!;
      startDate = widget.projectMainTaskModel!.startDate;
      dueDate = widget.projectMainTaskModel!.endDate!;
      selectedDashboardOption = importancelist.singleWhere(
          (element) => element == widget.projectMainTaskModel!.importance);
      color = widget.projectMainTaskModel!.hexcolor;
      formattedStartDate = formatDateTime(startDate);
      formattedDueDate = formatDateTime(dueDate);
    } else {
      selectedDashboardOption = importancelist[0];
      formattedStartDate = formatDateTime(startDate);
      formattedDueDate = formatDateTime(dueDate);
    }
  }

  String formattedStartDate = "";
  String formattedDueDate = "";

  void onChanged(String value) async {
    name = value;
    if (await widget.checkExist()) {
      isTaked = true;
    } else {
      isTaked = false;
    }

    setState(() {
      isTaked;
    });
  }

  DateTime startDate = DateTime.now();
  String color = "#FDA7FF";
  DateTime dueDate = DateTime.now();
  UserTaskProvider userTaskController =
      Provider.of<UserTaskProvider>(context, listen: false);
  TaskCategoryProvider taskCategoryController =
      Provider.of<TaskCategoryProvider>(context, listen: false);

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
                Text('الأهمية', style: AppTextStyles.header2),
                AppSpaces.horizontalSpace10,
                DropdownButton<String>(
                  icon: const Icon(Icons.label_important_outline_rounded),
                  dropdownColor: HexColor.fromHex("#181a1f"),
                  style: AppTextStyles.header2,
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
                      if (value!.isEmpty) {
                        return 'الرجاء إدخال الاسم';
                      }
                      if (value.isNotEmpty) {
                        if (isTaked) {
                          return 'يرجى استخدام اسم مهمة آخر';
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
                    onChanged: onChanged,
                    label: "الاسم",
                    readOnly: false,
                    autovalidateMode: AutovalidateMode.always,
                    placeholder: "اسم المهمة",
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
                  return 'لا يمكن أن يكون الوصف مساحات فارغة';
                }
                return null;
              },
              onChanged: (p0) {
                desc = p0;
              },
              onClear: () {
                setState(() {
                  desc = "";
                  _taskDescController.text = "";
                });
              },
              label: 'وصف',
              readOnly: false,
              autovalidateMode: AutovalidateMode.always,
              placeholder: "وصف المهمة...",
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
                value: formattedStartDate,
                label: 'تاريخ البدء',
              ),
              NewSheetGoToCalendarWidget(
                onSelectedDayChanged: handleDueDayChanged,
                selectedDay: dueDate,
                cardBackgroundColor: HexColor.fromHex("BA67A3"),
                textAccentColor: HexColor.fromHex("BA67A3"),
                value: formattedDueDate,
                label: 'تاريخ الانتهاء',
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
                callback: () {
                  widget.addTask(
                    color: color,
                    priority: selectedDashboardOption!,
                    taskName: name,
                    desc: desc,
                    dueDate: dueDate,
                    startDate: startDate,
                  );
                },
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
      return "اليوم ${DateFormat('h:mma').format(dateTime)}";
    } else {
      return DateFormat('dd/MM h:mma').format(dateTime);
    }
  }

  void handleColorChanged(String selectedColor) {
    setState(() {
      // Update the selectedDay variable in the first screen
      this.color = selectedColor;
    });
  }

  void handleDueDayChanged(DateTime selectedDay) {
    setState(() {
      // Update the selectedDay variable in the first screen
      dueDate = selectedDay;
      formattedDueDate = formatDateTime(dueDate);
    });
  }

  void handleStartDayChanged(DateTime selectedDay) {
    setState(() {
      // Update the selectedDay variable in the first screen

      startDate = selectedDay;
      formattedStartDate = formatDateTime(startDate);
    });
  }

  void _addUserTask() async {
    await widget.addTask(
      color: color,
      desc: desc,
      dueDate: dueDate,
      priority: selectedDashboardOption!,
      startDate: startDate,
      taskName: name,
    );
  }
// void _addUserTask() async {
//   if (startDate.isAfter(dueDate) || startDate.isAtSameMomentAs(dueDate)) {
//     CustomSnackBar.showError("start date cannot be after end date");
//     return;
//   }
//   if (widget.isEditMode == false) {
//     try {
//       StatusController statusController = Get.put(StatusController());
//       StatusModel statusModel =
//           await statusController.getStatusByName(status: statusNotDone);
//       DocumentReference? taskfatherid;
//       if (widget.fatherTaskModel != null) {
//         DocumentSnapshot documentReference =
//             await statusController.getDocById(
//                 reference: usersTasksRef, id: widget.fatherTaskModel!.id);
//         taskfatherid = documentReference.reference;
//       }
//       UserTaskModel userTaskModel = UserTaskModel(
//           hexColorParameter: color,
//           userIdParameter: firebaseAuth.currentUser!.uid,
//           folderIdParameter: widget.userTaskCategoryModel.id,
//           taskFatherIdParameter: taskfatherid,
//           descriptionParameter: desc,
//           idParameter: usersTasksRef.doc().id,
//           nameParameter: name,
//           statusIdParameter: statusModel.id,
//           importanceParameter: selectedDashboardOption!,
//           createdAtParameter: DateTime.now(),
//           updatedAtParameter: DateTime.now(),
//           startDateParameter: startDate,
//           endDateParameter: dueDate);
//       await userTaskController.addUserTask(userTaskModel: userTaskModel);
//       CustomSnackBar.showSuccess("task ${name} added successfully");
//       Navigator.pop(context);
//     } catch (e) {
//       CustomSnackBar.showError(e.toString());
//     }
//   } else {
//     await userTaskController.updateUserTask(data: {
//       nameK: name,
//       descriptionK: desc,
//       colorK: color,
//       importanceK: selectedDashboardOption,
//       startDateK: startDate,
//       endDateK: dueDate
//     }, id: widget.userTaskModel!.id);
//     CustomSnackBar.showSuccess("task ${name} Updated successfully");
//     Navigator.pop(context);
//   }
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
