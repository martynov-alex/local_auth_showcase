import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_showcase/core/extensions/context_extension.dart';
import 'package:local_auth_showcase/feature/app/material_context.dart';
import 'package:local_auth_showcase/feature/auth/domain/bloc/auth_bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/local_auth_status/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/pin_code_auth/bloc.dart';
import 'package:local_auth_showcase/main.dart';

class App extends StatelessWidget {
  const App({super.key, required this.dependencies});

  final Dependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(
      dependencies: dependencies,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => dependencies.authBloc,
          ),
          BlocProvider<LocalAuthStatusBloc>(
            create: (BuildContext context) => dependencies.localAuthStatusBloc,
          ),
          BlocProvider<PinCodeAuthBloc>(
            create: (BuildContext context) => dependencies.pinCodeAuthBloc,
          ),
        ],
        child: MaterialContext(),
      ),
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
