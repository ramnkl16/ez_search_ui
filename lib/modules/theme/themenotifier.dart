import 'package:ez_search_ui/modules/theme/configtheme.dart';
import 'package:ez_search_ui/services/serviceLocator.dart';
import 'package:ez_search_ui/services/storageservice/storageservice.dart';
import 'package:flutter/foundation.dart';

class ThemeNotifier with ChangeNotifier {
  // late ThemeEnum _ezCurThemeName;

  // ThemeNotifier() {
  //   _ezCurThemeName = ThemeEnum.White;
  // }
  // ThemeEnum get getCurTheme {
  //   print('theme|getCurTheme|${_ezCurThemeName.name}');
  //   return _ezCurThemeName;
  // }
  static ThemeEnum ezCurThemeName = ThemeEnum.White;
  setTheme(ThemeEnum theme) async {
    ezCurThemeName = theme;
    var pref = getIt<StorageService>();
    print('theme|notifier|$theme');
    await pref.setThemeName(theme.name);
    notifyListeners();
  }
}
