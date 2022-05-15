abstract class StorageService {
  Future<String?> getAuthToken();
  Future<void> setAuthToken(String token);
  Future<String?> getNamespace();
  Future<void> setNamespace(String namespace);
  Future<String?> getApiActiveConn();
  Future<void> setApiActiveConn(String connVal);
  Future<List<String>?> getApiConnColl();
  Future<void> setApiConnColl(String connColl);
  Future<String?> getThemeName();
  Future<void> setThemeName(String themeName);
}
