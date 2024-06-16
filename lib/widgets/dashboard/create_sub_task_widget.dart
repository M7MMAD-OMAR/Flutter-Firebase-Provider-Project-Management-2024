import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_management_muhmad_omar/constants/app_constans.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/categoryController.dart';
import 'package:project_management_muhmad_omar/controllers/projectController.dart';
import 'package:project_management_muhmad_omar/controllers/teamController.dart';
import 'package:project_management_muhmad_omar/controllers/userController.dart';
import 'package:project_management_muhmad_omar/controllers/user_task_controller.dart';
import 'package:project_management_muhmad_omar/models/team/project_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_sub_task_model.dart';
import 'package:project_management_muhmad_omar/models/team/team_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/select_color_dialog_widget.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/select_member_for_sub_task_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheet_holder_widget.dart';

import '../add_sub_icon_widget.dart';
import '../forms/form_input_with _label_widget.dart';
import '../snackbar/custom_snackber_widget.dart';
import '../user/inactive_employee_card_sub_task_widget.dart';
import '../user/new_sheet_goto_calender_widget.dart';

class CreateSubTask extends StatefulWidget {
  CreateSubTask({
    required this.addTask,
    super.key,
    this.userTaskModel,
    required this.isEditMode,
    required this.checkExist,
    required this.projectId,
  });
  final bool isEditMode;
  ProjectSubTaskModel? userTaskModel;
  String projectId;
  final Future<void> Function(
      {required int priority,
      required String taskName,
      required DateTime startDate,
      required DateTime dueDate,
      required String? desc,
      required String color,
      required String userIdAssignedTo}) addTask;
  final Future<bool> Function({required String name}) checkExist;

  @override
  State<CreateSubTask> createState() => _CreateSubTaskState();
}

