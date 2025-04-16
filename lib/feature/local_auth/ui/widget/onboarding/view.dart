import 'package:flutter/material.dart';
import 'package:local_auth_showcase/core/router/modal/pin_code_setting.dart';
import 'package:local_auth_showcase/core/router/routes.dart';

class LocalAuthOnboardingView extends StatelessWidget {
  const LocalAuthOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final paddingBottom = 68 + MediaQuery.viewPaddingOf(context).bottom;

    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ).copyWith(bottom: paddingBottom),
          child: OutlinedButton(
            child: Text("Start"),
            onPressed: () async {
              await openPinCodeSettingModal(
                context,
                enteringStageText: "Hello",
                onSuccess: () {
                  LocalAuthSettingsRouteData().go(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}
