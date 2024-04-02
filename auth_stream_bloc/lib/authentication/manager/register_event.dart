part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterButtonPressed extends RegisterEvent {
  final String username;
  final String email;
  final String password;

  const RegisterButtonPressed({
    required this.username,
    required this.password,
    required this.email,
  });

  @override
  List<Object> get props => [username, password, email];

  @override
  String toString() =>
      'RegisterButtonPressed { username: $username, password: $password , email: $email}';
}
