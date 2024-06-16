import 'package:project_management_muhmad_omar/providers/lang_provider.dart';
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
  ].toList();
}
