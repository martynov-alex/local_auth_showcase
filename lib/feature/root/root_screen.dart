import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';
import 'package:local_auth_showcase/core/router/routes.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key, required this.navigator});

  final Widget navigator;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/settings')) {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = getCurrentIndex(context);

    return Scaffold(
      body: Center(child: widget.navigator),
      bottomNavigationBar: NavigationBar(
        labelTextStyle: WidgetStateTextStyle.resolveWith(
          (_) => context.textTheme.labelLarge!,
        ),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.security),
            label: 'Top Secret Data',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          switch (index) {
            case 0:
              const TopSecretDataRoute().go(context);
            case 1:
              const SettingsRoute().go(context);
          }
        },
      ),
    );
  }
}
