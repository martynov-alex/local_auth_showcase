import 'package:flutter/material.dart';

class NoMoreAttemptsModal extends StatelessWidget {
  const NoMoreAttemptsModal({required this.onConfirmTap, super.key});

  final VoidCallback onConfirmTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('localAuthModalNoMoreAttemptsTitle'),
              const SizedBox(height: 15),
              TextButton(
                onPressed: onConfirmTap,
                child: const Text('localAuthModalNoMoreAttemptsButton'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
