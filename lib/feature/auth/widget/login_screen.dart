import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';
import 'package:local_auth_showcase/feature/app/app.dart';
import 'package:local_auth_showcase/feature/auth/domain/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = DependenciesScope.of(context).authBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(Size(300, 80)),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.isProcessing || state.isAuthenticated) {
                return FilledButton(
                  onPressed: () {},
                  child: CircularProgressIndicator(
                    color: context.colorScheme.inversePrimary,
                    strokeWidth: 8,
                    constraints: BoxConstraints.tight(Size(40, 40)),
                  ),
                );
              }

              if (state.isError) {
                FilledButton(
                  onPressed: () {
                    _authBloc.add(const AuthEvent.signInWithOAuth());
                  },
                  child: Text(
                    "Ошибка аутентификации",
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.colorScheme.error,
                    ),
                  ),
                );
              }

              return FilledButton(
                onPressed: () {
                  _authBloc.add(const AuthEvent.signInWithOAuth());
                },
                child: Text(
                  "Аутентификация с OAuth",
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
