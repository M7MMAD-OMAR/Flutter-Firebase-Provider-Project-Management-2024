// import 'package:get/get.dart';
// import 'package:project_management_muhmad_omar/Screens/Auth/choose_plan_screen.dart';
// import 'package:project_management_muhmad_omar/Screens/Auth/email_address_screen.dart';
// import 'package:project_management_muhmad_omar/pages/auth/auth_page.dart';
// import 'package:project_management_muhmad_omar/pages/home2.dart';

// import '../Screens/Auth/login_screen.dart';
// import '../Screens/Auth/new_workspace_screen.dart';
// import '../Screens/Auth/signup_screen.dart';
// import '../Screens/Dashboard/DashboardTabScreens/overview_screen.dart';
// import '../Screens/Dashboard/DashboardTabScreens/productivity_screen.dart';
// import '../Screens/Dashboard/dashboard_screen.dart';
// import '../Screens/Dashboard/category_screen.dart';
// import '../Screens/Dashboard/projects_screen.dart';
// import '../Screens/Dashboard/search_screen.dart';
// import '../Screens/Dashboard/timeline_screen.dart';
// import '../Screens/Onboarding/onboarding_carousel2.dart';
// import '../Screens/Onboarding/onboarding_start_screen.dart';
// import '../Screens/Profile/edit_profile_screen.dart';
// import '../Screens/Profile/my_profile_screen.dart';
// import '../Screens/Profile/my_team_screen.dart';
// import '../Screens/Profile/profile_notification_settings.dart';
// import '../Screens/Profile/profile_overview_screen.dart';
// import '../Screens/Profile/team_details_screen.dart';
// import '../Screens/Projects/create_project.dart';
// import '../Screens/Projects/project_detail.dart';
// import '../Screens/Projects/projects_screen.dart';
// import '../Screens/Projects/set_members.dart';
// import '../Screens/Task/set_assignees.dart';
// import '../Screens/Task/task_due_date_screen.dart';
// import '../Screens/splash_screen.dart';
// import '../pages/language_screen.dart';

// class RouteHelper {
//   static List<GetPage> routes = [
//     GetPage(
//       name: AuthPage.id,
//       page: () {
//         return const AuthPage();
//       },
//     ),
//     GetPage(
//       name: SplashScreen.id,
//       page: () {
//         return const SplashScreen();
//       },
//     ),
//     GetPage(
//       name: LanguagePage.id,
//       page: () {
//         return const LanguagePage();
//       },
//     ),
//     GetPage(
//       name: ChoosePlan.id,
//       page: () {
//         return const ChoosePlan();
//       },
//     ),
//     GetPage(
//       name: EmailAddressScreen.id,
//       page: () {
//         return const EmailAddressScreen();
//       },
//     ),
//     GetPage(
//       name: Login.id,
//       page: () {
//         return Login(
//           email: Get.arguments['email'],
//         );
//       },
//     ),
//     GetPage(
//       name: testrouting.id,
//       page: () {
//         return testrouting(
//           email: Get.arguments['email'],
//         );
//       },
//     ),
//     GetPage(
//       name: NewWorkSpace.id,
//       page: () {
//         return const NewWorkSpace();
//       },
//     ),
//     GetPage(
//       name: SignUp.id,
//       page: () {
//         return SignUp(
//           email: Get.arguments['email'],
//         );
//       },
//     ),
//     GetPage(
//       name: DashboardOverview.id,
//       page: () {
//         return DashboardOverview();
//       },
//     ),
//     GetPage(
//       name: DashboardProductivity.id,
//       page: () {
//         return const DashboardProductivity();
//       },
//     ),
//     GetPage(
//       name: Dashboard.id,
//       page: () {
//         return Dashboard();
//       },
//     ),
//     GetPage(
//       name: CategoryScreen.id,
//       page: () {
//         return CategoryScreen();
//       },
//     ),
//     GetPage(
//       name: ProjectScreen.id,
//       page: () {
//         return const ProjectScreen();
//       },
//     ),
//     GetPage(
//       name: SearchScreen.id,
//       page: () {
//         return const SearchScreen();
//       },
//     ),
//     GetPage(
//       name: Timeline.id,
//       page: () {
//         return const Timeline();
//       },
//     ),
//     GetPage(
//       name: OnboardingCarousel2.id,
//       page: () {
//         return const OnboardingCarousel2();
//       },
//     ),
//     GetPage(
//       name: OnboardingStart.id,
//       page: () {
//         return const OnboardingStart();
//       },
//     ),
//     GetPage(
//       name: EditProfilePage.id,
//       page: () {
//         return const EditProfilePage();
//       },
//     ),
//     GetPage(
//       name: ProfilePage.id,
//       page: () {
//         return const ProfilePage();
//       },
//     ),
//     GetPage(
//       name: MyTeams.id,
//       page: () {
//         return const MyTeams();
//       },
//     ),
//     GetPage(
//       name: ProfileNotificationSettings.id,
//       page: () {
//         return const ProfileNotificationSettings();
//       },
//     ),
//     GetPage(
//       name: ProfileOverview.id,
//       page: () {
//         return const ProfileOverview();
//       },
//     ),
//     GetPage(
//       name: TeamDetails.id,
//       page: () {
//         return TeamDetails(
//           teamid: Get.arguments["id"],
//         );
//       },
//     ),
//     GetPage(
//       name: CreateProjectScreen.id,
//       page: () {
//         return const CreateProjectScreen();
//       },
//     ),
//     GetPage(
//       name: ProjectDetails.id,
//       page: () {
//         return ProjectDetails(
//           projectId: Get.arguments["id"],
//         );
//       },
//     ),
//     GetPage(
//       name: Projects.id,
//       page: () {
//         return const Projects();
//       },
//     ),
//     GetPage(
//       name: SelectMembersScreen.id,
//       page: () {
//         return const SelectMembersScreen();
//       },
//     ),
//     GetPage(
//       name: SetAssigneesScreen.id,
//       page: () {
//         return const SetAssigneesScreen();
//       },
//     ),
//     GetPage(
//       name: TaskDueDate.id,
//       page: () {
//         return const TaskDueDate();
//       },
//     ),
//     GetPage(
//       name: OnboardingStart.id,
//       page: () {
//         return const OnboardingStart();
//       },
//     ),
//   ];
// }
