// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$loginRoute, $rootRoute];

RouteBase get $loginRoute => GoRouteData.$route(
  path: '/login',

  factory: $LoginRouteExtension._fromState,
);

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  String get location => GoRouteData.$location('/login');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $rootRoute => ShellRouteData.$route(
  navigatorKey: RootRoute.$navigatorKey,
  factory: $RootRouteExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/top-secret-info',

      factory: $TopSecretInfoRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: '/settings',

      factory: $SettingsRouteExtension._fromState,
    ),
  ],
);

extension $RootRouteExtension on RootRoute {
  static RootRoute _fromState(GoRouterState state) => const RootRoute();
}

extension $TopSecretInfoRouteExtension on TopSecretDataRoute {
  static TopSecretDataRoute _fromState(GoRouterState state) =>
      const TopSecretDataRoute();

  String get location => GoRouteData.$location('/top-secret-info');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  String get location => GoRouteData.$location('/settings');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
