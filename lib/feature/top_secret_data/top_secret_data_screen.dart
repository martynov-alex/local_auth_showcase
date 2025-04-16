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
          "Супер\nсекретные\nданные",
          textAlign: TextAlign.center,
          style: context.textTheme.headlineLarge?.copyWith(
            color: context.colorScheme.error,
            fontWeight: FontWeight.bold,
            fontSize: 60,
          ),
        ),
        const SizedBox(height: 20),
        Icon(
          Icons.dataset_outlined,
          color: context.colorScheme.error,
          size: 200,
        ),
      ],
    );
  }
}
