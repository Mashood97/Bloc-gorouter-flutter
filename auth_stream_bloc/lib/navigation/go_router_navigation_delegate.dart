import 'dart:async';

import 'package:auth_stream_bloc/authentication/presentation/auth_view.dart';
import 'package:auth_stream_bloc/authentication/presentation/signup_page.dart';
import 'package:auth_stream_bloc/chat/presentation/user_chat_details_view.dart';
import 'package:auth_stream_bloc/main.dart';
import 'package:auth_stream_bloc/navigation/route_names.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../authentication/manager/authentication_bloc.dart';
import '../chat/presentation/user_chats_view.dart';

extension StringExtensions on String {
  String get convertRoutePathToRouteName => replaceAll("/", "");
}

class GoRouterNavigationDelegate {
  static final GoRouterNavigationDelegate _singleton =
      GoRouterNavigationDelegate._internal();

  factory GoRouterNavigationDelegate() {
    return _singleton;
  }

  List<String> routes = [
    NavigationRouteNames.authRoute,
    "${NavigationRouteNames.authRoute}${NavigationRouteNames.signUpRoute}"
  ];

  GoRouterNavigationDelegate._internal();

  final parentNavigationKey = GlobalKey<NavigatorState>();
  late final GoRouter router = GoRouter(
    navigatorKey: parentNavigationKey,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(authenticationBloc.stream),
    redirect: (ctx, state) async {
      final status = authenticationBloc.state;

      final loggedIn = status is AuthenticationAuthenticated;

      final logging = routes.contains(state.matchedLocation);

      if (!loggedIn && !logging) return NavigationRouteNames.authRoute;

      if (loggedIn && logging) return NavigationRouteNames.homeRoute;

      return null;
    },
    initialLocation:

        // : kIsWeb
        // ? NavigationRouteNames.initialRoute
        // :

        authenticationBloc.state is AuthenticationAuthenticated
            ? NavigationRouteNames.homeRoute
            : NavigationRouteNames.initialRoute,
    // NavigationRouteNames.initialRoute,
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
          routes: [
            GoRoute(
              path:
                  NavigationRouteNames.signUpRoute.convertRoutePathToRouteName,
              name:
                  NavigationRouteNames.signUpRoute.convertRoutePathToRouteName,
              builder: (BuildContext ctx, GoRouterState state) =>
                  const SignUpPage(),
            ),
          ]),
      GoRoute(
        path: NavigationRouteNames.homeRoute,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: UserChatsView(),
        ),
      ),
      GoRoute(
        path: NavigationRouteNames.chatDetailRoute,
        name: NavigationRouteNames.chatDetailRoute.convertRoutePathToRouteName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: UserChatDetailsView(),
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
