import 'package:flutter/material.dart';

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
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(color: Colors.red),
      ),
    );
  }
}
