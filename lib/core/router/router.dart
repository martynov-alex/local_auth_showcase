import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth_showcase/core/router/routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  routes: $appRoutes,
  initialLocation: '/login',
  navigatorKey: rootNavigatorKey,
);
