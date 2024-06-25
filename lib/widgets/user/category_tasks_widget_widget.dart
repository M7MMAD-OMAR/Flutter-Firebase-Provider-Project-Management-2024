import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/models/status_model.dart';
import 'package:project_management_muhmad_omar/models/task/user_task_category_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_task_Model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/providers/status_provider.dart';
import 'package:project_management_muhmad_omar/providers/task_category_provider.dart';
import 'package:project_management_muhmad_omar/providers/top_provider.dart';
import 'package:project_management_muhmad_omar/providers/user_task_provider.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/widgets/search_bar_animation_widget.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';
import 'package:project_management_muhmad_omar/widgets/user/task_widget.dart';
import 'package:provider/provider.dart';

import '../Dashboard/create_user_task_widget.dart';
import '../Dashboard/dashboard_add_icon_widget.dart';
import '../Navigation/app_header_widget.dart';
import '../snackbar/custom_snackber_widget.dart';

enum TaskSortOption {
  name,
  createDate,
  updatedDate,
  startDate,
  endDate,
  importance
  // Add more sorting options if needed
}

class CategoryTasks extends StatefulWidget {
  CategoryTasks({super.key, required this.categoryModel});

  UserTaskCategoryModel categoryModel;

  @override
  State<CategoryTasks> createState() => _CategoryTasksState();
}

class _CategoryTasksState extends State<CategoryTasks> {
  TaskCategoryProvider userTaskCategoryController =
      Provider.of<TaskCategoryProvider>(context, listen: false);
  TextEditingController editingController = TextEditingController();
  UserTaskProvider taskController =
      Provider.of<UserTaskProvider>(context, listen: false);
  String search = "";
  TaskSortOption selectedSortOption = TaskSortOption.name;
  int crossAxisCount = 1; // Variable for crossAxisCount

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

  void toggleCrossAxisCount() {
    setState(() {
      crossAxisCount =
          crossAxisCount == 1 ? 2 : 1; // Toggle the crossAxisCount value
    });
  }

