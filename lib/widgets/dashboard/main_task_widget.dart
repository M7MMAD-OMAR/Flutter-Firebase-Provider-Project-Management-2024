import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_glow/flutter_glow.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/manger_controller.dart';
import 'package:project_management_muhmad_omar/controllers/project_sub_task_controller.dart';
import 'package:project_management_muhmad_omar/controllers/userController.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/subTasks_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';

import '../../controllers/projectController.dart';
import '../../controllers/project_main_task_controller.dart';
import '../../controllers/statusController.dart';
import '../../controllers/topController.dart';
import '../../models/status_model.dart';
import '../../models/team/project_main_task_model.dart';
import '../../models/team/project_model.dart';
import '../../models/user/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/collections_refrences.dart';
import '../snackbar/custom_snackber_widget.dart';
import '../user/focused_menu_item_widget.dart';
import 'create_user_task_widget.dart';

class MainTaskProgressCard extends StatefulWidget {
  final ProjectMainTaskModel
      taskModel; // Update the type to ProjectMainTaskModel
  const MainTaskProgressCard({super.key, required this.taskModel});

  @override
  State<MainTaskProgressCard> createState() => _MainTaskProgressCardState();
}

class _MainTaskProgressCardState extends State<MainTaskProgressCard> {
  @override
  Widget build(BuildContext context) {
    double first = 0;
    double second = 0;
    double percento = 0;
    return StreamBuilder(
      stream: ProjectSubTaskController()
          .getSubTasksForAMainTaskStream(mainTaskId: widget.taskModel.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return StreamBuilder(
            stream: ProjectSubTaskController()
                .getMainTaskSubTasksForAStatusStream(
                    mainTaskId: widget.taskModel.id, status: statusDone),
            builder: (context, snapshot2) {
              if (snapshot2.hasData) {
                first = snapshot.data!.size.toDouble();
                second = snapshot2.data!.size.toDouble();
                percento = (snapshot.data!.size != 0
                    ? ((snapshot2.data!.size / snapshot.data!.size) * 100)
                    : 0);
                return brogress(
                  taskModel: widget.taskModel,
                  percento: percento,
                  all: first,
                  completed: second,
                );
              }
              return brogress(
                taskModel: widget.taskModel,
                percento: percento,
                all: first,
                completed: second,
              );
            },
          );
        }
        return brogress(
          taskModel: widget.taskModel,
          percento: percento,
          all: first,
          completed: second,
        );
      },
    );
  }
}

class brogress extends StatefulWidget {
  const brogress(
      {super.key,
      required this.taskModel,
      required this.percento,
      required this.completed,
      required this.all});
  final ProjectMainTaskModel taskModel;
  final double percento;
  final double completed;
  final double all;

  @override
  State<brogress> createState() => _brogressState();
}

class _brogressState extends State<brogress> {
  @override
  void initState() {
    super.initState();
    ismanagerStream();
  }

  ismanagerStream() async {
    ProjectModel? projectModel = await ProjectController()
        .getProjectById(id: widget.taskModel.projectId);
    Stream<DocumentSnapshot<ManagerModel>> managerModelStream =
        ManagerController().getMangerByIdStream(id: projectModel!.managerId);
    Stream<DocumentSnapshot<UserModel>> userModelStream;

    StreamSubscription<DocumentSnapshot<ManagerModel>> managerSubscription;
    StreamSubscription<DocumentSnapshot<UserModel>> userSubscription;

    managerSubscription = managerModelStream.listen((managerSnapshot) {
      ManagerModel manager = managerSnapshot.data()!;
      userModelStream =
          UserController().getUserWhereMangerIsStream(mangerId: manager.id);
      userSubscription = userModelStream.listen((userSnapshot) {
        UserModel user = userSnapshot.data()!;
        bool updatedIsManager;
        if (user.id != AuthProvider.instance.firebaseAuth.currentUser!.uid) {
          updatedIsManager = false;
        } else {
          updatedIsManager = true;
        }

        // Update the state and trigger a rebuild

        isManager.value = updatedIsManager;
      });
    });
  }

