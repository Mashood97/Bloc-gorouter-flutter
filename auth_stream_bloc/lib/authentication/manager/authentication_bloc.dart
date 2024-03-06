import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../repository/auth_repository.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
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
}
