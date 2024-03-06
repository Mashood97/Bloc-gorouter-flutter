part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {
  const AuthenticationUninitialized();
}

class AuthenticationAuthenticated extends AuthenticationState {
  const AuthenticationAuthenticated();
}

class AuthenticationUnauthenticated extends AuthenticationState {
  const AuthenticationUnauthenticated();
}

class AuthenticationLoading extends AuthenticationState {

  const AuthenticationLoading();
}