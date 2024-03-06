import 'package:auth_stream_bloc/main.dart';

abstract class AuthRepository {
  Future<String> authenticate({
    required String username,
    required String password,
  });

  Future<void> logout();

  Future<void> persistToken(String token);

  Future<bool> hasToken();
}

final class AuthRepoImpl implements AuthRepository {
  @override
  Future<String> authenticate({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(
      seconds: 2,
    ));

    return 'token';
  }

  @override
  Future<void> logout() async {
    await localStorageInstance.clearLocalStorage();
    await Future.delayed(const Duration(
      seconds: 2,
    ));

  }

  @override
  Future<void> persistToken(String token) async {
    await Future.delayed(const Duration(
      seconds: 1,
    ));
    await localStorageInstance.writeAutoLoginKey(autoLogin: "true");
    return;
  }

  @override
  Future<bool> hasToken() async {
    String isAuth = await localStorageInstance.readAutoLoginKey();

    await Future.delayed(const Duration(
      seconds: 1,
    ));

    return isAuth == "true";
  }
}
