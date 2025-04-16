// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$loginRouteData, $rootRouteData];

RouteBase get $loginRouteData => GoRouteData.$route(
  path: '/login',

  factory: $LoginRouteDataExtension._fromState,
);

extension $LoginRouteDataExtension on LoginRouteData {
  static LoginRouteData _fromState(GoRouterState state) =>
      const LoginRouteData();

  String get location => GoRouteData.$location('/login');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $rootRouteData => ShellRouteData.$route(
  navigatorKey: RootRouteData.$navigatorKey,
  factory: $RootRouteDataExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/top-secret-data',

      factory: $TopSecretDataRouteDataExtension._fromState,
    ),
    GoRouteData.$route(
      path: '/settings',

      factory: $SettingsRouteDataExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'local-auth-initial',

          factory: $LocalAuthInitialRouteDataExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'local-auth-settings',

          factory: $LocalAuthSettingsRouteDataExtension._fromState,
        ),
      ],
    ),
  ],
);

extension $RootRouteDataExtension on RootRouteData {
  static RootRouteData _fromState(GoRouterState state) => const RootRouteData();
}

extension $TopSecretDataRouteDataExtension on TopSecretDataRouteData {
  static TopSecretDataRouteData _fromState(GoRouterState state) =>
      const TopSecretDataRouteData();

  String get location => GoRouteData.$location('/top-secret-data');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsRouteDataExtension on SettingsRouteData {
  static SettingsRouteData _fromState(GoRouterState state) =>
      const SettingsRouteData();

  String get location => GoRouteData.$location('/settings');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LocalAuthInitialRouteDataExtension on LocalAuthInitialRouteData {
  static LocalAuthInitialRouteData _fromState(GoRouterState state) =>
      const LocalAuthInitialRouteData();

  String get location => GoRouteData.$location('/settings/local-auth-initial');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LocalAuthSettingsRouteDataExtension on LocalAuthSettingsRouteData {
  static LocalAuthSettingsRouteData _fromState(GoRouterState state) =>
      const LocalAuthSettingsRouteData();

  String get location => GoRouteData.$location('/settings/local-auth-settings');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
