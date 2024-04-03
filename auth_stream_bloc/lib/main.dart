import 'package:auth_stream_bloc/di_container.dart';
import 'package:auth_stream_bloc/local_storage.dart' as ls;

import 'package:auth_stream_bloc/utils/app_secrets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'authentication/manager/authentication_bloc.dart';

import 'navigation/go_router_navigation_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseKey,
  );
  initializeDependencies();

  runApp(const MyApp());
}

final localStorageInstance = getItInstance.get<ls.LocalStorage>();
final supabaseClient = getItInstance.get<SupabaseClient>();
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: false,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          filledButtonTheme: const FilledButtonThemeData(
              style: ButtonStyle(
            fixedSize: MaterialStatePropertyAll(
              Size(350, 55),
            ),
          ))),
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



double getResponsiveValue(BuildContext context, double baseValue) {
  final screenWidth = MediaQuery.of(context).size.width;

  // Define scaling factors for different screen widths
  // Adjust these values to suit your design preferences
  if (screenWidth < 600) {
    // Small screen size
    return baseValue * 0.8;
  } else if (screenWidth >= 600 && screenWidth < 1000) {
    // Medium screen size
    return baseValue;
  } else {
    if (screenWidth > 2000) {
      return baseValue * 2.5;
    }
    // Large screen size
    return baseValue * 1.2;
  }
}
