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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Top Secret Data",
          style: context.textTheme.headlineLarge?.copyWith(
            color: context.colorScheme.error,
          ),
        ),
        const SizedBox(height: 20),
        Icon(
          Icons.dataset_outlined,
          color: context.colorScheme.error,
          size: 100,
        ),
      ],
    );
  }
}
