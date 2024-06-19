import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/categoryController.dart';
import 'package:project_management_muhmad_omar/controllers/statusController.dart';
import 'package:project_management_muhmad_omar/controllers/user_task_controller.dart';
import 'package:project_management_muhmad_omar/models/status_model.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';
import 'package:project_management_muhmad_omar/widgets/user/tasks_tasks_widget.dart';

import '../../constants/back_constants.dart';
import '../../controllers/topController.dart';
import '../../models/task/user_task_category_model.dart';
import '../../models/user/user_task_Model.dart';
import '../../services/collections_refrences.dart';
import '../Dashboard/create_user_task_widget.dart';
import '../snackbar/custom_snackber_widget.dart';
import 'focused_menu_item_widget.dart';

enum TaskStatus { notDone, inProgress, done, notStarted }

class TaskWidget extends StatelessWidget {
  final TaskStatus status;

  const TaskWidget({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String statusText;

    switch (status) {
      case TaskStatus.notDone:
        icon = Icons.clear;
        color = Colors.red;
        statusText = 'غير مكتمل';
        break;
      case TaskStatus.inProgress:
        icon = Icons.access_time;
        color = Colors.orange;
        statusText = 'قيد التنفيذ';
        break;
      case TaskStatus.done:
        icon = Icons.check;
        color = Colors.green;
        statusText = 'تم';
        break;
      case TaskStatus.notStarted:
        icon = Icons.schedule;
        color = Colors.grey;
        statusText = 'لم تبدأ بعد';
        break;
    }

    return Row(
      children: [
        Icon(
          icon,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          statusText,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class CardTask extends StatefulWidget {
  CardTask({
    required this.task,
    required this.primary,
    required this.onPrimary,
    required this.userTaskCategoryId,
    this.userFatherId,
    super.key,
  });
  final String userTaskCategoryId;
  DocumentReference? userFatherId;
  final UserTaskModel task;
  final Color primary;
  final Color onPrimary;

  @override
  State<CardTask> createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask> {
  String taskStatus = "";
  @override
  void initState() {
    super.initState();
    getCat();
  }

  getCat() async {
    userTaskCategoryModel = await TaskCategoryController()
        .getCategoryById(id: widget.userTaskCategoryId);
  }

  UserTaskCategoryModel? userTaskCategoryModel;
  @override
  Widget build(BuildContext context) {
    StatusController statusController = Get.put(StatusController());
    StatusModel? statusModel;

    taskStatus = " ";
    return FocusedMenu(
      onClick: () async {
        DocumentReference documentReference;

        DocumentSnapshot snapshot = await statusController.getDocById(
          reference: usersTasksRef,
          id: widget.task.id,
        );
        documentReference = snapshot.reference;
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => FatherTasks(
              categoryModel: userTaskCategoryModel!,
              fatherTaskModel: widget.task,
              documentReference: documentReference,
            ),
          ),
        );
        //
      },
      deleteButton: () async {
        UserTaskController userTaskController = Get.put(UserTaskController());
        await userTaskController.deleteUserTask(id: widget.task.id);
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
            isUserTask: true,
            checkExist: ({required String name}) async {
              if (widget.userFatherId != null) {
                return TopController().existByTow(
                    reference: usersTasksRef,
                    value: name,
                    field: nameK,
                    value2: widget.userFatherId,
                    field2: taskFatherIdK);
              } else {
                return TopController().existByTow(
                    reference: usersTasksRef,
                    value: name,
                    field: nameK,
                    value2: widget.userTaskCategoryId,
                    field2: folderIdK);
              }
            },
            addTask: (
                {required int priority,
                required String taskName,
                required DateTime startDate,
                required DateTime dueDate,
                required String? desc,
                required String color}) async {
              UserTaskModel userTaskModel = await UserTaskController()
                  .getUserTaskById(id: widget.task.id);
              if ((userTaskModel.startDate != startDate ||
                      userTaskModel.endDate != dueDate) &&
                  taskStatus != statusNotStarted) {
                CustomSnackBar.showError(
                    'لا يمكن تحرير وقت بدء وانتهاء المهمة التي تم الانتهاء منها أو التي قيد التنفيذ');
                return;
              }
              if (startDate.isAfter(dueDate) ||
                  startDate.isAtSameMomentAs(dueDate)) {
                CustomSnackBar.showError(
                    'لا يمكن أن يكون تاريخ البدء بعد تاريخ الانتهاء');
                return;
              }

              try {
                await UserTaskController().updateUserTask(
                    isfromback: false,
                    data: {
                      nameK: taskName,
                      descriptionK: desc,
                      colorK: color,
                      startDateK: startDate,
                      endDateK: dueDate,
                      importanceK: priority,
                    },
                    id: widget.task.id);
              } catch (e) {
                CustomSnackBar.showError(e.toString());
              }
            },
            isEditMode: true,
            userTaskModel: widget.task,
          ),
          isScrollControlled: true,
          popAndShow: false,
        );
      },
      widget: Opacity(
        opacity: getOpacity(widget.task.importance),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.primary, widget.primary.withOpacity(.7)],
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                ),
              ),
              child: _BackgroundDecoration(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildLabelWithStyle(widget.task.name!,
                              textStyle: AppTextStyles.header2),
                          _buildStatus(widget.task.importance),
                        ],
                      ),
                      const SizedBox(height: 20),
                      buildLabel("وصف : ${widget.task.description}"),
                      StreamBuilder(
                        stream: statusController
                            .getStatusByIdStream(idk: widget.task.statusId)
                            .asBroadcastStream(),
                        //.asBroadcastStream(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot<StatusModel>>
                                snapshot) {
                          if (snapshot.hasData) {
                            statusModel = snapshot.data!.data() as StatusModel;
                            taskStatus = statusModel!.name!;
                            return TaskWidget(status: getStatus(taskStatus));
                          }
                          return TaskWidget(status: getStatus(taskStatus));
                        },
                      ),
                      buildLabel(
                          "تاريخ البدء : ${formatDateTime(widget.task.startDate)}"),
                      buildLabel(
                          "تاريخ الانتهاء : ${formatDateTime(widget.task.endDate!)}"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
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

  TaskStatus getStatus(String status) {
    switch (status) {
      case statusNotDone:
        return TaskStatus.notDone;
      case statusDoing:
        return TaskStatus.inProgress;
      case statusDone:
        return TaskStatus.done;
      case statusNotStarted:
        return TaskStatus.notStarted;

      default:
        return TaskStatus.notDone;
    }
  }

  Widget _buildStatus(int importance) {
    const maxOpacity = 0.9; // Maximum opacity for the task
    const minOpacity = 0.3; // Minimum opacity for the task
    const opacityStep =
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

  // Widget _buildStatus(int importance) {
  //   final maxOpacity = 1.0; // Maximum opacity for the task
  //   final minOpacity = 0.5; // Minimum opacity for the task
  //   final opacityStep =
  //       (maxOpacity - minOpacity) / 5; // Step size for opacity calculation

  //   return Row(
  //     children: List.generate(5, (index) {
  //       final opacity = minOpacity +
  //           (index + 1) * opacityStep; // Calculate the opacity value

  //       return Opacity(
  //         opacity: opacity,
  //         child: Icon(
  //           index < importance ? Icons.star : Icons.star_border_rounded,
  //           color: Colors.yellow,
  //         ),
  //       );
  //     }),
  //   );
  // }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "اليوم ${DateFormat('h:mma').format(dateTime)}";
    } else {
      return DateFormat('dd/MM/yy h:mma').format(dateTime);
    }
  }

  Widget buildLabel(
    String name,
  ) {
    return Text(
      name,
      style: AppTextStyles.header2_2,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildLabelWithStyle(String name, {required TextStyle? textStyle}) {
    return Text(
      name,
      style: textStyle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration({required this.child, Key? key})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Transform.translate(
            offset: const Offset(25, -25),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(.1),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Transform.translate(
            offset: const Offset(-70, 70),
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(.1),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
