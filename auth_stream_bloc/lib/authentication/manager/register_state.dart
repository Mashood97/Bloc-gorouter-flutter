part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
  @override
  List<Object> get props => [];
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();

  @override
  List<Object?> get props => [];
}

class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'RegisterFailure { error: $error }';
}
