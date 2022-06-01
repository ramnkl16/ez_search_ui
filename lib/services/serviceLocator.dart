import 'package:ez_search_ui/modules/theme/themenotifier.dart';
import 'package:ez_search_ui/router/appRouter.gr.dart';
import 'package:ez_search_ui/router/routeguard.dart';
import 'package:ez_search_ui/services/authservice.dart';
import 'package:ez_search_ui/services/storageservice/sharedPreferencesStorage.dart';
import 'package:ez_search_ui/services/storageservice/storageservice.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // state management layer
  getIt.registerSingleton<AppRouter>(
      AppRouter(routeGuard: RouteGuard(AuthService())));
  getIt.registerSingleton<ThemeNotifier>(ThemeNotifier());
  //getIt.registerSingleton<AuthService>(AuthService());
  // service layer
  getIt.registerLazySingleton<StorageService>(() => SharedPreferencesStorage());
}
