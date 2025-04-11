import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth_showcase/core/router/auth_guard.dart';
import 'package:local_auth_showcase/core/router/redirect_builder.dart';
import 'package:local_auth_showcase/core/router/routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter getRouter(StreamToListenable listenable) => GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/login',
    routes: $appRoutes,
    refreshListenable: listenable,
    redirect:
        RedirectBuilder({
          RedirectIfAuthenticatedGuard(),
          RedirectIfUnauthenticatedGuard(),
        }).call,
  );
}

// Converts stream to listenable.
class StreamToListenable extends ChangeNotifier {
  final List<StreamSubscription> subscriptions = [];

  StreamToListenable(List<Stream> streams) {
    for (final e in streams) {
      final s = e.asBroadcastStream().listen(_tt);
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
