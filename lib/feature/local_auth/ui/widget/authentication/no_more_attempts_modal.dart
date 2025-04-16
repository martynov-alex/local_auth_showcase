import 'package:flutter/material.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';

class NoMoreAttemptsModal extends StatelessWidget {
  const NoMoreAttemptsModal({required this.onConfirmTap, super.key});

  final VoidCallback onConfirmTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Dialog(
          insetPadding: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Вы использовали\nвсе попытки',
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: onConfirmTap,
                  child: Text(
                    'Необходимо войти повторно',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
