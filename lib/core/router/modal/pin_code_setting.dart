import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/pin_code_setting/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/widget/pin_code_setting/view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// Установка пинкода
Future<void> openPinCodeSettingModal(
  BuildContext context, {
  required String enteringStageText,
  VoidCallback? onSuccess,
}) async {
  final pinCodeSettingBloc = context.read<PinCodeSettingBloc>();

  if (!context.mounted) return;

  if (Theme.of(context).platform == TargetPlatform.iOS) {
    await CupertinoScaffold.showCupertinoModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: context.colorScheme.surface,
      builder:
          (context) => BlocProvider.value(
            value: pinCodeSettingBloc,
            child: PinCodeSettingView(
              enteringStageText: enteringStageText,
              onSuccess: onSuccess,
            ),
          ),
    );
  } else if (Theme.of(context).platform == TargetPlatform.android) {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      builder:
          (context) => BlocProvider.value(
            value: pinCodeSettingBloc,
            child: PinCodeSettingView(
              enteringStageText: enteringStageText,
              onSuccess: onSuccess,
            ),
          ),
    );
  }
}
