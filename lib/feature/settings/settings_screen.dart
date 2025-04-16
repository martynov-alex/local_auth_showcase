import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';
import 'package:local_auth_showcase/core/router/routes.dart';
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
    _authBloc = context.read<AuthBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Настройки"), centerTitle: true),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              "Локальная аутентификация",
              style: context.textTheme.titleLarge,
            ),
            onTap: () {
              LocalAuthInitialRouteData().go(context);
            },
            trailing: Icon(Icons.security),
          ),
          ListTile(
            title: Text(
              "Выйти из аккаунта",
              style: context.textTheme.titleLarge,
            ),
            onTap: () {
              _authBloc.add(const AuthEvent.logout());
            },
            trailing: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
