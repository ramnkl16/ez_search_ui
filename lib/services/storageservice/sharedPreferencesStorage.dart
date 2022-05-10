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
    List<String>? oldConnColl = await getApiConnColl();

    if (oldconn != null && oldconn != conn) {
      prefs.setString(apiActiveConnKey, conn);
      var split = conn.split("|");
      ApiPaths.baseURL = split[1];
      if (oldConnColl == null) {
        setApiConnColl(conn);
      } else {
        //List<String>? oldColl = await getApiConnColl();
        if (oldConnColl != null) {
          var exist = false;
          for (var item in oldConnColl) {
            if (item == conn) {
              exist = true;
              break;
            }
          }
          if (exist == false) setApiConnColl("${oldConnColl.join(',')},$conn");
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
    print('setApiConnColl $apiConnCollKey $connColl');
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
    prefs.setString(apiActiveConnKey, token);
  }

  @override
  Future<String?> getNamespace() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(nsIDKey);
  }

  @override
  Future<void> setNamespace(String connColl) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(apiActiveConnKey, connColl);
  }
}
