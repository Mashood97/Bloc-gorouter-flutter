import 'dart:async';

import 'package:auth_stream_bloc/main.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../repository/auth_repository.dart';
import 'authentication_bloc.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository userRepository;

  RegisterBloc({
    required this.userRepository,
  }) : super(const RegisterInitial()) {
    on<RegisterEvent>(_onRegisterEvent);
  }


  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  Future<void> _onRegisterEvent(
      RegisterEvent event, Emitter<RegisterState> emit) async {
    if (event is RegisterButtonPressed) {
      emit(const RegisterLoading());
      try {
        final token = await userRepository.register(
            username: event.username,
            password: event.password,
            email: event.email);

        authenticationBloc.add(LoggedIn(token: token));
        emit(const RegisterInitial());
      } catch (error) {
        emit(RegisterFailure(error: error.toString()));
      }
    }
  }
}
