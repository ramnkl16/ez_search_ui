import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/services/storageservice/storageservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage extends StorageService {
  static const String authTokenHeaderKey = 'x-auth';
  static const String grpIDKey = 'groupId';
  static const String nsIDKey = 'nsid';
  static const String apiActiveConnKey = 'apiac';
  static const String apiConnCollKey = 'apicc';

  @override
  Future<String?> getApiActiveConn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(apiActiveConnKey);
  }

  @override
  Future<void> setApiActiveConn(String conn) async {
    final prefs = await SharedPreferences.getInstance();
    String? oldconn = await getApiActiveConn();

    if (oldconn != null && oldconn != conn) {
      prefs.setString(apiActiveConnKey, conn);
      var split = conn.split("|");
      ApiPaths.baseURL = split[1];
      if (oldconn == null) {
        setApiConnColl(conn);
      } else {
        List<String>? oldColl = await getApiConnColl();
        if (oldColl != null) {
          var exist = false;
          for (var item in oldColl) {
            if (item == conn) {
              exist = true;
              break;
            }
          }
          if (exist == false) setApiConnColl("$oldColl,$conn");
        }
      }
    }
  }

  @override
  Future<List<String>?> getApiConnColl() async {
    final prefs = await SharedPreferences.getInstance();
    var coll = prefs.getString(apiConnCollKey);
    if (coll != null) {
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
}
