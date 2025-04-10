import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';
import 'package:local_auth_showcase/feature/app/app.dart';
import 'package:local_auth_showcase/feature/auth/domain/bloc/auth_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = DependenciesScope.of(context).authBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"), centerTitle: true),
      body: ListView(
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return ListTile(
                title: Text("Sign out", style: context.textTheme.titleLarge),
                onTap: () {
                  _authBloc.add(const AuthEvent.signOut());
                },
                trailing:
                    state.isProcessing || state.isUnauthenticated
                        ? CircularProgressIndicator.adaptive(
                          backgroundColor: context.colorScheme.onPrimary,
                          constraints: BoxConstraints.tight(Size(20, 20)),
                        )
                        : Icon(Icons.logout),
              );
            },
          ),
        ],
      ),
    );
  }
}
