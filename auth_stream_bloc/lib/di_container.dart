import 'package:auth_stream_bloc/authentication/manager/authentication_bloc.dart';
import 'package:auth_stream_bloc/authentication/manager/register_bloc.dart';
import 'package:auth_stream_bloc/authentication/repository/auth_repository.dart';
import 'package:auth_stream_bloc/chat/repository/chat_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'authentication/manager/login_bloc.dart';
import 'chat/manager/chats_bloc.dart';
import 'local_storage.dart' as ls;

AndroidOptions getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

final getItInstance = GetIt.instance;

void initializeDependencies() {
  _initializeBlocsAndCubits();
  _initializeRepositories();

  _initializeExternalPackages();
}

void _initializeBlocsAndCubits() {
  getItInstance.registerFactory(
    () => AuthenticationBloc(
      authRepository: getItInstance(),
    ),
  );
  getItInstance.registerFactory(
    () => LoginBloc(
      userRepository: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
        () => RegisterBloc(
      userRepository: getItInstance(),
    ),
  );
  getItInstance.registerFactory(
        () => ChatsBloc(
      chatRepository: getItInstance(),
    ),
  );
}

void _initializeRepositories() {
  getItInstance.registerLazySingleton<AuthRepository>(
    () => AuthRepoImpl(),
  );

  getItInstance.registerLazySingleton<ChatRepository>(
        () => ChatRepositoryImplementation(),
  );
}

void _initializeExternalPackages() {
  //local storage
  final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
  getItInstance.registerLazySingleton(() => storage);

  final localStorage = ls.LocalStorage();
  getItInstance.registerLazySingleton(() => localStorage);
  final SupabaseClient instance = Supabase.instance.client;
  getItInstance.registerLazySingleton(() => instance);
}
