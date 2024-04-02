import 'dart:async';
import 'package:auth_stream_bloc/authentication/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../main.dart';
import 'authentication_bloc.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository userRepository;

  LoginBloc({
    required this.userRepository,
  }) : super(const LoginInitial()) {
    on<LoginEvent>(_onEvent);
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> _onEvent(LoginEvent event, Emitter<LoginState> emit) async {
    if (event is LoginButtonPressed) {
      emit(const LoginLoading());
      try {
        final token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );

        authenticationBloc.add(LoggedIn(token: token));
        emit(const LoginInitial());
      } catch (error) {
        emit(LoginFailure(error: error.toString()));
      }
    }
  }
}
