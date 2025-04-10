import 'package:flutter/material.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';

class TopSecretDataScreen extends StatefulWidget {
  const TopSecretDataScreen({super.key});

  @override
  State<TopSecretDataScreen> createState() => _TopSecretDataScreenState();
}

class _TopSecretDataScreenState extends State<TopSecretDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Top Secret Data",
        style: context.textTheme.headlineMedium?.copyWith(
          color: context.colorScheme.error,
        ),
      ),
    );
  }
}
