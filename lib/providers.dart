import 'dart:ui';

import 'package:project_management_muhmad_omar/providers/lang_provider.dart';
import 'package:provider/provider.dart';

import 'constants/app_constans.dart';

class Providers {
  Providers._();

  static final providers = [
    ChangeNotifierProvider(
      create: (_) => LangProvider(
        languages: AppConstants.languages,
        dir: AppConstants.dir,
        initialLocale:
            const Locale(AppConstants.languageCode, AppConstants.countryCode),
      ),
    ),
  ].toList();
}
