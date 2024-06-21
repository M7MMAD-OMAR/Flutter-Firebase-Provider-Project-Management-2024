import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/user_provider.dart';
import 'package:project_management_muhmad_omar/controllers/waiting_member_provider.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_member.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/dashboard_meeting_details_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/search_for_member_provider.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';
import 'package:project_management_muhmad_omar/services/notifications/notification_service.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dummy/profile_dummy_widget.dart';
import 'package:project_management_muhmad_omar/widgets/forms/search_box2_widget.dart';
import 'package:project_management_muhmad_omar/widgets/inactive_employee_card_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/app_header_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';
import 'package:provider/provider.dart';

import '../profile/profile_overview_screen.dart';

class SearchForMembersScreen extends StatefulWidget {
  final bool newTeam;
  final TeamModel? teamModel;

  const SearchForMembersScreen(
      {Key? searchForMembersKey,
      this.teamModel,
      required List<UserModel?>? users,
      required this.newTeam})
      : super(key: searchForMembersKey);
  static String search = "";

  @override
  State<SearchForMembersScreen> createState() => _SearchForMembersScreenState();
}

class _SearchForMembersScreenState extends State<SearchForMembersScreen> {
  final searchController = TextEditingController();
  final GlobalKey<_SearchForMembersScreenState> searchForMembersKey =
      GlobalKey<_SearchForMembersScreenState>();
  final DashboardMeetingDetailsProvider dashboardMeetingDetails =
      Provider.of<DashboardMeetingDetailsProvider>(context);

  void clearSearch() {
    setState(() {
      SearchForMembersScreen.search = "";
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
                    title: 'البحث عن عضو',
                    widget: GestureDetector(
                      onTap: () async {
                        bool fcmStutas = await FcmNotificationsProvider
                            .getNotificationStatus();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProfileOverviewScreen(
                                      isSelected: fcmStutas,
                                    )));
                      },
                      child: StreamBuilder<DocumentSnapshot<UserModel>>(
                          stream: UserProvider().getUserByIdStream(
                              id: AuthProvider.firebaseAuth.currentUser!.uid),
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
                          child: Consumer<SearchForMembersProvider>(
                            // init: SearchForMembersProvider(),
                            builder: (context, controller, child) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SearchBox2(
                                  onClear: () {
                                    controller.clearSearch();
                                  },
                                  controller: controller.searchController,
                                  placeholder: 'بحث ....',
                                  onChanged: (value) {
                                    controller.searchQuery = value;
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
                                          UserProvider().getAllUsersStream(),
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
                                                  color: Colors.lightBlue,
                                                  size:
                                                      Utils.screenWidth * 0.27,
                                                ),
                                              ]);
                                        }

                                        List<UserModel> users = [];
                                        for (var element
                                            in snapshot.data!.docs) {
                                          users.add(element.data());
                                        }
                                        if (controller.searchQuery.isEmpty ||
                                            controller.searchController.text
                                                .isEmpty) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                'الرجاء إدخال اسم مستخدم للبحث عنه',
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

                                          return userName.contains(controller
                                                  .searchQuery
                                                  .toLowerCase()) &&
                                              user.id !=
                                                  AuthProvider.firebaseAuth
                                                      .currentUser!.uid;
                                        }).toList();
                                        if (filteredUsers.isEmpty) {
                                          return SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.search_off,
                                                  color: Colors.red,
                                                  size:
                                                      Utils.screenWidth * 0.27,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Utils.screenWidth * 0.1,
                                                    vertical:
                                                        Utils.screenHeight *
                                                            0.05,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'لم يتم العثور على أي مستخدم بهذا الاسم',
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
                                              child: InactiveEmployeeCardWidget(
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
                                                      await WaitingMemberProvider()
                                                          .addWaitingMamber(
                                                              waitingMemberModel:
                                                                  waitingMemberModel);
                                                    }
                                                    if (widget.newTeam) {
                                                      dashboardMeetingDetails
                                                          .addUser(user);
                                                    }

                                                    Navigator.of(context).pop();
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
