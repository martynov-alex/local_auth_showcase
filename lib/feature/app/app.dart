import 'package:flutter/material.dart';
import 'package:local_auth_showcase/core/extensions/context_extension.dart';
import 'package:local_auth_showcase/feature/app/material_context.dart';
import 'package:local_auth_showcase/main.dart';

class App extends StatelessWidget {
  const App({super.key, required this.dependencies});

  final Dependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(
      dependencies: dependencies,
      child: MaterialContext(),
    );
  }
}

class DependenciesScope extends InheritedWidget {
  const DependenciesScope({
    required super.child,
    required this.dependencies,
    super.key,
  });

  final Dependencies dependencies;

  /// Get the dependencies from the [context].
  static Dependencies of(BuildContext context) =>
      context.inhOf<DependenciesScope>(listen: false).dependencies;

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => false;
}
