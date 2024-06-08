import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../models/lang/lang.dart';

class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  LocalizationController({required this.sharedPreferences}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(
      Constants.languages[1].languageCode, Constants.languages[1].countryCode);

  Locale get locale => _locale;
  int _selectedIndex = 1;

  int get selectedIndex => _selectedIndex;
  List<LanguageModel> _languages = [];

  List<LanguageModel> get languages => _languages;

  Future<void> loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences.getString(Constants.languageCode) ??
        Constants.languages[1].languageCode);
    for (int index = 0; index < Constants.languages.length; index++) {
      if (Constants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(Constants.languages);
    update();
  }

  Future<void> setLanguage({required Locale locale}) async {
    Get.updateLocale(locale);
    _locale = locale;
    saveLanguage(locale: _locale);
    update();
  }

  void setSelectIndex({required int index}) {
    _selectedIndex = index;
    update();
  }

  Future<void> saveLanguage({required Locale locale}) async {
    sharedPreferences.setString(Constants.languageCode, locale.languageCode);
    sharedPreferences.setString(Constants.countryCode, locale.countryCode!);
  }
}
