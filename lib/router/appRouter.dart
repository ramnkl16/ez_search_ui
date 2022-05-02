import 'package:auto_route/auto_route.dart';
import 'package:ez_search_ui/constants/navigation_path.dart';
import 'package:ez_search_ui/modules/home/home.dart';

import 'package:ez_search_ui/modules/login/login.page.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.base_list.dart';
import 'package:ez_search_ui/modules/search/search.list.page.dart';
import 'package:ez_search_ui/modules/user/user.base_list.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    RedirectRoute(
        path: NavigationPath.loginPageBase,
        redirectTo: NavigationPath.homePageBase),
    AutoRoute(page: HomePage, initial: true, path: '/', children: [
      AutoRoute<String>(path: 'search', page: SearchPage, initial: true),
      AutoRoute(path: 'user', page: UserPage),
      AutoRoute(path: 'query', page: RptQueryPage),

      //path: '/report_def', page: RptQueryPage, initial: false),
    ]),
    AutoRoute(page: LoginPage, path: NavigationPath.loginPageBase),

    // AutoRoute(page: LoginPage, path: NavigationPath.loginPageBase),
    // AutoRoute(page: BookDetailsPage),
  ],
)
class $AppRouter {}
