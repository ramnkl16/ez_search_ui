import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/services/storageservice/storageservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage extends StorageService {
  static const String authTokenHeaderKey = 'x-auth';
  static const String grpIDKey = 'groupId';
  static const String nsIDKey = 'nsid';
  static const String apiActiveConnKey = 'apiac';
  static const String apiConnCollKey = 'apicc';
  static const String themeNameKey = 'themeN';

  @override
  Future<String?> getApiActiveConn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(apiActiveConnKey);
  }

  @override
  Future<void> setApiActiveConn(String connVal) async {
    print("setApiActiveConn|$connVal");
    final prefs = await SharedPreferences.getInstance();
    String? oldconn = await getApiActiveConn();
    List<String>? oldConnColl = await getApiConnColl();

    if (oldconn != connVal) {
      prefs.setString(apiActiveConnKey, connVal);
      var split = connVal.split("|");
      ApiPaths.baseURL = split[1];
      print("setApiConnColl(conn);oldcoll conn=$connVal");
      if (oldConnColl == null) {
        setApiConnColl(connVal);
      } else {
        //List<String>? oldColl = await getApiConnColl();
        if (oldConnColl != null) {
          var exist = false;
          for (var item in oldConnColl) {
            if (item == connVal) {
              exist = true;
              break;
            }
          }
          if (exist == false)
            setApiConnColl("${oldConnColl.join(',')},$connVal");
        }
      }
    }
  }

  @override
  Future<List<String>?> getApiConnColl() async {
    final prefs = await SharedPreferences.getInstance();

    var coll = prefs.getString(apiConnCollKey);
    print('getApiConnColl ${prefs.getKeys()}, $coll');
    if (coll != null) {
      print(
          'getApiConnColl beforereturn ${prefs.getKeys()}, ${coll.split(",")}');
      return coll.split(",");
    } else {
      return Future.value(null);
    }
  }

  @override
  Future<void> setApiConnColl(String connColl) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(apiConnCollKey, connColl);
  }

  @override
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(authTokenHeaderKey);
  }

  @override
  Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(authTokenHeaderKey, token);
  }

  @override
  Future<String?> getNamespace() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(nsIDKey);
  }

  @override
  Future<void> setNamespace(String namespace) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(nsIDKey, namespace);
  }

  @override
  Future<void> setThemeName(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(themeNameKey, themeName);
  }

  @override
  Future<String?> getThemeName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(themeNameKey);
  }
}
