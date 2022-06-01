import 'package:auto_route/auto_route.dart';
import 'package:ez_search_ui/router/appRouter.gr.dart';
import 'package:ez_search_ui/services/authservice.dart';

class RouteGuard extends AutoRedirectGuard {
  final AuthService authService;

  RouteGuard(this.authService) {
    authService.addListener(() {
      if (!authService.authenticated) {
        // should be called when the logic effecting this guard changes
        print("e.g when the user is no longer authenticated");
        reevaluate();
      }
    });
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    print('onNavigation|${authService.authenticated}');
    if (authService.authenticated) {
      print('onNavigation|authService.authenticated');
      return resolver.next();
    }
    router.push(
      LoginRoute(
        onLoginCallback: (_) {
          print('onNavigation|onLoginSuccess');
          resolver.next();
          router.removeLast();
        },
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
