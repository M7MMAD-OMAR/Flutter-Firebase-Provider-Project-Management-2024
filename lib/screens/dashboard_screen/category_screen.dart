import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/categoryController.dart';
import 'package:project_management_muhmad_omar/controllers/user_task_controller.dart';
import 'package:project_management_muhmad_omar/models/task/user_task_category_model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/widgets/search_bar_animation_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/app_header_widget.dart';
import 'package:project_management_muhmad_omar/widgets/user/category_card_vertical_widget.dart';
import 'package:provider/provider.dart';

enum CategorySortOption {
  name,
  createDate,
  updatedDate,
}

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  static String id = "/NotificationScreen";

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController editingController = TextEditingController();
  String search = "";
  CategorySortOption selectedSortOption = CategorySortOption.name;
  int crossAxisCount = 2;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late TaskCategoryController taskCategoryController;
  late UserTaskController taskController;

  @override
  void initState() {
    super.initState();

    taskCategoryController =
        Provider.of<TaskCategoryController>(context, listen: false);
    taskController = Provider.of<UserTaskController>(context, listen: false);
  }

  String _getSortOptionText(CategorySortOption option) {
    switch (option) {
      case CategorySortOption.name:
        return "الاسم";
      case CategorySortOption.updatedDate:
        return "تاريح التحديث";
      case CategorySortOption.createDate:
        return "تاريخ الإنشاء";

      default:
        return '';
    }
  }

  bool sortAscending = true;
  void toggleSortOrder() {
    setState(() {
      sortAscending = !sortAscending;
    });
  }

  void toggleCrossAxisCount() {
    setState(() {
      crossAxisCount = crossAxisCount == 2 ? 1 : 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: TaskezAppHeader(
            title: "الفئات",
            widget: MySearchBarWidget(
              searchWord: "الفئات",
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
                right: Utils.screenWidth * 0.05,
                left: Utils.screenWidth * 0.05,
              ),
              padding: EdgeInsets.only(
                right: Utils.screenWidth * 0.04,
                left: Utils.screenWidth * 0.04,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<CategorySortOption>(
                value: selectedSortOption,
                onChanged: (CategorySortOption? newValue) {
                  setState(() {
                    selectedSortOption = newValue!;
                  });
                },
                items:
                    CategorySortOption.values.map((CategorySortOption option) {
                  return DropdownMenuItem<CategorySortOption>(
                    value: option,
                    child: Text(
                      _getSortOptionText(option),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
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
                  size: Utils.screenWidth * 0.07,
                  sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  color: Colors.white,
                ),
                onPressed: toggleSortOrder,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.grid_view,
                color: Colors.white,
              ),
              onPressed: toggleCrossAxisCount,
            ),
          ],
        ),
        SizedBox(height: Utils.screenHeight * 0.04),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Utils.screenWidth * 0.04),
            child: StreamBuilder(
              stream: taskCategoryController.getUserCategoriesStream(
                userId: AuthProvider.firebaseAuth.currentUser!.uid,
              ),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<UserTaskCategoryModel>>
                      snapshot) {
                if (snapshot.hasData) {
                  int taskCount = snapshot.data!.docs.length;
                  List<UserTaskCategoryModel> list = [];

                  if (taskCount > 0) {
                    if (search.isNotEmpty) {
                      for (var element in snapshot.data!.docs) {
                        UserTaskCategoryModel taskModel = element.data();
                        if (taskModel.name!.toLowerCase().contains(search)) {
                          list.add(taskModel);
                        }
                      }
                    } else {
                      for (var element in snapshot.data!.docs) {
                        UserTaskCategoryModel taskCategoryModel =
                            element.data();

                        list.add(taskCategoryModel);
                      }
                    }
                    switch (selectedSortOption) {
                      case CategorySortOption.name:
                        list.sort((a, b) => a.name!.compareTo(b.name!));
                        break;
                      case CategorySortOption.createDate:
                        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                        break;
                      case CategorySortOption.updatedDate:
                        list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
                    }
                    if (!sortAscending) {
                      list = list.reversed.toList();
                    }
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 220,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (_, index) {
                        return CategoryCardVertical(
                          userTaskCategoryModel: list[index],
                        );
                      },
                      itemCount: list.length,
                    );
                  }
                }
                if (!snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        color: Colors.lightBlue,
                        size: Utils.screenWidth * 0.27,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Utils.screenWidth * 0.1,
                          vertical: Utils.screenHeight * 0.05,
                        ),
                        child: Center(
                          child: Text(
                            "جاري التحميل...",
                            style: GoogleFonts.fjallaOne(
                              color: Colors.white,
                              fontSize: Utils.screenWidth * 0.1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
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
                    Icon(
                      Icons.search_off,
                      color: Colors.red,
                      size: Utils.screenWidth * 0.30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Utils.screenWidth * 0.02,
                        vertical: Utils.screenHeight * 0.05,
                      ),
                      child: Text(
                        "لم يتم العثور على أي فئات",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: Utils.screenWidth * 0.095,
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
    );
  }
}
