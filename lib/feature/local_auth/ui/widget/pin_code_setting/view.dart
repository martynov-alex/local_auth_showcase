import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/local_auth_status/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/pin_code_setting/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/widget/common/pin_indicator.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/widget/common/pin_keyboard.dart';

/// Длительность ожидания перед сбросом состояния ошибки при несовпадении кодов
const _mismatchResetWaitDuration = Duration(seconds: 1);

/// Длительность ожидания после успешного завершения процесса установки пин-кода
const _onSuccessWaitDuration = Duration(seconds: 1);

/// Экран, показывающийся при первичной установке или изменении пин-кода
class PinCodeSettingView extends StatefulWidget {
  const PinCodeSettingView({
    required this.enteringStageText,
    this.onSuccess,
    super.key,
  });

  final String enteringStageText;
  final VoidCallback? onSuccess;

  @override
  State<PinCodeSettingView> createState() => _PinCodeSettingViewState();
}

class _PinCodeSettingViewState extends State<PinCodeSettingView> {
  late final PinCodeSettingBloc _pinCodeSettingBloc;
  late final LocalAuthStatusBloc _localAuthStatusBloc;

  @override
  void initState() {
    super.initState();
    _pinCodeSettingBloc = context.read<PinCodeSettingBloc>();
    _localAuthStatusBloc = context.read<LocalAuthStatusBloc>();
  }

  void _onNumberTap(String number) {
    _pinCodeSettingBloc.add(PinCodeSettingEvent.numberAdded(number));
  }

  void _onBackspaceTap() {
    _pinCodeSettingBloc.add(const PinCodeSettingEvent.numberDeleted());
  }

  void _onCancelTap() {
    _pinCodeSettingBloc.add(const PinCodeSettingEvent.resetToEntering());
    context.pop();
  }

  void _onCloseIconTap() {
    _pinCodeSettingBloc.add(const PinCodeSettingEvent.resetToEntering());
    context.pop();
  }

  void _onSuccess() async {
    await Future<void>.delayed(_onSuccessWaitDuration);
    if (mounted) context.pop();
    widget.onSuccess?.call();
    _pinCodeSettingBloc.add(const PinCodeSettingEvent.resetToEntering());
    _localAuthStatusBloc.add(const LocalAuthStatusEvent.check());
  }

  void _onError() async {
    await Future<void>.delayed(_mismatchResetWaitDuration);

    _pinCodeSettingBloc.add(const PinCodeSettingEvent.resetToConfirming());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PinCodeSettingBloc, PinCodeSettingState>(
          listenWhen: (prev, next) => !prev.isError && next.isError,
          listener: (_, __) => _onError(),
        ),
        BlocListener<PinCodeSettingBloc, PinCodeSettingState>(
          listenWhen: (prev, next) => !prev.isSuccess && next.isSuccess,
          listener: (_, __) => _onSuccess(),
        ),
      ],
      child: Stack(
        children: [
          BlocBuilder<PinCodeSettingBloc, PinCodeSettingState>(
            builder: (_, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PinIndicator(
                          statusText: widget.enteringStageText,
                          currentPinLength: state.enteredPinLength,
                          maxPinLength: state.maxPinCodeLength,
                        ),
                        if (!state.isEnteringState)
                          _RepeatingPinStatus(state: state),
                        const SizedBox.square(dimension: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: PinKeyboard(
                      isBlocked: state.isErrorOrSuccess,
                      textButtonTitle: "Отмена",
                      iconButtonChild: Icon(
                        Icons.keyboard_backspace,
                        color: context.colorScheme.secondary,
                        size: 40,
                      ),
                      onIconTap: _onBackspaceTap,
                      onTextTap: _onCancelTap,
                      onNumberTap: _onNumberTap,
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            left: 20,
            top: 20,
            child: GestureDetector(
              onTap: _onCloseIconTap,
              child: Icon(Icons.close, color: context.colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _RepeatingPinStatus extends StatelessWidget {
  const _RepeatingPinStatus({required this.state});

  final PinCodeSettingState state;

  String getConfirmedStageText(BuildContext context) {
    if (!state.isConfirmedPinLengthReached) return "Повторите пин-код";
    if (state.isMatch) return "Все верно!";
    return "Пин-код не совпадает!";
  }

  Color? getIndicatorColor(BuildContext context) {
    if (state.isError) return context.colorScheme.error;
    if (state.isSuccess) return context.colorScheme.primary;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox.square(dimension: 24),
        PinIndicator(
          statusText: getConfirmedStageText(context),
          indicatorTextColor: state.isError ? context.colorScheme.error : null,
          indicatorDotColor: getIndicatorColor(context),
          currentPinLength: state.confirmedPinLength,
          maxPinLength: state.maxPinCodeLength,
        ),
      ],
    );
  }
}
