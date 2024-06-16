import 'package:flutter/material.dart';

import '../models/lang/lang_model.dart';

class LangProvider with ChangeNotifier {
  Locale _locale;
  final List<LanguageModel> languages;
  final Map<String, dynamic> dir;

  LangProvider(
      {required this.languages,
      required this.dir,
      required Locale initialLocale})
      : _locale = initialLocale;

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}
