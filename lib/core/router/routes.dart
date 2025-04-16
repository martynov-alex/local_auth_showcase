import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth_showcase/feature/app/app.dart';
import 'package:local_auth_showcase/feature/auth/widget/login_screen.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/initial_screen.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/settings_screen.dart';
import 'package:local_auth_showcase/feature/root/root_screen.dart';
import 'package:local_auth_showcase/feature/settings/settings_screen.dart';
import 'package:local_auth_showcase/feature/top_secret_data/top_secret_data_screen.dart';

part 'routes.g.dart';

final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

@TypedGoRoute<LoginRouteData>(path: '/login')
class LoginRouteData extends GoRouteData {
  const LoginRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

@TypedShellRoute<RootRouteData>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<TopSecretDataRouteData>(path: '/top-secret-data'),
    TypedGoRoute<SettingsRouteData>(
      path: '/settings',
      routes: <TypedRoute<GoRouteData>>[
        TypedGoRoute<LocalAuthInitialRouteData>(path: 'local-auth-initial'),
        TypedGoRoute<LocalAuthSettingsRouteData>(path: 'local-auth-settings'),
      ],
    ),
  ],
)
class RootRouteData extends ShellRouteData {
  const RootRouteData();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return RootScreen(navigator: navigator);
  }
}

class TopSecretDataRouteData extends GoRouteData {
  const TopSecretDataRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const TopSecretDataScreen();
}

class SettingsRouteData extends GoRouteData {
  const SettingsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

class LocalAuthInitialRouteData extends GoRouteData {
  const LocalAuthInitialRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final dependencies = DependenciesScope.of(context);
    return const LocalAuthInitialScreen().wrappedRoute(dependencies);
  }
}

class LocalAuthSettingsRouteData extends GoRouteData {
  const LocalAuthSettingsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final dependencies = DependenciesScope.of(context);
    return const LocalAuthSettingsScreen().wrappedRoute(dependencies);
  }
}
