// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;

import '../modules/home/home.dart' as _i1;
import '../modules/indexes/indexes.base_list.dart' as _i6;
import '../modules/indexfields/indexfields.base_list.dart' as _i7;
import '../modules/login/login.page.dart' as _i2;
import '../modules/rptquery/rptquery.base_list.dart' as _i5;
import '../modules/search/search.list.page.dart' as _i3;
import '../modules/user/user.base_list.dart' as _i4;

class AppRouter extends _i8.RootStackRouter {
  AppRouter([_i9.GlobalKey<_i9.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.HomePage());
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>(
          orElse: () => const LoginRouteArgs());
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i2.LoginPage(
              key: args.key,
              onLoginSuccess: args.onLoginSuccess,
              redirectRoute: args.redirectRoute));
    },
    SearchRoute.name: (routeData) {
      return _i8.MaterialPageX<String>(
          routeData: routeData, child: const _i3.SearchPage());
    },
    UserRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.UserPage());
    },
    RptQueryRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.RptQueryPage());
    },
    IndexesRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.IndexesPage());
    },
    IndexFieldsRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i7.IndexFieldsPage());
    }
  };

  @override
  List<_i8.RouteConfig> get routes => [
        _i8.RouteConfig('login#redirect',
            path: 'login', redirectTo: '/', fullMatch: true),
        _i8.RouteConfig(HomeRoute.name, path: '/', children: [
          _i8.RouteConfig('#redirect',
              path: '',
              parent: HomeRoute.name,
              redirectTo: 'search',
              fullMatch: true),
          _i8.RouteConfig(SearchRoute.name,
              path: 'search', parent: HomeRoute.name),
          _i8.RouteConfig(UserRoute.name, path: 'user', parent: HomeRoute.name),
          _i8.RouteConfig(RptQueryRoute.name,
              path: 'query', parent: HomeRoute.name),
          _i8.RouteConfig(IndexesRoute.name,
              path: 'indexes', parent: HomeRoute.name),
          _i8.RouteConfig(IndexFieldsRoute.name,
              path: 'fields', parent: HomeRoute.name)
        ]),
        _i8.RouteConfig(LoginRoute.name, path: 'login')
      ];
}

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute({List<_i8.PageRouteInfo>? children})
      : super(HomeRoute.name, path: '/', initialChildren: children);

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i8.PageRouteInfo<LoginRouteArgs> {
  LoginRoute(
      {_i9.Key? key,
      dynamic Function(bool)? onLoginSuccess,
      String? redirectRoute})
      : super(LoginRoute.name,
            path: 'login',
            args: LoginRouteArgs(
                key: key,
                onLoginSuccess: onLoginSuccess,
                redirectRoute: redirectRoute));

  static const String name = 'LoginRoute';
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, this.onLoginSuccess, this.redirectRoute});

  final _i9.Key? key;

  final dynamic Function(bool)? onLoginSuccess;

  final String? redirectRoute;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLoginSuccess: $onLoginSuccess, redirectRoute: $redirectRoute}';
  }
}

/// generated route for
/// [_i3.SearchPage]
class SearchRoute extends _i8.PageRouteInfo<void> {
  const SearchRoute() : super(SearchRoute.name, path: 'search');

  static const String name = 'SearchRoute';
}

/// generated route for
/// [_i4.UserPage]
class UserRoute extends _i8.PageRouteInfo<void> {
  const UserRoute() : super(UserRoute.name, path: 'user');

  static const String name = 'UserRoute';
}

/// generated route for
/// [_i5.RptQueryPage]
class RptQueryRoute extends _i8.PageRouteInfo<void> {
  const RptQueryRoute() : super(RptQueryRoute.name, path: 'query');

  static const String name = 'RptQueryRoute';
}

/// generated route for
/// [_i6.IndexesPage]
class IndexesRoute extends _i8.PageRouteInfo<void> {
  const IndexesRoute() : super(IndexesRoute.name, path: 'indexes');

  static const String name = 'IndexesRoute';
}

/// generated route for
/// [_i7.IndexFieldsPage]
class IndexFieldsRoute extends _i8.PageRouteInfo<void> {
  const IndexFieldsRoute() : super(IndexFieldsRoute.name, path: 'fields');

  static const String name = 'IndexFieldsRoute';
}
