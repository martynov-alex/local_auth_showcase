import 'package:flutter/material.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';
import 'package:local_auth_showcase/core/router/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        child: Text(
          "Authenticate with OAuth",
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.onPrimary,
          ),
        ),
        onPressed: () => TopSecretDataRoute().go(context),
      ),
    );
  }
}
