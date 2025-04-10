import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text("Settings", style: context.textTheme.headlineLarge),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Sign out", style: context.textTheme.titleLarge),
            onTap: () {
              _authBloc.add(const AuthEvent.signOut());
            },
            trailing: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
