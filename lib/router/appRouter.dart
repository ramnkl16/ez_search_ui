import 'package:auto_route/auto_route.dart';
import 'package:ez_search_ui/constants/navigation_path.dart';
import 'package:ez_search_ui/modules/home/home.dart';
import 'package:ez_search_ui/modules/indexes/indexes.base_list.dart';
import 'package:ez_search_ui/modules/indexfields/indexfields.base_list.dart';

import 'package:ez_search_ui/modules/login/login.page.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.base_list.dart';
import 'package:ez_search_ui/modules/search/search.list.page.dart';
import 'package:ez_search_ui/modules/user/user.base_list.dart';
import 'package:ez_search_ui/router/routeguard.dart';

@MaterialAutoRouter(
    //replaceInRouteName: 'Page,Route',
    routes: <AutoRoute>[
      AutoRoute(page: LoginPage, name: "LoginRoute", path: "login"),
      AutoRoute(page: HomePage, name: "HomeRoute", path: "/", guards: [
        RouteGuard
      ], children: [
        AutoRoute(
            page: SearchPage,
            initial: true,
            name: "SearchRoute",
            path: "search"),
        AutoRoute(name: "UserRoute", path: 'user', page: UserPage),
        AutoRoute(name: "QueryRoute", path: 'query', page: RptQueryPage),
        AutoRoute(name: "IndexesRoute", path: 'indexes', page: IndexesPage),
        AutoRoute(name: "FieldsRoute", path: 'fields', page: IndexFieldsPage),

        //path: '/report_def', page: RptQueryPage, initial: false),
      ])
    ])

// AutoRoute(page: LoginPage, path: NavigationPath.loginPageBase),
// AutoRoute(page: BookDetailsPage),
//],
//)
class $AppRouter {}
