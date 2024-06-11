import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/auth_screen.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/choose_plan_screen.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/email_address_screen.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/login_screen.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/new_workspace_screen.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/signup_screen.dart';
import 'package:project_management_muhmad_omar/screens/chat_screen/chat_screen.dart';
import 'package:project_management_muhmad_omar/screens/chat_screen/messaging_screen.dart';
import 'package:project_management_muhmad_omar/screens/chat_screen/new_group_screen.dart';
import 'package:project_management_muhmad_omar/screens/chat_screen/new_message_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/dashboard_projects_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/dashboard_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/dashboard_tab_screens/overview_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/dashboard_tab_screens/productivity_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/notifications_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/search_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/timeline_screen.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/onboarding_carousel_screen.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/onboarding_start_screen.dart';
import 'package:project_management_muhmad_omar/screens/profile_screen/edit_profile_screen.dart';
import 'package:project_management_muhmad_omar/screens/profile_screen/my_profile_screen.dart';
import 'package:project_management_muhmad_omar/screens/profile_screen/my_team_screen.dart';
import 'package:project_management_muhmad_omar/screens/profile_screen/profile_notification_settings_screen.dart';
import 'package:project_management_muhmad_omar/screens/profile_screen/profile_overview_screen.dart';
import 'package:project_management_muhmad_omar/screens/profile_screen/team_details_screen.dart';
import 'package:project_management_muhmad_omar/screens/projects_screen/create_project_screen.dart';
import 'package:project_management_muhmad_omar/screens/projects_screen/project_details_screen.dart';
import 'package:project_management_muhmad_omar/screens/projects_screen/projects_screen.dart';
import 'package:project_management_muhmad_omar/screens/projects_screen/select_members_screen.dart';
import 'package:project_management_muhmad_omar/screens/splash_screen.dart';
import 'package:project_management_muhmad_omar/screens/task_screen/set_assignees_screen.dart';
import 'package:project_management_muhmad_omar/screens/task_screen/task_due_date_screen.dart';

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

  // static const String homeScreen = '/home-screen';
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
  static const String projectDetailsScreen = '/project-details-screen';
  static const String projectsScreen = '/projects-screen';
  static const String selectMembersScreen = '/select-members-screen';
  static const String selectAssigneesScreen = '/select-assignees-screen';
  static const String taskDueDateScreen = '/task-due-date-screen';

  static final dynamic routes = <String, WidgetBuilder>{
    authScreen: (BuildContext context) => const AuthScreen(),
    loginScreen: (BuildContext context) => const LoginScreen(
          email: '',
        ),
    signupScreen: (BuildContext context) => const SignUpScreen(email: ''),
    choosePlanScreen: (BuildContext context) => const ChoosePlanScreen(),
    emailAddressScreen: (BuildContext context) => const EmailAddressScreen(),
    splashScreen: (BuildContext context) => const SplashScreen(),
    newWorkspaceScreen: (BuildContext context) => const NewWorkSpaceScreen(),
    chatScreen: (BuildContext context) => const ChatScreen(),
    massagingScreen: (BuildContext context) =>
        const MessagingScreen(userName: '', color: '', image: ''),
    newGroupScreen: (BuildContext context) => const NewGroupScreen(),
    newMessageScreen: (BuildContext context) => const NewMessageScreen(),
    dashboardScreen: (BuildContext context) => DashboardScreen(),
    notificationsScreen: (BuildContext context) => const NotificationScreen(),
    dashboardProjectsScreen: (BuildContext context) =>
        const DashboardProjectScreen(),
    searchScreen: (BuildContext context) => const SearchScreen(),
    timelineScreen: (BuildContext context) => const TimelineScreen(),
    overviewScreen: (BuildContext context) => const DashboardOverviewScreen(),
    dashboardProductivityScreen: (BuildContext context) =>
        const DashboardProductivityScreen(),
    onboardingCarouselScreen: (BuildContext context) =>
        const OnboardingCarouselScreen(),
    onboardingStartScreen: (BuildContext context) =>
        const OnboardingStartScreen(),
    editProfileScreen: (BuildContext context) => const EditProfileScreen(),
    myProfileScreen: (BuildContext context) => const MyProfileScreen(),
    myTeamScreen: (BuildContext context) => const MyTeamScreen(),
    profileNotificationSettingsScreen: (BuildContext context) =>
        const ProfileNotificationSettingsScreen(),
    profileOverviewScreen: (BuildContext context) =>
        const ProfileOverviewScreen(),
    teamDetailsScreen: (BuildContext context) => const TeamDetailsScreen(
          title: '',
        ),
    createProjectScreen: (BuildContext context) => const CreateProjectScreen(),
    projectDetailsScreen: (BuildContext context) => const ProjectDetailsScreen(
          color: '',
          projectName: '',
          category: '',
        ),
    projectsScreen: (BuildContext context) => const ProjectsScreen(),
    selectMembersScreen: (BuildContext context) => const SelectMembersScreen(),
    selectAssigneesScreen: (BuildContext context) => SetAssigneesScreen(),
    taskDueDateScreen: (BuildContext context) => const TaskDueDateScreen()
  };
}
