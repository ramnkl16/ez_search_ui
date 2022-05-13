import 'package:ez_search_ui/common/global.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/cubit/hydratedCubit.dart';
import 'package:ez_search_ui/helper/utilfunc.dart';
import 'package:ez_search_ui/modules/authentication/authentication.cubit.dart';
import 'package:ez_search_ui/modules/home/home.dart';
import 'package:ez_search_ui/modules/home/themenotifier.dart';
import 'package:ez_search_ui/modules/indexes/indexes.cubit.dart';
import 'package:ez_search_ui/modules/indexfields/indexesFields.cubit.dart';
import 'package:ez_search_ui/modules/login/login.logic.cubit.dart';
import 'package:ez_search_ui/modules/login/login.repo.dart';
import 'package:ez_search_ui/modules/menu/menu.cubit.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.cubit.dart';
import 'package:ez_search_ui/modules/search/search.cubit.dart';
import 'package:ez_search_ui/modules/user/user.cubit.dart';
import 'package:ez_search_ui/router/appRouter.gr.dart';

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
  if (token != null) isAuthenticated = true;
  var conn = await prefs.getApiActiveConn();
  if (conn != null) apiConn = conn;
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
    ], child: MyApp())),
    storage: storage,
  );
}

bool isAuthenticated = false;
String apiConn = ApiPaths.baseURL.startsWith('127.')
    ? 'localhost|${ApiPaths.baseURL}'
    : ApiPaths.baseURL;

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  final _appRouter = getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    print("myapp build");

    return BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          print('Auth listnener called');
          print(isAuthenticated);
        },
        child: ChangeNotifierProvider(
          create: (_) => ThemeModel(),
          child: Consumer<ThemeModel>(
            builder: (context, ThemeModel themeNotifier, child) {
              print('buildThemeDropDown, ${themeNotifier.isDark}');
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: themeNotifier.isDark!
                    ? ThemeData.dark()
                    : ThemeData.light(),

                //home: HomePage(),
                // theme: ThemeData(
                //     // dialogTheme: DialogTheme(),
                //     appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
                //     colorScheme: ColorScheme.fromSwatch(
                //         // accentColor: AppColors.calendarHeaderColor,
                //         ),
                //     // textTheme: TextTheme()
                //     inputDecorationTheme: InputDecorationTheme(
                //         border: OutlineInputBorder(
                //             borderRadius: BorderRadius.all(Radius.circular(5))))),

                routerDelegate: _appRouter.delegate(
                    //initialRoutes: [if (isAuthenticated) HomeRoute() else LoginRoute()]
                    ),
                routeInformationParser: _appRouter.defaultRouteParser(),
                // backButtonDispatcher:
                //     BeamerBackButtonDispatcher(delegate: routerDelegate),
                // home: const CounterPage(),
              );
            },
          ),
        ));
  }
}
