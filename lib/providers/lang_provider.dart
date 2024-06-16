import 'package:flutter/material.dart';

import '../models/lang/lang_model.dart';
import '../services/lang_service.dart';

class LangProvider with ChangeNotifier {
  final LangService localizationService;

  LangProvider({required this.localizationService}) {
    _loadCurrentLanguage();
  }

  Locale get locale => localizationService.locale;

  int get selectedIndex => localizationService.selectedIndex;

  List<LanguageModel> get languages => localizationService.languages;

  Future<void> _loadCurrentLanguage() async {
    await localizationService.loadCurrentLanguage();
    notifyListeners();
  }

  Future<void> setLanguage(Locale locale) async {
    await localizationService.setLanguage(locale: locale);
    notifyListeners();
  }

  void setSelectIndex(int index) {
    localizationService.setSelectIndex(index: index);
    notifyListeners();
  }
}
