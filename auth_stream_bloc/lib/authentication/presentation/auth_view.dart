import 'package:auth_stream_bloc/authentication/manager/authentication_bloc.dart';
import 'package:auth_stream_bloc/authentication/manager/login_bloc.dart';
import 'package:auth_stream_bloc/di_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  late final LoginBloc loginBloc;

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    loginBloc = getItInstance.get<LoginBloc>();
  }

  @override
  void dispose() {
    loginBloc.close();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LoginForm(
          authenticationBloc: authenticationBloc,
          loginBloc: loginBloc,
          usernameController: usernameController,
          passwordController: passwordController,
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final LoginBloc loginBloc;
  final AuthenticationBloc authenticationBloc;
  final TextEditingController usernameController;

  final TextEditingController passwordController;

  const LoginForm({
    Key? key,
    required this.loginBloc,
    required this.authenticationBloc,
    required this.usernameController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listener: (ctx, state) {
        if (state is LoginFailure) {
          print("ERRORRRRR ISSSS====>>> ${state.error}");
        }
      },
      builder: (
        BuildContext context,
        LoginState state,
      ) {
        return Form(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'username'),
                controller: usernameController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'password'),
                controller: passwordController,
                obscureText: true,
              ),
              FilledButton(
                onPressed:
                    state is! LoginLoading ? _onLoginButtonPressed : null,
                child: const Text('Login'),
              ),
              SizedBox(
                child: state is LoginLoading
                    ? const CircularProgressIndicator()
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  _onLoginButtonPressed() {
    loginBloc.add(LoginButtonPressed(
      username: usernameController.text,
      password: passwordController.text,
    ));
  }
}