class _CreateSubTaskState extends State<CreateSubTask> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? assignedToUserId;
  List<int> importancelist = [
    1,
    2,
    3,
    4,
    5,
  ];
  int? selectedDashboardOption;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.userTaskModel != null) {
      inisiateUserId(memberId: widget.userTaskModel!.assignedTo);
      _taskNameController.text = widget.userTaskModel!.name!;
      _taskDescController.text = widget.userTaskModel!.description!;
      name = widget.userTaskModel!.name!;
      desc = widget.userTaskModel!.description!;
      startDate = widget.userTaskModel!.startDate;
      dueDate = widget.userTaskModel!.endDate!;
      selectedDashboardOption = importancelist.singleWhere(
          (element) => element == widget.userTaskModel!.importance);
      color = widget.userTaskModel!.hexcolor;
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

  Future onChanged(String value) async {
    name = value;

    if (name.isNotEmpty) {
      isTaked = await widget.checkExist(name: name);

      setState(() {
        isTaked;
      });
    }
  }

  Future<void> inisiateUserId({required memberId}) async {
    UserModel userModel =
        await UserController().getUserWhereMemberIs(memberId: memberId);
    setState(() {
      assignedToUserId = userModel.id;
    });
  }

  onSelectedUserChanged({required UserModel? userModel}) {
    setState(() {
      assignedToUserId = userModel?.id;
    });
  }

  DateTime startDate = DateTime.now();
  String color = "#FDA7FF";
  DateTime dueDate = DateTime.now();
  UserTaskController userTaskController = Get.put(UserTaskController());
  TaskCategoryController taskCategoryController =
      Get.put(TaskCategoryController());

  bool isTaked = false;
  String name = "";
  String desc = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(children: [
          AppSpaces.verticalSpace10,
          const BottomSheetHolder(),
          AppSpaces.verticalSpace10,
          Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (assignedToUserId != null)
                StreamBuilder<DocumentSnapshot<UserModel>>(
                  stream:
                      UserController().getUserByIdStream(id: assignedToUserId!),
                  builder: (context, snapshot) {
                    UserModel? userModel = snapshot.data?.data()!;
                    if (snapshot.hasData) {
                      return InactiveEmployeeCardSubTask(
                        onTap: () async {
                          ProjectModel? projectModel = await ProjectController()
                              .getProjectById(id: widget.projectId);
                          TeamModel? teamModel = await TeamController()
                              .getTeamById(id: projectModel!.teamId!);
                          Get.to(SearchForMembersSubTask(
                            userModel: userModel,
                            teamModel: teamModel,
                            onSelectedUserChanged: onSelectedUserChanged,
                          ));
                        },
                        color: Colors.white,
                        userImage: userModel!.imageUrl,
                        userName: userModel.userName ?? "no user name",
                        bio: userModel.bio ?? "no bio",
                      );
                    }
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBackgroundColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            AppConstants.please_select_a_member_key.tr,
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.4,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              if (assignedToUserId == null)
                InkWell(
                  onTap: () async {
                    ProjectModel? projectModel = await ProjectController()
                        .getProjectById(id: widget.projectId);

                    TeamModel teamModel = await TeamController()
                        .getTeamById(id: projectModel!.teamId!);

                    Get.to(() => SearchForMembersSubTask(
                          onSelectedUserChanged: onSelectedUserChanged,
                          userModel: null,
                          teamModel: teamModel,
                        ));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        AppConstants.please_select_a_member_key.tr,
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.4,
                        ),
                      ),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppConstants.importance_key.tr,
                      style: AppTextStyles.header2),
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
                          return AppConstants.enter_name_key.tr;
                        }
                        if (value.isNotEmpty) {
                          if (isTaked) {
                            return AppConstants
                                .please_use_another_taskName_key.tr;
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
                      onChanged: (String name) async {
                        await onChanged(name);
                      },
                      label: AppConstants.name_key.tr,
                      readOnly: false,
                      autovalidateMode: AutovalidateMode.always,
                      placeholder: "${AppConstants.task_name_key.tr} ....",
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
                    return AppConstants
                        .description_cannot_be_empty_spaces_key.tr;
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
                label: AppConstants.description_key.tr,
                readOnly: false,
                autovalidateMode: AutovalidateMode.always,
                placeholder: "${AppConstants.task_description_key.tr} ....",
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
                  label: AppConstants.start_date_key.tr,
                ),
                NewSheetGoToCalendarWidget(
                  onSelectedDayChanged: handleDueDayChanged,
                  selectedDay: dueDate,
                  cardBackgroundColor: HexColor.fromHex("BA67A3"),
                  textAccentColor: HexColor.fromHex("BA67A3"),
                  value: formattedDueDate,
                  label: AppConstants.end_date_key.tr,
                )
              ]),
              AppSpaces.verticalSpace20,
              AppSpaces.verticalSpace20,
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                AddSubIcon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  scale: 1,
                  color: AppColors.primaryAccentColor,
                  callback: () {
                    if (formKey.currentState!.validate()) {
                      if (assignedToUserId == null) {
                        CustomSnackBar.showError(AppConstants
                            .please_choose_member_to_assign_task_key.tr);
                        return;
                      }
                      widget.addTask(
                          color: color,
                          priority: selectedDashboardOption!,
                          taskName: name,
                          desc: desc,
                          dueDate: dueDate,
                          startDate: startDate,
                          userIdAssignedTo: assignedToUserId!);
                    }
                  },
                ),
              ])
            ]),
          ),
        ]),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "${AppConstants.today_key.tr} ${DateFormat('h:mma').format(dateTime)}";
    } else {
      return DateFormat('dd/MM h:mma').format(dateTime);
    }
  }

  void handleColorChanged(String selectedColor) {
    setState(() {
      this.color = selectedColor;
    });
  }

  void handleDueDayChanged(DateTime selectedDay) {
    setState(() {
      dueDate = selectedDay;
      formattedDueDate = formatDateTime(dueDate);
    });
  }

  void handleStartDayChanged(DateTime selectedDay) {
    setState(() {
      startDate = selectedDay;
      formattedStartDate = formatDateTime(startDate);
    });
  }
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
