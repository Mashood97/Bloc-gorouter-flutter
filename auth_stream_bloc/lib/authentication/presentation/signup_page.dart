import 'package:auth_stream_bloc/authentication/manager/register_bloc.dart';
import 'package:auth_stream_bloc/di_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../navigation/app_navigations.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final RegisterBloc registerBloc;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void initState() {
    registerBloc = getItInstance.get<RegisterBloc>();
    super.initState();
  }

  @override
  void dispose() {
    registerBloc.close();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<RegisterBloc, RegisterState>(
          bloc: registerBloc,
          listener: (ctx, state) {
            if (state is RegisterFailure) {
              print("ERRORRRRR ISSSS====>>> ${state.error}");
            }
          },
          builder: (ctx, state) {
            if (state is RegisterLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return Form(
              key: registerBloc.registerKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'username'),
                    controller: usernameController,
                    validator: (val) =>
                        val?.isEmpty == true ? "Please enter username" : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'email'),
                    controller: emailController,
                    validator: (val) =>
                        val?.isEmpty == true ? "Please enter email" : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'password'),
                    controller: passwordController,
                    obscureText: true,
                    validator: (val) =>
                        val?.isEmpty == true ? "Please enter password" : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FilledButton(
                    onPressed: state is! RegisterLoading
                        ? () {
                            if (registerBloc.registerKey.currentState
                                    ?.validate() ==
                                true) {
                              _onRegisterButtonPressed();
                            }
                          }
                        : null,
                    child: const Text('Register'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      AppNavigations().navigateBack(context: context);
                    },
                    child: const Text("Login"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _onRegisterButtonPressed() {
    registerBloc.add(RegisterButtonPressed(
      username: usernameController.text,
      password: passwordController.text,
      email: emailController.text,
    ));
  }
}