  bool sortAscending = true; // Variable for sort order
  void toggleSortOrder() {
    setState(() {
      sortAscending = !sortAscending; // Toggle the sort order
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: DashboardAddButton(
        iconTapped: (() {
          _createTask2();
        }),
      ),
      backgroundColor: HexColor.fromHex("#181a1f"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
              child: TaskezAppHeader(
            title: widget.categoryModel.name!.toUpperCase(),
            widget: MySearchBarWidget(
              searchWord: widget.categoryModel.name!.toUpperCase() + "المهام",
              editingController: editingController,
              onChanged: (String value) {
                setState(() {
                  //
                  search = value;
                });
              },
            ),
          )
              // )
              // TaskezAppHeader2(
              //   title: widget.categoryModel.name!.toUpperCase() +
              //       AppConstants.tasks_key.tr,
              //   widget: MySearchBarWidget(
              //     searchWord: widget.categoryModel.name!.toUpperCase() +
              //         AppConstants.tasks_key.tr,
              //     editingController: editingController,
              //     onChanged: (String value) {
              //       setState(() {
              //         //
              //         search = value;
              //       });
              //     },
              //   ),
              // ),
              ),
          AppSpaces.verticalSpace20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20.0, left: 20.0),
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
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
                    size: Utils.screenWidth * 0.075,
                  ),
                  underline: const SizedBox(),
                ),
              ),
              IconButton(
                icon: Icon(
                  sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  color: Colors.white,
                ),
                onPressed: toggleSortOrder, // Toggle the sort order
              ),
              // IconButton(
              //   icon: Icon(
              //     Icons.grid_view,
              //     color: Colors.white,
              //   ),
              //   onPressed:
              //       toggleCrossAxisCount, // Toggle the crossAxisCount value
              // ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  right: Utils.screenWidth * 0.04,
                  left: Utils.screenWidth * 0.04),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: StreamBuilder(
                  stream: taskController.getCategoryTasksStream(
                    folderId: widget.categoryModel.id,
                  ),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<UserTaskModel>> snapshot) {
                    if (snapshot.hasData) {
                      int taskCount = snapshot.data!.docs.length;
                      List<UserTaskModel> list = [];
                      if (taskCount > 0) {
                        if (search.isNotEmpty) {
                          for (var element in snapshot.data!.docs) {
                            UserTaskModel taskModel = element.data();
                            if (taskModel.name!
                                    .toLowerCase()
                                    .contains(search) &&
                                taskModel.taskFatherId == null) {
                              list.add(taskModel);
                            }
                          }
                        } else {
                          for (var element in snapshot.data!.docs) {
                            UserTaskModel taskCategoryModel = element.data();
                            if (taskCategoryModel.taskFatherId == null) {
                              list.add(taskCategoryModel);
                            }
                          }
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
                            list.sort(
                                (a, b) => b.endDate!.compareTo(a.endDate!));
                          case TaskSortOption.startDate:
                            list.sort(
                                (a, b) => b.startDate.compareTo(a.startDate));
                            break;
                          case TaskSortOption.importance:
                            list.sort(
                                (a, b) => a.importance.compareTo(b.importance));
                            break;
                          // Add cases for more sorting options if needed
                        }
                        //
                        if (!sortAscending) {
                          list = list.reversed
                              .toList(); // Reverse the list for descending order
                        }
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 220,
                            crossAxisSpacing: 10,
                          ),
                          itemBuilder: (_, index) {
                            return CardTask(
                              userTaskCategoryId: widget.categoryModel.id,
                              onPrimary: Colors.white,
                              primary: HexColor.fromHex(list[index].hexcolor),
                              task: list[index],
                            );
                          },
                          itemCount: list.length,
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.task,
                                size: Utils.screenWidth * 0.3,
                                color: HexColor.fromHex("#999999"),
                              ),
                              AppSpaces.verticalSpace10,
                              Text(
                                'لم يتم العثور على أي مهام',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: HexColor.fromHex("#999999"),
                                    fontSize: Utils.screenWidth * 0.05,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              AppSpaces.verticalSpace10,
                              Text(
                                'أضف مهمة للبدء',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: HexColor.fromHex("#999999"),
                                    fontSize: Utils.screenWidth * 0.05,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              AppSpaces.verticalSpace10,
                            ],
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _createTask2() {
    showAppBottomSheet(
      CreateUserTask(
        addLateTask: (
            {required int priority,
            required String taskName,
            required DateTime startDate,
            required DateTime dueDate,
            required String? desc,
            required String color}) async {
          if (startDate.isAfter(dueDate) ||
              startDate.isAtSameMomentAs(dueDate)) {
            CustomSnackBar.showError(
                'لا يمكن أن يكون تاريخ البدء بعد تاريخ الانتهاء');
            return;
          }

          try {
            StatusProvider statusController =
                Provider.of<StatusProvider>(context, listen: false);
            StatusModel statusModel = await statusController.getStatusByName(
                status: statusNotStarted);

            UserTaskModel userTaskModel = UserTaskModel.firestoreConstructor(
                colorParameter: color,
                userId: AuthProvider.firebaseAuth.currentUser!.uid,
                folderId: widget.categoryModel.id,
                taskFatherId: null,
                descriptionParameter: desc!,
                idParameter: usersTasksRef.doc().id,
                nameParameter: taskName,
                statusIdParameter: statusModel.id,
                importanceParameter: priority,
                createdAtParameter: DateTime.now(),
                updatedAtParameter: DateTime.now(),
                startDateParameter: startDate,
                endDateParameter: dueDate);
            await UserTaskProvider()
                .addUserLateTask(userTaskModel: userTaskModel);
            CustomSnackBar.showSuccess(
                "المهمة ${userTaskModel.name} تمت الإضافة بنجاح");
            Navigator.pop(context);
          } catch (e) {
            CustomSnackBar.showError("حدث خطأ ما , حاول لاحقا");
          }
        },
        isUserTask: true,
        checkExist: ({required String name}) async {
          return TopProvider().existByTow(
              reference: usersTasksRef,
              value: name,
              field: nameK,
              value2: widget.categoryModel.id,
              field2: folderIdK);
        },
        addTask: (
            {required int priority,
            required String taskName,
            required DateTime startDate,
            required DateTime dueDate,
            required String? desc,
            required String color}) async {
          if (startDate.isAfter(dueDate) ||
              startDate.isAtSameMomentAs(dueDate)) {
            CustomSnackBar.showError(
                'لا يمكن أن يكون تاريخ البدء بعد تاريخ الانتهاء');
            return;
          }
          try {
            StatusProvider statusController =
                Provider.of<StatusProvider>(context, listen: false);
            StatusModel statusModel = await statusController.getStatusByName(
                status: statusNotStarted);

            UserTaskModel userTaskModel = UserTaskModel(
                hexColorParameter: color,
                userIdParameter: AuthProvider.firebaseAuth.currentUser!.uid,
                folderIdParameter: widget.categoryModel.id,
                taskFatherIdParameter: null,
                descriptionParameter: desc!,
                idParameter: usersTasksRef.doc().id,
                nameParameter: taskName,
                statusIdParameter: statusModel.id,
                importanceParameter: priority,
                createdAtParameter: DateTime.now(),
                updatedAtParameter: DateTime.now(),
                startDateParameter: startDate,
                endDateParameter: dueDate);
            await UserTaskProvider().adddUserTask(userTaskModel: userTaskModel);
          } catch (e) {
            CustomSnackBar.showError("حدث خطأ ما , حاول لاحقا");
          }
        },
        isEditMode: false,
      ),
      isScrollControlled: true,
      popAndShow: false,
    );
  }
}
