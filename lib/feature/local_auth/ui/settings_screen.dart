import 'package:flutter/material.dart';
import 'package:local_auth_showcase/core/router/route_wrapper.dart';
import 'package:local_auth_showcase/feature/local_auth/di/local_auth_di.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/widget/settings/view.dart';
import 'package:local_auth_showcase/main.dart';
import 'package:provider/provider.dart';

class LocalAuthSettingsScreen extends StatelessWidget implements RouteWrapper {
  const LocalAuthSettingsScreen({super.key});

  @override
  Widget wrappedRoute(Dependencies dependencies) {
    return MultiProvider(
      providers: LocalAuthDI.providers(dependencies),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _LocalAuthSettingsMain();
  }
}

class _LocalAuthSettingsMain extends StatelessWidget {
  const _LocalAuthSettingsMain();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const LocalAuthSettingsView());
  }
}
