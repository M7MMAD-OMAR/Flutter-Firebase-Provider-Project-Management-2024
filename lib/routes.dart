import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/auth_screen.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/email_address_screen.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/forgot_password_screen/reset_password_screen.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/login_screen.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/signup_screen.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/verify_email_address_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/category_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/dashboard_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/dashboard_tab_screens/overview_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/dashboard_tab_screens/productivity_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/invitions_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/projects_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/select_my_teams_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/select_team_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/timeline_screen.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/onboarding_carousel_screen.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/onboarding_start_screen.dart';
import 'package:project_management_muhmad_omar/screens/profile/edit_profile_screen.dart';
import 'package:project_management_muhmad_omar/screens/profile/my_profile_screen.dart';
import 'package:project_management_muhmad_omar/screens/profile/my_team_screen.dart';
import 'package:project_management_muhmad_omar/screens/profile/profile_overview_screen.dart';
import 'package:project_management_muhmad_omar/screens/profile/team_details_screen.dart';
import 'package:project_management_muhmad_omar/screens/projects/create_project_screen.dart';
import 'package:project_management_muhmad_omar/screens/projects/projects_screen.dart';
import 'package:project_management_muhmad_omar/screens/projects/search_for_members_screen.dart';
import 'package:project_management_muhmad_omar/screens/splash_screen.dart';
import 'package:project_management_muhmad_omar/screens/task/task_due_date_screen.dart';
import 'package:project_management_muhmad_omar/widgets/dashboard/dashboard_meeting_details_widget.dart';

class Routes {
  Routes._();

  // Start Auth Screens --------------------------------------------------------------
  static const String authScreen = '/auth-screen';
  static const String loginScreen = '/login-screen';
  static const String signupScreen = '/signup-screen';
  static const String choosePlanScreen = '/choose-plan-screen';
  static const String emailAddressScreen = '/email-address-screen';
  static const String newWorkspaceScreen = '/new-workspace-screen';

  // End Auth Screens --------------------------------------------------------------

  static const String splashScreen = '/splash-screen';

  static const String resetPassword = '/reset-password';
  static const String chatScreen = '/chat-screen';
  static const String massagingScreen = '/massaging-screen';
  static const String newGroupScreen = '/new-group-screen';
  static const String newMessageScreen = '/new-message-screen';
  static const String dashboardScreen = '/dashboard-screen';
  static const String notificationsScreen = '/notification-screen';
  static const String dashboardProjectsScreen = '/dashboard-projects-screen';
  static const String searchScreen = '/search-screen';
  static const String timelineScreen = '/timeline-screen';
  static const String overviewScreen = '/overview-screen';
  static const String dashboardProductivityScreen = '/productivity-screen';
  static const String onboardingCarouselScreen = '/onboarding-carousel-screen';
  static const String onboardingStartScreen = '/onboarding-start-screen';
  static const String editProfileScreen = '/edit-profile-screen';
  static const String myProfileScreen = '/my-profile-screen';
  static const String myTeamScreen = '/my-team-screen';
  static const String profileNotificationSettingsScreen =
      '/profile-notification-settings-screen';
  static const String profileOverviewScreen = '/profile-overview-screen';
  static const String teamDetailsScreen = '/team-details-screen';
  static const String createProjectScreen = '/create-project-screen';
  static const String projectScreen = '/project-screen';
  static const String editProjectScreen = '/edit-project-screen';
  static const String projectDetailsScreen = '/project-details-screen';
  static const String projectsScreen = '/projects-screen';
  static const String selectMembersScreen = '/select-members-screen';
  static const String selectAssigneesScreen = '/select-assignees-screen';
  static const String taskDueDateScreen = '/task-due-date-screen';
  static const String verifyEmailAddressScreen = '/verify-email-address-screen';
  static const String categoryScreen = '/category-screen';
  static const String inviteScreen = '/invite-screen';
  static const String selectMyTeamsScreen = '/select-my-team-screen';
  static const String selectTeamScreen = '/select-team-screen';
  static const String searchForMembersScreen = '/search-for-members-screen';
  static const String dashboardMeetingDetailsWidget =
      '/dashboard-meeting-details-widget';