  RxBool isManager = false.obs;
  @override
  Widget build(BuildContext context) {
    String taskStatus = "";
    return Obx(() => isManager.value
        ? FocusedMenu(
            onClick: () {
              Get.to(() => SubTaskScreen(
                    projectId: widget.taskModel.projectId,
                    mainTaskId: widget.taskModel.id,
                  ));
            },
            deleteButton: () async {
              ProjectMainTaskController userTaskController =
                  Get.put(ProjectMainTaskController());
              await userTaskController.deleteProjectMainTask(
                  mainTaskId: widget.taskModel.id);
            },
            editButton: () {
              showAppBottomSheet(
                CreateUserTask(
                  addLateTask: (
                      {required int priority,
                      required String taskName,
                      required DateTime startDate,
                      required DateTime dueDate,
                      required String? desc,
                      required String color}) async {},
                  isUserTask: false,
                  checkExist: ({required String name}) async {
                    return TopController().existByTow(
                        reference: projectMainTasksRef,
                        value: name,
                        field: nameK,
                        value2: widget.taskModel.projectId,
                        field2: projectIdK);
                  },
                  addTask: (
                      {required int priority,
                      required String taskName,
                      required DateTime startDate,
                      required DateTime dueDate,
                      required String? desc,
                      required String color}) async {
                    ProjectMainTaskModel userTaskModel =
                        await ProjectMainTaskController()
                            .getProjectMainTaskById(id: widget.taskModel.id);
                    if ((userTaskModel.startDate != startDate ||
                            userTaskModel.endDate != dueDate) &&
                        taskStatus != statusNotStarted) {
                      CustomSnackBar.showError(AppConstants
                          .cannot_edit_time_of_done_or_doing_task_key.tr);
                      return;
                    }
                    if (startDate.isAfter(dueDate) ||
                        startDate.isAtSameMomentAs(dueDate)) {
                      CustomSnackBar.showError(AppConstants
                          .start_date_cannot_be_after_end_date_key.tr);
                      return;
                    }

                    try {
                      await ProjectMainTaskController().updateMainTask(
                          isfromback: false,
                          data: {
                            nameK: taskName,
                            descriptionK: desc,
                            startDateK: startDate,
                            endDateK: dueDate,
                            colorK: color,
                            importanceK: priority,
                          },
                          id: widget.taskModel.id);
                    } catch (e) {
                      CustomSnackBar.showError(e.toString());
                    }
                  },
                  isEditMode: true,
                  userTaskModel: widget.taskModel,
                ),
                isScrollControlled: true,
                popAndShow: false,
              );
            },
            widget: Opacity(
              opacity: getOpacity(widget.taskModel.importance),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor.fromHex(widget.taskModel.hexcolor)
                      .withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: HexColor.fromHex(widget.taskModel
                        .hexcolor), // Set the second color for the border
                    width: 6, // Adjust the width of the border as needed
                  ),
                ),
                height: 100,
                child: Stack(
                  children: [
                    // const Positioned(
                    //   top: 10,
                    //   right: 10,
                    //   child: Icon(Icons.task_alt_sharp),
                    // ),
                    Positioned(
                      top: 10,
                      bottom: 20,
                      right: 10,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  widget.taskModel
                                      .name!, // Use the name property of taskModel
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Utils.screenWidth * 0.06,
                                      color: Colors.black),
                                ),
                                AppSpaces.horizontalSpace10,
                                StreamBuilder(
                                  stream: StatusController()
                                      .getStatusByIdStream(
                                          idk: widget.taskModel.statusId)
                                      .asBroadcastStream(),
                                  builder: (context,
                                      AsyncSnapshot<
                                              DocumentSnapshot<StatusModel>>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      StatusModel statusModel =
                                          snapshot.data!.data() as StatusModel;
                                      taskStatus = statusModel.name!;
                                      return TaskWidget(
                                          status: getStatus(taskStatus));
                                    }
                                    return TaskWidget(
                                        status: getStatus(taskStatus));
                                  },
                                ),
                                AppSpaces.horizontalSpace10,
                                _buildStatus(widget.taskModel.importance),
                              ],
                            ),
                          ),
                          //AppSpaces.verticalSpace10,
                          Text(
                            '${widget.completed.toInt()} من أصل ${widget.all.toInt()} تم الانتهاء',
                            // Use the rating property of taskModel
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w500,
                              fontSize: Utils.screenWidth * 0.04,
                            ),
                          ),
                          //  AppSpaces.verticalSpace10,
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: Utils.screenHeight2 * 0.03,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.white),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: widget.percento.toInt(),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            gradient: LinearGradient(
                                              colors: [
                                                HexColor.fromHex("343840"),
                                                HexColor.fromHex("343840")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 100 - widget.percento.toInt(),
                                          child: const SizedBox())
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "${widget.percento}%", // Use the progressFigure property of taskModel
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          //AppSpaces.verticalSpace10,
                          buildLabel(
                              "${AppConstants.description_key.tr} : ${widget.taskModel.description}"),
                          buildLabel(
                              "${AppConstants.start_date_key.tr}:${formatDateTime(widget.taskModel.startDate)}"),
                          buildLabel(
                              "${AppConstants.end_date_key.tr}:${formatDateTime(widget.taskModel.endDate!)}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () {
              Get.to(SubTaskScreen(
                projectId: widget.taskModel.projectId,
                mainTaskId: widget.taskModel.id,
              ));
            },
            child: Opacity(
              opacity: getOpacity(widget.taskModel.importance),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor.fromHex(widget.taskModel.hexcolor)
                      .withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: HexColor.fromHex(widget.taskModel
                        .hexcolor), // Set the second color for the border
                    width: 5, // Adjust the width of the border as needed
                  ),
                ),
                height: 150,
                child: Stack(
                  children: [
                    // const Positioned(
                    //   top: 10,
                    //   right: 10,
                    //   child: Icon(Icons.task_alt_sharp),
                    // ),
                    Positioned(
                      top: 10,
                      bottom: 20,
                      right: 10,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  widget.taskModel
                                      .name!, // Use the name property of taskModel
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Utils.screenWidth * 0.06,
                                      color: Colors.black),
                                ),
                                AppSpaces.horizontalSpace10,
                                StreamBuilder(
                                  stream: StatusController()
                                      .getStatusByIdStream(
                                          idk: widget.taskModel.statusId)
                                      .asBroadcastStream(),
                                  builder: (context,
                                      AsyncSnapshot<
                                              DocumentSnapshot<StatusModel>>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      StatusModel statusModel =
                                          snapshot.data!.data() as StatusModel;
                                      taskStatus = statusModel.name!;
                                      return TaskWidget(
                                          status: getStatus(taskStatus));
                                    }
                                    return TaskWidget(
                                        status: getStatus(taskStatus));
                                  },
                                ),
                                AppSpaces.horizontalSpace10,
                                _buildStatus(widget.taskModel.importance),
                              ],
                            ),
                          ),
                          AppSpaces.verticalSpace10,
                          Text(
                            '${widget.completed.toInt()}  ${widget.all.toInt()}  ${AppConstants.is_completed_key.tr}', // Use the rating property of taskModel
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w500,
                              fontSize: Utils.screenWidth * 0.03,
                            ),
                          ),
                          AppSpaces.verticalSpace10,
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: 15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.white),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: widget.percento.toInt(),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            gradient: LinearGradient(
                                              colors: [
                                                HexColor.fromHex("343840"),
                                                HexColor.fromHex("343840")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 100 - widget.percento.toInt(),
                                          child: const SizedBox())
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "${widget.percento}%", // Use the progressFigure property of taskModel
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          AppSpaces.verticalSpace10,
                          buildLabel(
                              "${AppConstants.description_key.tr}: ${widget.taskModel.description}"),
                          buildLabel(
                              "${AppConstants.start_date_key.tr}:${formatDateTime(widget.taskModel.startDate)}"),
                          buildLabel(
                              "${AppConstants.end_date_key.tr}:${formatDateTime(widget.taskModel.endDate!)}"),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
  }

  double getOpacity(int importance) {
    double opacity = 1.0;

    switch (importance) {
      case 1:
        opacity = 0.3;
        break;
      case 2:
        opacity = 0.4;
        break;
      case 3:
        opacity = 0.7;
        break;
      case 4:
        opacity = 0.8;
        break;
      case 5:
        opacity = 1.0;
        break;
    }

    return opacity;
  }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "${AppConstants.today_key.tr} ${DateFormat('h:mma').format(dateTime)}";
    } else {
      return DateFormat('dd/MM/yy h:mma').format(dateTime);
    }
  }

  Widget buildLabel(String name) {
    return Text(
      name,
      style: GoogleFonts.lato(
          fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

Widget _buildStatus(int importance) {
  final maxOpacity = 0.9; // Maximum opacity for the task
  final minOpacity = 0.3; // Minimum opacity for the task
  final opacityStep =
      (maxOpacity - minOpacity) / 4; // Step size for opacity calculation
  return Row(
    children: List.generate(5, (index) {
      final isFilledStar = index < importance;
      final opacity = isFilledStar
          ? minOpacity + (importance - 1) * opacityStep
          : 1.0; // Set opacity to 1.0 for empty stars
      return Text("jj");

      // return GlowContainer(
      //   glowColor: isFilledStar
      //       ? Colors.yellow.withOpacity(opacity)
      //       : Colors.transparent,
      //   child: Icon(
      //     isFilledStar ? Icons.star_rate_rounded : Icons.star_border_rounded,
      //     color: Colors.yellow.withOpacity(opacity),
      //   ),
      // );
    }),
  );
}

TaskStatus getStatus(String status) {
  switch (status) {
    case statusNotDone:
      return TaskStatus.notDone;
    case statusDoing:
      return TaskStatus.inProgress;
    case statusDone:
      return TaskStatus.done;
    case statusNotStarted:
      return TaskStatus.notstarted;
    default:
      return TaskStatus.notDone;
  }
}

enum TaskStatus { notDone, inProgress, done, notstarted }

class TaskWidget extends StatelessWidget {
  final TaskStatus status;

  const TaskWidget({required this.status, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String statusText;

    switch (status) {
      case TaskStatus.notDone:
        icon = Icons.clear;
        color = Colors.red;
        statusText = AppConstants.not_done_key.tr;
        break;
      case TaskStatus.inProgress:
        icon = Icons.access_time;
        color = Colors.orange;
        statusText = AppConstants.in_progress_key.tr;
        break;
      case TaskStatus.done:
        icon = Icons.check;
        color = Colors.green;
        statusText = AppConstants.done_key.tr;
      case TaskStatus.notstarted:
        icon = Icons.schedule;
        color = Colors.grey;
        statusText = AppConstants.not_started_key.tr;
        break;
    }

    return Row(
      children: [
        // GlowContainer(
        //   glowColor: color.withOpacity(0.7),
        //   child: Icon(
        //     icon,
        //     color: color,
        //   ),
        // ),
        SizedBox(width: 8),
        // GlowContainer(
        //   glowColor: color.withOpacity(0.7),
        //   child: Text(
        //     statusText,
        //     style: TextStyle(
        //       color: color,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
