import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../models/lang/lang_model.dart';

class LangService {
  final SharedPreferences sharedPreferences;

  LangService({required this.sharedPreferences});

  Locale _locale = Locale(AppConstants.languages[1].languageCode,
      AppConstants.languages[1].countryCode);

  Locale get locale => _locale;

  int _selectedIndex = 1;

  int get selectedIndex => _selectedIndex;

  List<LanguageModel> _languages = [];

  List<LanguageModel> get languages => _languages;

  Future<void> loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences.getString(AppConstants.languageCode) ??
        AppConstants.languages[1].languageCode);
    for (int index = 0; index < AppConstants.languages.length; index++) {
      if (AppConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(AppConstants.languages);
  }

  Future<void> setLanguage({required Locale locale}) async {
    _locale = locale;
    await saveLanguage(locale: _locale);
  }

  void setSelectIndex({required int index}) {
    _selectedIndex = index;
  }

  Future<void> saveLanguage({required Locale locale}) async {
    await sharedPreferences.setString(
        AppConstants.languageCode, locale.languageCode);
    await sharedPreferences.setString(
        AppConstants.countryCode, locale.countryCode!);
  }
}
