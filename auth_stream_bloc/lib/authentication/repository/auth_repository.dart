import 'package:auth_stream_bloc/main.dart';

abstract class AuthRepository {
  Future<String> authenticate({
    required String username,
    required String password,
  });

  Future<String> register({
    required String email,
    required String password,
    required String username,
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

    final response = await supabaseClient.auth
        .signInWithPassword(password: password, email: username);

    return response.session?.accessToken ?? "";
  }

  @override
  Future<void> logout() async {
    await localStorageInstance.clearLocalStorage();
    await supabaseClient.auth.signOut();
    await Future.delayed(const Duration(
      seconds: 2,
    ));
  }

  @override
  Future<void> persistToken(String token) async {
    await Future.delayed(const Duration(
      seconds: 1,
    ));
    await localStorageInstance.writeAutoLoginKey(autoLogin: token);
    return;
  }

  @override
  Future<bool> hasToken() async {
    String isAuth = await localStorageInstance.readAutoLoginKey();

    await Future.delayed(const Duration(
      seconds: 1,
    ));

    return isAuth.isNotEmpty;
  }

  @override
  Future<String> register(
      {required String email,
      required String password,
      required String username}) async {
    await Future.delayed(const Duration(
      seconds: 2,
    ));

    final response = await supabaseClient.auth
        .signUp(password: password, email: email, data: {"username": username});

    await supabaseClient.from("users").insert({
      "user_name": username,
      "user_email": email,
      "is_active": true,
      "is_deleted": false,
      "user_image": ""
    });

    return response.session?.accessToken ?? "";
  }
}
