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

import '../modules/home/home.dart' as _i2;
import '../modules/indexes/indexes.base_list.dart' as _i6;
import '../modules/indexfields/indexfields.base_list.dart' as _i7;
import '../modules/login/login.page.dart' as _i1;
import '../modules/rptquery/rptquery.base_list.dart' as _i5;
import '../modules/search/search.list.page.dart' as _i3;
import '../modules/user/user.base_list.dart' as _i4;
import 'routeguard.dart' as _i10;

class AppRouter extends _i8.RootStackRouter {
  AppRouter(
      {_i9.GlobalKey<_i9.NavigatorState>? navigatorKey,
      required this.routeGuard})
      : super(navigatorKey);

  final _i10.RouteGuard routeGuard;

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i1.LoginPage(
              key: args.key, onLoginCallback: args.onLoginCallback));
    },
    HomeRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.HomePage());
    },
    SearchRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.SearchPage());
    },
    UserRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.UserPage());
    },
    QueryRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.RptQueryPage());
    },
    IndexesRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.IndexesPage());
    },
    FieldsRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i7.IndexFieldsPage());
    }
  };

  @override
  List<_i8.RouteConfig> get routes => [
        _i8.RouteConfig(LoginRoute.name, path: 'login'),
        _i8.RouteConfig(HomeRoute.name, path: '/', guards: [
          routeGuard
        ], children: [
          _i8.RouteConfig('#redirect',
              path: '',
              parent: HomeRoute.name,
              redirectTo: 'search',
              fullMatch: true),
          _i8.RouteConfig(SearchRoute.name,
              path: 'search', parent: HomeRoute.name),
          _i8.RouteConfig(UserRoute.name, path: 'user', parent: HomeRoute.name),
          _i8.RouteConfig(QueryRoute.name,
              path: 'query', parent: HomeRoute.name),
          _i8.RouteConfig(IndexesRoute.name,
              path: 'indexes', parent: HomeRoute.name),
          _i8.RouteConfig(FieldsRoute.name,
              path: 'fields', parent: HomeRoute.name)
        ])
      ];
}

/// generated route for
/// [_i1.LoginPage]
class LoginRoute extends _i8.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({_i9.Key? key, required dynamic Function(bool) onLoginCallback})
      : super(LoginRoute.name,
            path: 'login',
            args: LoginRouteArgs(key: key, onLoginCallback: onLoginCallback));

  static const String name = 'LoginRoute';
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, required this.onLoginCallback});

  final _i9.Key? key;

  final dynamic Function(bool) onLoginCallback;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLoginCallback: $onLoginCallback}';
  }
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute({List<_i8.PageRouteInfo>? children})
      : super(HomeRoute.name, path: '/', initialChildren: children);

  static const String name = 'HomeRoute';
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
class QueryRoute extends _i8.PageRouteInfo<void> {
  const QueryRoute() : super(QueryRoute.name, path: 'query');

  static const String name = 'QueryRoute';
}

/// generated route for
/// [_i6.IndexesPage]
class IndexesRoute extends _i8.PageRouteInfo<void> {
  const IndexesRoute() : super(IndexesRoute.name, path: 'indexes');

  static const String name = 'IndexesRoute';
}

/// generated route for
/// [_i7.IndexFieldsPage]
class FieldsRoute extends _i8.PageRouteInfo<void> {
  const FieldsRoute() : super(FieldsRoute.name, path: 'fields');

  static const String name = 'FieldsRoute';
}
