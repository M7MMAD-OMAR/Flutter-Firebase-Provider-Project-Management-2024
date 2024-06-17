import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/providers/box_provider.dart';
import 'package:project_management_muhmad_omar/providers/lang_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/add_team_to_create_project_provider.dart';
import 'package:project_management_muhmad_omar/screens/projects/edit_project_screen.dart';
import 'package:project_management_muhmad_omar/services/lang_service.dart';
import 'package:provider/provider.dart';

class Providers {
  Providers._();

  static final providers = [
    ChangeNotifierProvider<LangProvider>(
      create: (context) => LangProvider(
        localizationService: LangService(
          sharedPreferences: Provider.of(context, listen: false),
        ),
      ),
    ),

    // Auth Provider
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
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