  static final dynamic routes = <String, WidgetBuilder>{
    authScreen: (BuildContext context) => const AuthScreen(),
    loginScreen: (BuildContext context) => const LoginScreen(),
    dashboardMeetingDetailsWidget: (BuildContext context) =>
        const DashboardMeetingDetailsWidget(),
    signupScreen: (BuildContext context) => const SignUpScreen(email: ''),
    resetPassword: (BuildContext context) => const ResetPasswordScreen(),
    verifyEmailAddressScreen: (BuildContext context) =>
        const VerifyEmailAddressScreen(),
    emailAddressScreen: (BuildContext context) => const EmailAddressScreen(),
    splashScreen: (BuildContext context) => const SplashScreen(),
    categoryScreen: (BuildContext context) => CategoryScreen(),
    selectMyTeamsScreen: (BuildContext context) =>
        SelectMyTeamsScreen(title: ''),
    selectTeamScreen: (BuildContext context) =>
        const SelectTeamScreen(title: '', managerModel: null),
    dashboardScreen: (BuildContext context) => DashboardScreen(),
    timelineScreen: (BuildContext context) => const TimelineScreen(),
    overviewScreen: (BuildContext context) => const DashboardOverviewScreen(),
    inviteScreen: (BuildContext context) => InvitationScreen(),
    projectScreen: (BuildContext context) => const ProjectScreen(),
    dashboardProductivityScreen: (BuildContext context) =>
        const DashboardProductivityScreen(),
    onboardingCarouselScreen: (BuildContext context) =>
        const OnboardingCarouselScreen(),
    onboardingStartScreen: (BuildContext context) =>
        const OnboardingStartScreen(),
    editProfileScreen: (BuildContext context) =>
        const EditProfileScreen(user: null),
    myProfileScreen: (BuildContext context) =>
        const MyProfileScreen(user: null),
    myTeamScreen: (BuildContext context) => const MyTeamScreen(
        userAsManager: null,
        onTap: null,
        teamModel: null,
        users: [],
        teamTitle: '',
        numberOfMembers: '',
        noImages: ''),
    profileOverviewScreen: (BuildContext context) =>
        ProfileOverviewScreen(isSelected: true),
    teamDetailsScreen: (BuildContext context) =>
        TeamDetailsScreen(title: '', team: null, userAsManager: null),
    createProjectScreen: (BuildContext context) =>
        CreateProjectScreen(managerModel: null, isEditMode: false),
    projectsScreen: (BuildContext context) => const ProjectsScreen(),
    editProjectScreen: (BuildContext context) =>
        const EditProfileScreen(user: null),
    searchForMembersScreen: (BuildContext context) =>
        const SearchForMembersScreen(users: null, newTeam: false),
    taskDueDateScreen: (BuildContext context) => const TaskDueDateScreen()
    // profileNotificationSettingsScreen: (BuildContext context) =>
    //     const ProfileNotificationSettingsScreen(),
    // projectDetailsScreen: (BuildContext context) => const ProjectDetailsScreen(
    //       color: '',
    //       projectName: '',
    //       category: '',
    //     ),
    // selectMembersScreen: (BuildContext context) => const SelectMembersScreen(),
    // selectAssigneesScreen: (BuildContext context) => SetAssigneesScreen(),
    // choosePlanScreen: (BuildContext context) => const ChoosePlanScreen(),
    // newWorkspaceScreen: (BuildContext context) => const NewWorkSpaceScreen(),
    // chatScreen: (BuildContext context) => const ChatScreen(),
    // massagingScreen: (BuildContext context) =>
    //     const MessagingScreen(userName: '', color: '', image: ''),
    // newGroupScreen: (BuildContext context) => const NewGroupScreen(),
    // newMessageScreen: (BuildContext context) => const NewMessageScreen(),
    // notificationsScreen: (BuildContext context) => const NotificationScreen(),
    // dashboardProjectsScreen: (BuildContext context) =>
    //     const DashboardProjectScreen(),
    // searchScreen: (BuildContext context) => const SearchScreen(),
  };
}
