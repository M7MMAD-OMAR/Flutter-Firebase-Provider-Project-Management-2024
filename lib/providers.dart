import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/providers/box_provider.dart';
import 'package:project_management_muhmad_omar/providers/dashboard/checkbox_provider.dart';
import 'package:project_management_muhmad_omar/providers/invitations_provider.dart';
import 'package:project_management_muhmad_omar/providers/manger_provider.dart';
import 'package:project_management_muhmad_omar/providers/password_email_dialog_provider.dart';
import 'package:project_management_muhmad_omar/providers/profile_overview_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/add_team_to_create_project_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/dashboard_meeting_details_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/project_sub_task_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/search_for_member_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/stx_provider.dart';
import 'package:project_management_muhmad_omar/providers/task_category_provider.dart';
import 'package:project_management_muhmad_omar/providers/task_provider.dart';
import 'package:project_management_muhmad_omar/providers/team_provider.dart';
import 'package:project_management_muhmad_omar/providers/top_provider.dart';
import 'package:provider/provider.dart';

import 'providers/projects/project_main_task_provider.dart';
import 'providers/projects/project_provider.dart';
import 'providers/status_provider.dart';
import 'providers/team_member_provider.dart';
import 'providers/user_provider.dart';
import 'providers/user_task_provider.dart';
import 'providers/waiting_member_provider.dart';
import 'providers/waiting_sub_tasks_provider.dart';

class Providers {
  Providers._();

  static final providers = [
    // Auth Provider
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
    ),
    ChangeNotifierProvider<TopProvider>(
      create: (context) => TopProvider(),
    ),

    // Start Project Provider
    ChangeNotifierProvider<BoxProvider>(
      create: (context) => BoxProvider(),
    ),

    ChangeNotifierProvider<AddTeamToCreatProjectProvider>(
      create: (context) => AddTeamToCreatProjectProvider(),
    ),

    ChangeNotifierProvider<STXProvider>(create: (context) => STXProvider()),
    ChangeNotifierProvider<InvitationProvider>(
        create: (context) => InvitationProvider()),
    ChangeNotifierProvider<SearchForMembersProvider>(
        create: (context) => SearchForMembersProvider()),
    ChangeNotifierProvider<CheckboxProvider>(
        create: (context) => CheckboxProvider()),
    ChangeNotifierProvider<ProfileOverviewProvider>(
        create: (context) => ProfileOverviewProvider()),
    ChangeNotifierProvider<DashboardMeetingDetailsProvider>(
        create: (context) => DashboardMeetingDetailsProvider()),
    ChangeNotifierProvider<PasswordEmailDialogProvider>(
        create: (context) => PasswordEmailDialogProvider()),
    ChangeNotifierProvider<UserTaskProvider>(
        create: (context) => UserTaskProvider()),
    ChangeNotifierProvider<TaskCategoryProvider>(
        create: (context) => TaskCategoryProvider()),
    ChangeNotifierProvider<TaskProvider>(create: (context) => TaskProvider()),
    ChangeNotifierProvider<ProjectProvider>(
        create: (context) => ProjectProvider()),
    ChangeNotifierProvider<ManagerProvider>(
        create: (context) => ManagerProvider()),
    ChangeNotifierProvider<ProjectMainTaskProvider>(
        create: (context) => ProjectMainTaskProvider()),
    ChangeNotifierProvider<ProjectSubTaskProvider>(
        create: (context) => ProjectSubTaskProvider()),
    ChangeNotifierProvider<StatusProvider>(
        create: (context) => StatusProvider()),
    ChangeNotifierProvider<TaskCategoryProvider>(
        create: (context) => TaskCategoryProvider()),
    ChangeNotifierProvider<TeamMemberProvider>(
        create: (context) => TeamMemberProvider()),
    ChangeNotifierProvider<TeamProvider>(create: (context) => TeamProvider()),
    ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
    ChangeNotifierProvider<WaitingMemberProvider>(
        create: (context) => WaitingMemberProvider()),
    ChangeNotifierProvider<WaitingSubTasksProvider>(
        create: (context) => WaitingSubTasksProvider()),
    ChangeNotifierProvider<PasswordEmailDialogProvider>(
        create: (context) => PasswordEmailDialogProvider()),

    // End Project Provider
  ].toList();
}
