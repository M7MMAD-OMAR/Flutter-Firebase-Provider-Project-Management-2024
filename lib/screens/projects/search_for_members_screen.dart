import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/screens/Projects/search_for_member_screen.dart';
import 'package:project_management_muhmad_omar/constants/app_constans.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/userController.dart';
import 'package:project_management_muhmad_omar/controllers/waitingMamberController.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_member.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/services/auth_service.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/forms/search_box2_widget.dart';
import 'package:project_management_muhmad_omar/widgets/inactive_employee_card_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';

import 'package:project_management_muhmad_omar/services/notifications/notification_service.dart';
import 'package:project_management_muhmad_omar/widgets/dummy/profile_dummy_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/app_header_widget.dart';
import '../profile/profile_overview_screen.dart';
import 'add_user_to_team_screen.dart';

class SearchForMembers extends StatefulWidget {
  final bool newTeam;
  final TeamModel? teamModel;
  const SearchForMembers(
      {Key? searchForMembersKey,
      this.teamModel,
      required List<UserModel?>? users,
      required this.newTeam})
      : super(key: searchForMembersKey);
  static String search = "";
  @override
  State<SearchForMembers> createState() => _SearchForMembersState();
}

class _SearchForMembersState extends State<SearchForMembers> {
  final searchController = TextEditingController();
  final GlobalKey<_SearchForMembersState> searchForMembersKey =
      GlobalKey<_SearchForMembersState>();
  final DashboardMeetingDetailsScreenController addWatingMemberController =
      Get.find<DashboardMeetingDetailsScreenController>();

  void clearSearch() {
    setState(() {
      SearchForMembers.search = "";
      searchController.clear();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DarkRadialBackground(
            color: HexColor.fromHex("#181a1f"),
            position: "topLeft",
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      right: Utils.screenWidth * 0.04,
                      left: Utils.screenWidth * 0.04),
                  child: TaskezAppHeader(
                    title: AppConstants.search_members_key.tr,
                    widget: GestureDetector(
                      onTap: () async {
                        bool fcmStutas =
                            await FcmNotifications.getNotificationStatus();
                        Get.to(() => ProfileOverview(
                              isSelected: fcmStutas,
                            ));
                      },
                      child: StreamBuilder<DocumentSnapshot<UserModel>>(
                          stream: UserController().getUserByIdStream(
                              id: AuthService
                                  .instance.firebaseAuth.currentUser!.uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return ProfileDummy(
                              imageType: ImageType.Network,
                              color: Colors.white,
                              dummyType: ProfileDummyType.Image,
                              image: snapshot.data!.data()!.imageUrl,
                              scale: 1.2,
                            );
                          }),
                    ),
                  ),
                ),
                AppSpaces.verticalSpace40,
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecorationStyles.fadingGlory,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: DecoratedBox(
                        decoration: BoxDecorationStyles.fadingInnerDecor,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GetBuilder<SearchForMembersController>(
                            init: SearchForMembersController(),
                            builder: (controller) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SearchBox2(
                                  onClear: () {
                                    controller.clearSearch();
                                    // setState(() {
                                    //   searchController.clear();
                                    //   SearchForMembers.search = "";
                                    // });
                                  },
                                  controller: controller.searchController,
                                  placeholder: AppConstants.search_key.tr,
                                  onChanged: (value) {
                                    controller.searchQuery.value = value;
                                    controller.update();
                                    // setState(() {
                                    //   SearchForMembers.search = value;
                                    // });
                                  },
                                ),
                                AppSpaces.verticalSpace20,
                                Expanded(
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child:
                                        StreamBuilder<QuerySnapshot<UserModel>>(
                                      stream:
                                          UserController().getAllUsersStream(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                              snapshot.error.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.search,
                                                  //   Icons.heart_broken_outlined,
                                                  color: Colors.lightBlue,
                                                  size:
                                                      Utils.screenWidth * 0.27,
                                                ),
                                                //  AppSpaces.verticalSpace10,
                                                // const Center(
                                                //   child:
                                                //       CircularProgressIndicator(),
                                                // )
                                              ]);
                                        }

                                        List<UserModel> users = [];
                                        for (var element
                                            in snapshot.data!.docs) {
                                          users.add(element.data());
                                        }
                                        if (controller
                                                .searchQuery.value.isEmpty ||
                                            controller.searchController.text
                                                .isEmpty) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                AppConstants
                                                    .please_enter_username_to_search_key
                                                    .tr,
                                                style: TextStyle(
                                                    fontSize:
                                                        Utils.screenWidth *
                                                            0.07,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        }
                                        final filteredUsers =
                                            users.where((user) {
                                          final userName =
                                              user.userName?.toLowerCase() ??
                                                  '';

                                          return userName.contains(
                                                  controller.searchQuery
                                                      //   searchController.text
                                                      .toLowerCase()) &&
                                              user.id !=
                                                  AuthService
                                                      .instance
                                                      .firebaseAuth
                                                      .currentUser!
                                                      .uid;
                                        }).toList();
                                        if (filteredUsers.isEmpty) {
                                          return SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                //
                                                Icon(
                                                  Icons.search_off,
                                                  //   Icons.heart_broken_outlined,
                                                  color: Colors.red,
                                                  size:
                                                      Utils.screenWidth * 0.27,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: Utils
                                                            .screenWidth *
                                                        0.1, // Adjust the percentage as needed
                                                    vertical: Utils
                                                            .screenHeight *
                                                        0.05, // Adjust the percentage as needed
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      AppConstants
                                                          .no_user_found_with_username_key
                                                          .tr,
                                                      style:
                                                          GoogleFonts.fjallaOne(
                                                        color: Colors.white,
                                                        fontSize:
                                                            Utils.screenWidth *
                                                                0.1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }

                                        return ListView.builder(
                                          itemCount: filteredUsers.length,
                                          itemBuilder: (context, index) {
                                            final user = filteredUsers[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InactiveEmployeeCard(
                                                onTap: () async {
                                                  try {
                                                    if (!widget.newTeam) {
                                                      WaitingMemberModel
                                                          waitingMemberModel =
                                                          WaitingMemberModel(
                                                              teamIdParameter:
                                                                  widget
                                                                      .teamModel!
                                                                      .id,
                                                              idParameter:
                                                                  watingMamberRef
                                                                      .doc()
                                                                      .id,
                                                              userIdParameter:
                                                                  user.id,
                                                              createdAtParameter:
                                                                  DateTime
                                                                      .now(),
                                                              updatedAtParameter:
                                                                  DateTime
                                                                      .now());
                                                      await WaitingMamberController()
                                                          .addWaitingMamber(
                                                              waitingMemberModel:
                                                                  waitingMemberModel);
                                                    }
                                                    if (widget.newTeam) {
                                                      addWatingMemberController
                                                          .addUser(user);
                                                      addWatingMemberController
                                                          .update();
                                                    }
                                                    // CustomSnackBar.showSuccess(
                                                    //     "the user Invited Successfully");
                                                    addWatingMemberController
                                                        .update();
                                                    Get.close(1);
                                                    addWatingMemberController
                                                        .update();
                                                  } on Exception catch (e) {
                                                    CustomSnackBar.showError(
                                                        e.toString());
                                                  }
                                                },
                                                user: user,
                                                color: Colors.white,
                                                userImage: user.imageUrl,
                                                userName: user.name!,
                                                bio: user.bio ?? "",
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AppSpaces.verticalSpace20,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
