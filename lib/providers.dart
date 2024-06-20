import 'package:project_management_muhmad_omar/controllers/top_provider.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/providers/box_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/add_team_to_create_project_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/stx_provider.dart';
import 'package:provider/provider.dart';

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

    // End Project Provider
  ].toList();
}
