import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../repository/auth_repository.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

/* We used Hydrated Bloc because we don't want our app to share Initial state (AuthenticationUninitialized) state again and again when we refresh the page on web/desktop platforms
* instead it will return the last saved status i.e if authenticated then it will return status as AuthenticationAuthenticated else AuthenticationUnauthenticated */
class AuthenticationBloc
    extends HydratedBloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository;

  AuthenticationBloc({
    required this.authRepository,
  }) : super(const AuthenticationUninitialized()) {
    on<AuthenticationEvent>(_onEvent);
  }

  Future<void> _onEvent(
      AuthenticationEvent event, Emitter<AuthenticationState> emit) async {
    if (event is AppStarted) {
      final bool hasToken = await authRepository.hasToken();

      if (hasToken) {
        emit(const AuthenticationAuthenticated());
      } else {
        emit(const AuthenticationUnauthenticated());
      }
    }

    if (event is LoggedIn) {
      emit(const AuthenticationLoading());

      await authRepository.persistToken(event.token);
      emit(const AuthenticationAuthenticated());
    }

    if (event is LoggedOut) {
      emit(const AuthenticationLoading());

      await authRepository.logout();
      emit(const AuthenticationUnauthenticated());
    }
  }

  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      bool isAuthenticated = json['data'];
      return isAuthenticated
          ? const AuthenticationAuthenticated()
          : const AuthenticationUnauthenticated();
    }

    return const AuthenticationUninitialized();
  }

  @override
  Map<String, dynamic>? toJson(AuthenticationState state) {
    return {
      "data": state is AuthenticationAuthenticated ? true : false,
    };
  }
}
