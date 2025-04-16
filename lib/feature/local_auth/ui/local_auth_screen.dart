import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:local_auth_showcase/core/router/route_wrapper.dart';
import 'package:local_auth_showcase/feature/local_auth/di/local_auth_di.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/widget/authentication/view.dart';
import 'package:local_auth_showcase/main.dart';
import 'package:provider/provider.dart';

const _dialogId = 'local-auth-dialog';

Future<void> showLocalAuthDialog(
  Dependencies dependencies, {
  required Color backgroundColor,
  VoidCallback? onSkipped,
  VoidCallback? onSuccess,
  VoidCallback? onFailure,
  bool isBiometricsEnabled = true,
}) async {
  final isPinCodeSet = await dependencies.localAuthRepository.isPinCodeSet;

  if (!isPinCodeSet) {
    onSkipped?.call();
    return;
  }

  final dialog = EasyDialog.fullScreen(
    id: _dialogId,
    androidWillPop: () => false,
    content: Dialog.fullscreen(
      backgroundColor: backgroundColor,
      child: LocalAuthScreen(
        isBiometricsEnabled: isBiometricsEnabled,
        onSuccess: () async {
          onSuccess?.call();
          await FlutterEasyDialogs.hide(id: _dialogId, instantly: true);
        },
        onFailure: () async {
          onFailure?.call();
          await FlutterEasyDialogs.hide(id: _dialogId, instantly: true);
        },
      ).wrappedRoute(dependencies),
    ),
  );

  await FlutterEasyDialogs.show(dialog);
}

class LocalAuthScreen extends StatefulWidget implements RouteWrapper {
  const LocalAuthScreen({
    required this.onSuccess,
    required this.onFailure,
    required this.isBiometricsEnabled,
    super.key,
  });

  final VoidCallback onSuccess;
  final VoidCallback onFailure;
  final bool isBiometricsEnabled;

  @override
  Widget wrappedRoute(Dependencies dependencies) {
    return MultiProvider(
      providers: LocalAuthDI.providers(dependencies),
      child: this,
    );
  }

  @override
  State<LocalAuthScreen> createState() => _LocalAuthScreenState();
}

class _LocalAuthScreenState extends State<LocalAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return LocalAuthAuthenticationView(
      isBiometricsEnabled: widget.isBiometricsEnabled,
      onSuccess: widget.onSuccess,
      onFailure: widget.onFailure,
    );
  }
}
