import 'package:auth_stream_bloc/navigation/route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class AppNavigations {
  static final AppNavigations _instance = AppNavigations._internal();

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory AppNavigations() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  AppNavigations._internal();

  void navigateBack({required BuildContext context, dynamic value}) {
    context.pop(value);
  }

  void navigateFromAuthToDashboard({required BuildContext context}) {
    context.go(
      NavigationRouteNames.homeRoute,
    );
  }
}
