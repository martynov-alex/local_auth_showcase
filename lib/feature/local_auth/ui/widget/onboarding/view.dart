import 'package:flutter/material.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';
import 'package:local_auth_showcase/core/router/modal/pin_code_setting.dart';
import 'package:local_auth_showcase/core/router/routes.dart';

class LocalAuthOnboardingView extends StatelessWidget {
  const LocalAuthOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final paddingBottom = 68 + MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ).copyWith(bottom: paddingBottom),
          child: FilledButton(
            onPressed: () async {
              await openPinCodeSettingModal(
                context,
                enteringStageText: "Введите пин-код для установки",
                onSuccess: () {
                  LocalAuthSettingsRouteData().go(context);
                },
              );
            },
            child: Text(
              "Установить локальную аутентификацию?",
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
