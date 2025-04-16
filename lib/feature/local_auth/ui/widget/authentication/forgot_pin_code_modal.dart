import 'package:flutter/material.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';

class ForgotPinCodeModal extends StatelessWidget {
  const ForgotPinCodeModal({
    required this.onConfirmTap,
    required this.onCancelTap,
    super.key,
  });

  final VoidCallback onConfirmTap;
  final VoidCallback onCancelTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
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
                  'Забыли пин-код?',
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(
                  'После сброса пин-кода нужно\nбудет авторизоваться заново',
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: onConfirmTap,
                  child: Text(
                    'Окей',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
