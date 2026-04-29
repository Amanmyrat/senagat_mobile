import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:senagat_mobile/src/utils/localization/lang/tm.dart';
import 'package:senagat_mobile/src/utils/localization/tk_material_localizations.dart';
import 'lang/ru.dart';
import 'lang/en.dart';
import 'supported_localizations.dart';

class LocalizationService extends Translations {
  static const Locale defaultLocale = Locale('tk', 'TK');
  static const Locale fallbackLocale = Locale('tk', 'TK');

  static final List<String> langs = ['TM', 'RU', 'EN'];

  static const String _selectedLocaleStringKey = 'selected_locale_key';

  static final List<Locale> availableLocales = [
    Locale('tk', 'TK'),
    Locale('ru', 'RU'),
    Locale('en', 'EN'),
  ];

  static Locale _currentLocale = defaultLocale;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString(_selectedLocaleStringKey);

    _currentLocale = _getLocaleFromLanguageStatic(savedLang);
  }

  Locale getLocale() => _currentLocale;

  Future<void> changeLocale(String lang) async {
    final locale = _getLocaleFromLanguageStatic(lang);

    _currentLocale = locale;

    Get.updateLocale(locale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedLocaleStringKey, lang);
  }

  static Locale _getLocaleFromLanguageStatic(String? lang) {
    for (int i = 0; i < availableLocales.length; i++) {
      if (lang == langs[i]) return availableLocales[i];
    }
    return defaultLocale;
  }

  static Iterable<LocalizationsDelegate> localizationsDelegate() {
    return [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      TkMaterialLocalizationsDelegate(),
    ];
  }

  @override
  Map<String, Map<String, String>> get keys => {
    turkmen: tkTk,
    russian: ruRu,
    english: enUs,
  };
}