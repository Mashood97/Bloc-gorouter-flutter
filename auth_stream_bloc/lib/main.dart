import 'package:auth_stream_bloc/di_container.dart';
import 'package:auth_stream_bloc/local_storage.dart';
import 'package:auth_stream_bloc/navigation/route_names.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'authentication/manager/authentication_bloc.dart';

import 'navigation/go_router_navigation_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDependencies();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  runApp(const MyApp());
}

final localStorageInstance = getItInstance.get<LocalStorage>();
final AuthenticationBloc authenticationBloc =
    getItInstance.get<AuthenticationBloc>();

final _router = GoRouterNavigationDelegate();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    authenticationBloc.add(AppStarted());
  }

  @override
  void dispose() {
    authenticationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router.router,
      // home: BlocProvider.value(
      //   value: authenticationBloc,
      //   child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
      //     // buildWhen: (previous, current) => previous != current,
      //     listener: (context, state) {
      //       // TODO: implement listener
      //     },
      //     builder: (context, state) {
      //       if(state is AuthenticationUninitialized)
      //         {
      //           return const SplashPage();
      //         }
      //       if (state is AuthenticationAuthenticated) {
      //         return const HomePage();
      //       }
      //
      //       return const AuthView();
      //     },
      //   ),
      // ),
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              context.goNamed(
                  NavigationRouteNames.testRoute.convertRoutePathToRouteName);
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Center(
          child: FilledButton(
        child: const Text('logout'),
        onPressed: () {
          authenticationBloc.add(LoggedOut());
        },
      )),
    );
  }
}
