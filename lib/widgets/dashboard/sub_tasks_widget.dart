import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/manger_provider.dart';
import 'package:project_management_muhmad_omar/controllers/project_main_task_provider.dart';
import 'package:project_management_muhmad_omar/controllers/project_provider.dart';
import 'package:project_management_muhmad_omar/controllers/project_sub_task_provider.dart';
import 'package:project_management_muhmad_omar/controllers/status_provider.dart';
import 'package:project_management_muhmad_omar/controllers/team_member_provider.dart';
import 'package:project_management_muhmad_omar/controllers/team_provider.dart';
import 'package:project_management_muhmad_omar/controllers/top_provider.dart';
import 'package:project_management_muhmad_omar/controllers/user_provider.dart';
import 'package:project_management_muhmad_omar/controllers/waiting_sub_tasks_provider.dart';
import 'package:project_management_muhmad_omar/models/status_model.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_main_task_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_sub_task_model.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_sub_tasks_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/providers/task_provider.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/widgets/search_bar_animation_widget.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';
import 'package:project_management_muhmad_omar/services/notifications/notification_service.dart';
import 'package:project_management_muhmad_omar/services/types_services.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/sub_task_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/app_header_widget.dart';
import 'package:provider/provider.dart';

import '../snackbar/custom_snackber_widget.dart';
import 'create_sub_task_widget.dart';
import 'dashboard_add_icon_widget.dart';

enum TaskSortOption {
  name,
  createDate,
  updatedDate,
  startDate,
  endDate,
  importance
  // Add more sorting options if needed
}

class SubTaskScreen extends StatefulWidget {
  SubTaskScreen({Key? key, required this.mainTaskId, required this.projectId})
      : super(key: key);

  // ProjectModel projectModel;
  String mainTaskId;
  String projectId;

  @override
  State<SubTaskScreen> createState() => _SubTaskScreenState();
}

class _SubTaskScreenState extends State<SubTaskScreen> {
  TextEditingController editingController = TextEditingController();
  String search = "";
  TaskSortOption selectedSortOption = TaskSortOption.name;
  int crossAxisCount = 2; // Variable for crossAxisCount

  String _getSortOptionText(TaskSortOption option) {
    switch (option) {
      case TaskSortOption.name:
        return "الاسم";
      case TaskSortOption.updatedDate:
        return "تاريح التحديث";
      case TaskSortOption.createDate:
        return "تاريخ الإنشاء";
      case TaskSortOption.startDate:
        return 'تاريخ البدء';
      case TaskSortOption.endDate:
        return 'تاريخ الانتهاء';
      case TaskSortOption.importance:
        return 'الأهمية';
      // Add cases for more sorting options if needed
      default:
        return '';
    }
  }

  @override
  void initState() {
    ismanagerStream();
    super.initState();
  }

  ismanagerStream() async {
    ProjectModel? projectModel =
        await ProjectProvider().getProjectById(id: widget.projectId);
    Stream<DocumentSnapshot<ManagerModel>> managerModelStream =
        ManagerProvider().getMangerByIdStream(id: projectModel!.managerId);
    Stream<DocumentSnapshot<UserModel>> userModelStream;

    StreamSubscription<DocumentSnapshot<ManagerModel>> managerSubscription;
    StreamSubscription<DocumentSnapshot<UserModel>> userSubscription;

    managerSubscription = managerModelStream.listen((managerSnapshot) {
      ManagerModel manager = managerSnapshot.data()!;
      userModelStream =
          UserProvider().getUserWhereMangerIsStream(mangerId: manager.id);
      userSubscription = userModelStream.listen((userSnapshot) {
        UserModel user = userSnapshot.data()!;
        bool updatedIsManager;
        if (user.id != AuthProvider.firebaseAuth.currentUser!.uid) {
          updatedIsManager = false;
        } else {
          updatedIsManager = true;
        }

        // Update the state and trigger a rebuild
        context.read<TaskProvider>().setManager(updatedIsManager);
      });
    });
  }

