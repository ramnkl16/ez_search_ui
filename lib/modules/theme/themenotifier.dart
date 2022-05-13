import 'package:ez_search_ui/modules/theme/configtheme.dart';
import 'package:ez_search_ui/services/serviceLocator.dart';
import 'package:ez_search_ui/services/storageservice/storageservice.dart';
import 'package:flutter/foundation.dart';

class ThemeNotifier with ChangeNotifier {
  setTheme(ThemeEnum theme) async {
    ezCurThemeName = theme;
    var pref = getIt<StorageService>();
    await pref.setThemeName(theme.toString());
    notifyListeners();
  }
}
