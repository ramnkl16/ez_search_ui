import 'package:ez_search_ui/router/appRouter.gr.dart';
import 'package:ez_search_ui/services/storageservice/sharedPreferencesStorage.dart';
import 'package:ez_search_ui/services/storageservice/storageservice.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // state management layer
  getIt.registerSingleton<AppRouter>(AppRouter());
  // service layer
  getIt.registerLazySingleton<StorageService>(() => SharedPreferencesStorage());
}
