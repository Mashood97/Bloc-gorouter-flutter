import 'dart:async';

import 'package:auth_stream_bloc/authentication/presentation/auth_view.dart';
import 'package:auth_stream_bloc/main.dart';
import 'package:auth_stream_bloc/navigation/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../authentication/manager/authentication_bloc.dart';

extension StringExtensions on String {
  String get convertRoutePathToRouteName => replaceAll("/", "");
}

class GoRouterNavigationDelegate {
  static final GoRouterNavigationDelegate _singleton =
      GoRouterNavigationDelegate._internal();

  factory GoRouterNavigationDelegate() {
    return _singleton;
  }

  List<String> routes = [NavigationRouteNames.authRoute];

  GoRouterNavigationDelegate._internal();

  final parentNavigationKey = GlobalKey<NavigatorState>();
  late final GoRouter router = GoRouter(
    navigatorKey: parentNavigationKey,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(authenticationBloc.stream),
    redirect: (ctx, state) async {
      final status = authenticationBloc.state;

      //This will check when the app starts its un initialized so we return splash.

      if (status is AuthenticationUninitialized) {
        return NavigationRouteNames.initialRoute;
      }

      final loggedIn = status is AuthenticationAuthenticated;
      if (loggedIn) {
        //if the user is logged in and we restart the app then we show the splash first to maintain the flow.
        routes.add(
          NavigationRouteNames.initialRoute,
        );
      }
      final logging = routes.contains(state.matchedLocation);

      if (!loggedIn) return logging ? null : NavigationRouteNames.authRoute;

      // if the user is logged in but still on the login page, send them to
      // the home page
      if (logging) return NavigationRouteNames.homeRoute;

      return null;
    },
    initialLocation: NavigationRouteNames.initialRoute,
    routes: [
      GoRoute(
        parentNavigatorKey: parentNavigationKey,
        path: NavigationRouteNames.initialRoute,
        name: NavigationRouteNames.initialRoute.convertRoutePathToRouteName,
        builder: (BuildContext ctx, GoRouterState state) => const SplashPage(),
      ),
      GoRoute(
        path: NavigationRouteNames.authRoute,
        name: NavigationRouteNames.authRoute.convertRoutePathToRouteName,
        builder: (BuildContext ctx, GoRouterState state) => const AuthView(),
      ),
      GoRoute(
        path: NavigationRouteNames.homeRoute,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HomePage(),
        ),
      ),
      GoRoute(
        path: NavigationRouteNames.testRoute,
        name: NavigationRouteNames.testRoute.convertRoutePathToRouteName,
        builder: (context, state) => Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: Text("Test Route"),
          ),
        ),
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
