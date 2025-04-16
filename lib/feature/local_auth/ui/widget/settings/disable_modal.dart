import 'package:flutter/material.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';

class LocalAuthDisableModal extends StatelessWidget {
  const LocalAuthDisableModal({
    required this.onConfirmTap,
    required this.onCancelTap,
    super.key,
  });

  final VoidCallback onConfirmTap;
  final VoidCallback onCancelTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onCancelTap,
            behavior: HitTestBehavior.opaque,
            child: const SizedBox.expand(),
          ),
        ),
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
                  'Вы уверены, что хотите отключить локальную аутентификацию?',
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge,
                ),
                SizedBox(height: 16),
                FilledButton(
                  onPressed: onConfirmTap,
                  child: Text(
                    'Отключить',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                OutlinedButton(
                  onPressed: onCancelTap,
                  child: Text('Отмена', style: context.textTheme.titleMedium),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
