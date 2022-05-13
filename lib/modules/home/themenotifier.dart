import 'package:ez_search_ui/modules/home/themepreferences.dart';
import 'package:ez_search_ui/services/serviceLocator.dart';
import 'package:ez_search_ui/services/storageservice/storageservice.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  final String key = 'Theme';
  bool? _isDark;
  SharedPreferences? _preferences;
  bool? get isDark => _isDark;

  ThemeModel() {
    _isDark = true;

    //loadPreferences();
  }

  toggleTheme() async {
    // bool _toggleTheme;
    var preference = getIt<StorageService>();
    var themeName = await preference.getThemeName();
    if (themeName != null) {
      if (themeName == 'Dark') {
        _isDark = true;
      } else
        _isDark = false;
      preference.setThemeName(themeName);
      notifyListeners();
    }
  }

  // Future<void> init() async {
  //   _preferences = await SharedPreferences.getInstance();
  // }

  // savePreferences() async {
  //   await init();
  //   _preferences!.setBool(key, _isDark!);
  // }

  // loadPreferences() async {
  //   await init();
  //   _isDark = _preferences.getBool(key) ?? true;
  //   notifyListeners();
  // }
}
