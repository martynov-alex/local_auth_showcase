import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth_showcase/core/router/redirect_builder.dart';
import 'package:local_auth_showcase/feature/app/app.dart';
import 'package:local_auth_showcase/feature/auth/domain/entity/authentication_status.dart';

/// Guard that navigates user from unauthorized routes to dashboard
/// if the user is authenticated.
final class RedirectIfAuthenticatedGuard extends RedirectGuard {
  // matches login and signup routes
  @override
  Pattern get matchPattern => RegExp(r'^/login$');

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final auth = DependenciesScope.of(context).authBloc.state;

    if (auth.status == AuthenticationStatus.authenticated) {
      return '/top-secret-data';
    }

    return null;
  }
}

/// Guard that navigates user from authorized routes to login
/// when their authentication status is unauthenticated.
final class RedirectIfUnauthenticatedGuard extends RedirectGuard {
  // matches dashboard and settings routes
  @override
  Pattern get matchPattern => RegExp(r'^/login$');

  @override
  bool get invertMatch => true;

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final auth = DependenciesScope.of(context).authBloc.state;

    if (auth.status == AuthenticationStatus.unauthenticated) {
      return '/login';
    }

    return null;
  }
}
