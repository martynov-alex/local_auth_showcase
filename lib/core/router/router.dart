import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth_showcase/core/router/auth_guard.dart';
import 'package:local_auth_showcase/core/router/redirect_builder.dart';
import 'package:local_auth_showcase/core/router/routes.dart';
import 'package:local_auth_showcase/feature/auth/domain/bloc/auth_bloc.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter getRouter(AuthBloc authBloc) => GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/login',
    routes: $appRoutes,
    refreshListenable: StreamToListenable([authBloc.stream]),
    redirect:
        RedirectBuilder({
          RedirectIfAuthenticatedGuard(),
          RedirectIfUnauthenticatedGuard(),
        }).call,
  );
}

// for convert stream to listenable
class StreamToListenable extends ChangeNotifier {
  late final List<StreamSubscription> subscriptions;

  StreamToListenable(List<Stream> streams) {
    subscriptions = [];
    for (var e in streams) {
      var s = e.asBroadcastStream().listen(_tt);
      subscriptions.add(s);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (var e in subscriptions) {
      e.cancel();
    }
    super.dispose();
  }

  void _tt(event) => notifyListeners();
}
