import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth_showcase/feature/auth/login_screen.dart';
import 'package:local_auth_showcase/feature/root/root_screen.dart';
import 'package:local_auth_showcase/feature/settings/settings_screen.dart';
import 'package:local_auth_showcase/feature/top_secret_data/top_secret_data_screen.dart';

part 'routes.g.dart';

final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

@TypedShellRoute<RootRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<TopSecretDataRoute>(path: '/top-secret-data'),
    TypedGoRoute<SettingsRoute>(path: '/settings'),
  ],
)
class RootRoute extends ShellRouteData {
  const RootRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return RootScreen(navigator: navigator);
  }
}

class TopSecretDataRoute extends GoRouteData {
  const TopSecretDataRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const TopSecretDataScreen();
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}