  TaskProvider isManager = TaskProvider();
  bool sortAscending = true; // Variable for sort order
  void toggleSortOrder() {
    setState(() {
      sortAscending = !sortAscending; // Toggle the sort order
    });
  }

  void toggleCrossAxisCount() {
    setState(() {
      crossAxisCount =
          crossAxisCount == 2 ? 1 : 2; // Toggle the crossAxisCount value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return Visibility(
            visible: taskProvider.isManager,
            child: DashboardAddButton(
              iconTapped: (() {
                _createTask2();
              }),
            ),
          );
        },
      ),
      backgroundColor: HexColor.fromHex("#181a1f"),
      body: Column(
        children: [
          SafeArea(
            child: TaskezAppHeader(
              title: 'المهام الفرعية',
              widget: MySearchBarWidget(
                searchWord: 'المهام الفرعية',
                editingController: editingController,
                onChanged: (String value) {
                  setState(() {
                    search = value;
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(
                  right: Utils.screenWidth *
                      0.05, // Adjust the percentage as needed
                  left: Utils.screenWidth *
                      0.05, // Adjust the percentage as needed
                ),
                padding: EdgeInsets.only(
                  right: Utils.screenWidth *
                      0.04, // Adjust the 0percentage as needed
                  left: Utils.screenWidth *
                      0.04, // Adjust the percentage as needed
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<TaskSortOption>(
                  value: selectedSortOption,
                  onChanged: (TaskSortOption? newValue) {
                    setState(() {
                      selectedSortOption = newValue!;
                      // Implement the sorting logic here
                    });
                  },
                  items: TaskSortOption.values.map((TaskSortOption option) {
                    return DropdownMenuItem<TaskSortOption>(
                      value: option,
                      child: Text(
                        _getSortOptionText(option),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),

                  // Add extra styling
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: Utils.screenWidth * 0.07,
                  ),
                  underline: const SizedBox(),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    width: 2,
                    color: HexColor.fromHex("616575"),
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    color: Colors.white,
                  ),
                  onPressed: toggleSortOrder, // Toggle the sort order
                ),
              ),
              IconButton(
                icon: Icon(
                  size: Utils.screenWidth * 0.07,
                  Icons.grid_view,
                  color: Colors.white,
                ),
                onPressed:
                    toggleCrossAxisCount, // Toggle the crossAxisCount value
              ),
            ],
          ),
          SizedBox(height: Utils.screenHeight * 0.04),
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Utils.screenWidth * 0.04),
              child: StreamBuilder(
                stream: ProjectSubTaskProvider().getSubTasksForAMainTaskStream(
                    mainTaskId: widget.mainTaskId),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<ProjectSubTaskModel>>
                        snapshot) {
                  if (snapshot.hasData) {
                    int taskCount = snapshot.data!.docs.length;
                    List<ProjectSubTaskModel> list = [];
                    if (taskCount > 0) {
                      if (search.isNotEmpty) {
                        snapshot.data!.docs.forEach((element) {
                          ProjectSubTaskModel taskCategoryModel =
                              element.data();
                          if (taskCategoryModel.name!
                              .toLowerCase()
                              .contains(search)) {
                            list.add(taskCategoryModel);
                          }
                        });
                      } else {
                        snapshot.data!.docs.forEach((element) {
                          ProjectSubTaskModel taskCategoryModel =
                              element.data();
                          list.add(taskCategoryModel);
                        });
                      }
                      switch (selectedSortOption) {
                        case TaskSortOption.name:
                          list.sort((a, b) => a.name!.compareTo(b.name!));
                          break;
                        case TaskSortOption.createDate:
                          list.sort(
                              (a, b) => a.createdAt.compareTo(b.createdAt));
                          break;
                        case TaskSortOption.updatedDate:
                          list.sort(
                              (a, b) => b.updatedAt.compareTo(a.updatedAt));
                        case TaskSortOption.endDate:
                          list.sort((a, b) => b.endDate!.compareTo(a.endDate!));
                        case TaskSortOption.startDate:
                          list.sort(
                              (a, b) => b.startDate.compareTo(a.startDate));
                        case TaskSortOption.importance:
                          list.sort(
                              (a, b) => b.importance.compareTo(a.importance));
                          break;
                        // Add cases for more sorting options if needed
                      }
                      if (!sortAscending) {
                        list = list.reversed
                            .toList(); // Reverse the list for descending order
                      }
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              crossAxisCount, // Use the variable for crossAxisCount
                          mainAxisSpacing: 10,
                          mainAxisExtent: 290,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (_, index) {
                          return SubTaskCard(
                            task: list[index],
                            onPrimary: Colors.white,
                            primary: HexColor.fromHex(list[index].hexcolor),
                          );
                        },
                        itemCount: list.length,
                      );
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.lightMauveBackgroundColor,
                        backgroundColor: AppColors.primaryBackgroundColor,
                      ),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //
                      Icon(
                        Icons.search_off,
                        //   Icons.heart_broken_outlined,
                        color: Colors.red,
                        size: Utils.screenWidth * 0.30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Utils.screenWidth *
                              0.07, // Adjust the percentage as needed
                          vertical: Utils.screenHeight * 0.05,
                        ),
                        child: Center(
                          child: Text(
                            'لا توجد مهام فرعية',
                            style: GoogleFonts.fjallaOne(
                              color: Colors.white,
                              fontSize: Utils.screenWidth * 0.1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _createTask2() {
    showAppBottomSheet(
        popAndShow: false,
        CreateSubTask(
          userTaskModel: null,
          projectId: widget.projectId,
          addTask: (
              {required color,
              required desc,
              required dueDate,
              required priority,
              required startDate,
              required taskName,
              required String userIdAssignedTo}) async {
            if (startDate.isAfter(dueDate) ||
                startDate.isAtSameMomentAs(dueDate)) {
              CustomSnackBar.showError(
                  'لا يمكن أن يكون تاريخ البدء بعد تاريخ الانتهاء أو في نفس الوقت أو قبل التاريخ الحالي');
              return;
            }
            ProjectMainTaskModel mainTask = await ProjectMainTaskProvider()
                .getProjectMainTaskById(id: widget.mainTaskId);
            if (!startDate.isAfter(mainTask.startDate) ||
                !dueDate.isBefore(mainTask.endDate!)) {
              CustomSnackBar.showError(
                  "يجب أن تكون تواريخ بداية وانتهاء المهمة الفرعية بين تواريخ بداية وانتهاء المهمة الرئيسية");
              return;
            }
            UserModel userModel =
                await UserProvider().getUserById(id: userIdAssignedTo);
            StatusProvider statusController =
                Provider.of<StatusProvider>(context, listen: false);
            StatusModel statusModel = await statusController.getStatusByName(
                status: statusNotStarted);
            ProjectModel? projectModel =
                await ProjectProvider().getProjectById(id: widget.projectId);

            String? s = projectModel?.teamId!;
            TeamModel teamModel = await TeamProvider().getTeamById(id: s ?? "");
            TeamMemberModel teamMemberModel = await TeamMemberProvider()
                .getMemberByTeamIdAndUserId(
                    teamId: teamModel.id, userId: userIdAssignedTo);
            ProjectSubTaskModel projectSubTaskModel = ProjectSubTaskModel(
                assignedToParameter: teamMemberModel.id,
                mainTaskIdParameter: widget.mainTaskId,
                hexColorParameter: color,
                projectIdParameter: widget.projectId,
                descriptionParameter: desc!,
                idParameter: projectMainTasksRef.doc().id,
                nameParameter: taskName,
                statusIdParameter: statusModel.id,
                importanceParameter: priority,
                createdAtParameter: DateTime.now(),
                updatedAtParameter: DateTime.now(),
                startDateParameter: startDate,
                endDateParameter: dueDate);
            // await ProjectSubTaskController()
            //     .addProjectSubTask(projectsubTaskModel: userTaskModel);
            String waitingid = watingSubTasksRef.doc().id;
            WaitingSubTaskModel waitingSubTaskModel = WaitingSubTaskModel(
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                id: waitingid,
                projectSubTaskModel: projectSubTaskModel);
            WaitingSubTasksProvider waitingSubTaskController =
                Provider.of<WaitingSubTasksProvider>(context);

            bool overlapped = false;
            int over = 0;
            List<ProjectSubTaskModel> list = await ProjectSubTaskProvider()
                .getMemberSubTasks(memberId: teamMemberModel.id);
            for (ProjectSubTaskModel existingTask in list) {
              if (projectSubTaskModel.startDate
                      .isBefore(existingTask.endDate!) &&
                  projectSubTaskModel.endDate!
                      .isAfter(existingTask.startDate)) {
                overlapped = true;
                over += 1;
              }
            }
            if (overlapped) {
              final GlobalKey<NavigatorState> _navigatorKey =
                  GlobalKey<NavigatorState>();
              showErrorDialog(
                  title: 'خطأ في وقت المهمة',
                  middleText:
                      "هناك ${over} التي تبدأ في هذا الوقت \n للمستخدم المعين \n هل ترغب في تعيين المهمة بأي طريقة؟",
                  onConfirm: () async {
                    await waitingSubTaskController.addWatingSubTask(
                        waitingSubTaskModel: waitingSubTaskModel);
                    FcmNotificationsProvider fcmNotifications =
                        Provider.of<FcmNotificationsProvider>(context);
                    await fcmNotifications.sendNotificationAsJson(
                        fcmTokens: userModel.tokenFcm,
                        title: 'لديك مهمة',
                        data: {"id": waitingid},
                        body:
                            "المشروع ${projectModel?.name}. المهمة بعنوان ${projectSubTaskModel.name}. يرجى مراجعة تفاصيل المهمة واتخاذ الإجراءات اللازمة.",
                        type: NotificationType.taskRecieved);
                    CustomSnackBar.showSuccess(
                        "مهمة ${taskName}  تم إرسالها بنجاح إلى العضو");
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  onCancel: () {
                    // SystemNavigator.pop();
                    _navigatorKey.currentState?.pop();
                  });
            } else {
              await waitingSubTaskController.addWatingSubTask(
                  waitingSubTaskModel: waitingSubTaskModel);
              FcmNotificationsProvider fcmNotifications =
                  Provider.of<FcmNotificationsProvider>(context);
              await fcmNotifications.sendNotificationAsJson(
                  fcmTokens: userModel.tokenFcm,
                  title: 'لديك مهمة',
                  data: {"id": waitingid},
                  body:
                      " ${projectModel?.name}. المهمة بعنوان ${projectSubTaskModel.name}. يرجى مراجعة تفاصيل المهمة واتخاذ الإجراءات اللازمة.",
                  type: NotificationType.taskRecieved);
              CustomSnackBar.showSuccess(
                  "مهمة ${taskName} تم إرسالها بنجاح إلى العضو");
              Navigator.pop(context);
            }
            // await waitingSubTaskController.addWatingSubTask(
            //     waitingSubTaskModel: waitingSubTaskModel);
            // FcmNotifications fcmNotifications = Get.put(FcmNotifications());
            // await fcmNotifications.sendNotificationAsJson(
            //     fcmTokens: userModel.tokenFcm,
            //     title: "you have a task ",
            //     data: {"id": waitingid},
            //     body:
            //         "the project ${projectModel.name}. The task is titled ${projectSubTaskModel.name}. Please review the task details and take necessary action.",
            //     type: NotificationType.taskRecieved);
            // CustomSnackBar.showSuccess(
            //     "task ${taskName} sended to member successfully");
            // Navigator.pop(context);
          },
          checkExist: ({required String name}) async {
            bool s;
            s = await TopProvider().existByTow(
                reference: projectSubTasksRef,
                value: widget.mainTaskId,
                field: mainTaskIdK,
                value2: name,
                field2: nameK);
            s = await TopProvider().existByTow(
                reference: watingSubTasksRef,
                value: widget.mainTaskId,
                field: "subTask.$mainTaskIdK",
                value2: name,
                field2: "subTask.$nameK");
            return s;
          },
          isEditMode: false,
        ));
  }
}
