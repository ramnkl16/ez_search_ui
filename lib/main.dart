import 'package:ez_search_ui/common/global.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/cubit/hydratedCubit.dart';
import 'package:ez_search_ui/modules/authentication/authentication.cubit.dart';
import 'package:ez_search_ui/modules/indexes/indexes.cubit.dart';
import 'package:ez_search_ui/modules/indexfields/indexesFields.cubit.dart';
import 'package:ez_search_ui/modules/login/login.logic.cubit.dart';
import 'package:ez_search_ui/modules/login/login.repo.dart';
import 'package:ez_search_ui/modules/menu/menu.cubit.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.cubit.dart';
import 'package:ez_search_ui/modules/search/search.cubit.dart';
import 'package:ez_search_ui/modules/theme/configtheme.dart';
import 'package:ez_search_ui/modules/theme/themenotifier.dart';
import 'package:ez_search_ui/modules/user/user.cubit.dart';
import 'package:ez_search_ui/router/appRouter.gr.dart';
import 'package:ez_search_ui/router/routeguard.dart';
import 'package:ez_search_ui/services/authservice.dart';
import 'package:ez_search_ui/services/serviceLocator.dart';
import 'package:ez_search_ui/services/storageservice/storageservice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await Hive.initFlutter(); //init hive not yet implmented
  Global.initializeProperties(); //init platform related properies
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  //Registering singleton instance of AppRouter access throughout the project
  // getIt.registerSingleton<AppRouter>(AppRouter());
  // getIt.registerSingleton<SharedPreferences>(
  //     await SharedPreferences.getInstance());
  setupGetIt();
  var prefs = getIt<StorageService>();
  var token = await prefs.getAuthToken();
  var conn = await prefs.getApiActiveConn();
  if (conn != null) {
    ApiPaths.baseURLName = conn;
    var split = conn.split('|');
    if (split.length > 1)
      ApiPaths.baseURL = split[1];
    else
      ApiPaths.baseURL = split[0];
  }
  var themeStr = await prefs.getThemeName();
  print(
      "theme|$themeStr|${ThemeNotifier.ezCurThemeName} token=$token conn=$conn");
  ThemeEnum theme;
  if (themeStr != null) {
    for (var element in ThemeEnum.values) {
      if (element.name.contains(themeStr)) {
        theme = element;
        ThemeNotifier.ezCurThemeName = theme;
        break;
      }
    }
  }
  HydratedBlocOverrides.runZoned(
    () => runApp(MultiBlocProvider(providers: [
      BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(LoginRepository())),
      BlocProvider<AuthenticationCubit>(
        create: (context) => AuthenticationCubit(),
      ),
      BlocProvider<UserMenuListCubit>(
        create: (context) => UserMenuListCubit(),
      ),
      BlocProvider<UserListCubit>(
        create: (context) => UserListCubit(),
      ),
      BlocProvider<MenuCubit>(
        create: (context) => MenuCubit(),
      ),
      BlocProvider<RptQueryCubit>(create: ((context) => RptQueryCubit())),
      BlocProvider<IndexListCubit>(create: ((context) => IndexListCubit())),
      BlocProvider<IndexFieldListCubit>(
          create: ((context) => IndexFieldListCubit())),
      BlocProvider<SearchCubit>(
        create: (context) => SearchCubit(),
      ),
      BlocProvider<NavigationSearchCubit>(
        create: (context) => NavigationSearchCubit(),
      )
    ], child: const MyApp(isAuthenticated: true))),
    storage: storage,
  );
}

// String apiConn = ApiPaths.baseURL.startsWith('127.')
//     ? 'localhost|${ApiPaths.baseURL}'
//     : ApiPaths.baseURL;

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.isAuthenticated}) : super(key: key);
  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
  final bool isAuthenticated;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final authService = AuthService();

  late final _appRouter = AppRouter(routeGuard: RouteGuard(authService));

  @override
  Widget build(BuildContext context) {
    print("myapp build");
    authService.authenticated = widget.isAuthenticated;
    return ChangeNotifierProvider(
      create: (_) => getIt<ThemeNotifier>(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier themeNotifier, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ezThemeData[ThemeNotifier.ezCurThemeName],
            routerDelegate: _appRouter.delegate(),
            routeInformationParser: _appRouter.defaultRouteParser(),
          );
        },
      ),
    );
  }
}
