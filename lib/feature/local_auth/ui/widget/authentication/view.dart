import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';
import 'package:local_auth_showcase/feature/local_auth/data/service/biometrics_auth_service.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/biometrics_auth/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/biometrics_availability_status/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/local_auth_status/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/pin_code_auth/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/exception/local_auth_exception.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/widget/authentication/forgot_pin_code_modal.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/widget/authentication/no_more_attempts_modal.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/widget/common/pin_indicator.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/widget/common/pin_keyboard.dart';

/// Длительность ожидания перед виброоткликом
const _hapticWaitDuration = Duration(milliseconds: 200);

/// Длительность ожидания после успешной аутентификации
const _authenticatedWaitDuration = Duration(seconds: 1);

/// Длительность ожидания перед сбросом состояния ошибки при несовпадении кодов
const _mismatchResetWaitDuration = Duration(seconds: 1);

/// Длительность ожидания перед сбросом при неудачной аутентификации
const _availableAttemptsAreOverWaitDuration = Duration(seconds: 2);

/// Идентификатор модалки для FlutterEasyDialogs
const _localAuthModalId = ObjectKey('LocalAuthModal');

class LocalAuthAuthenticationView extends StatefulWidget {
  const LocalAuthAuthenticationView({
    required this.isBiometricsEnabled,
    this.onSuccess,
    this.onFailure,
    super.key,
  });

  final bool isBiometricsEnabled;
  final VoidCallback? onSuccess;
  final VoidCallback? onFailure;

  @override
  State<LocalAuthAuthenticationView> createState() =>
      _LocalAuthAuthenticationViewState();
}

class _LocalAuthAuthenticationViewState
    extends State<LocalAuthAuthenticationView> {
  late final PinCodeAuthBloc _pinCodeAuthBloc;
  late final LocalAuthStatusBloc _localAuthStatusBloc;
  late final BiometricsAuthBloc _biometricsAuthBloc;
  late final BiometricsAvailabilityStatusBloc _biometricsAvailabilityStatusBloc;

  bool _isBiometricsOn = false;
  bool _ableUseBiometrics = false;

  @override
  void initState() {
    super.initState();
    _pinCodeAuthBloc = context.read<PinCodeAuthBloc>();
    _localAuthStatusBloc = context.read<LocalAuthStatusBloc>();
    _biometricsAuthBloc = context.read<BiometricsAuthBloc>();
    _biometricsAvailabilityStatusBloc =
        context.read<BiometricsAvailabilityStatusBloc>();

    _isBiometricsOn = _localAuthStatusBloc.state.isBiometricsOn;
    _pinCodeAuthBloc.add(
      const PinCodeAuthEvent.resetToEntering(resetAttempts: false),
    );
    _biometricsAvailabilityStatusBloc.add(
      const BiometricsAvailabilityStatusEvent.check(),
    );
  }

  void _onNumberTap(String number) {
    _pinCodeAuthBloc.add(PinCodeAuthEvent.numberAdded(number));
  }

  void _onBackspaceTap() {
    _pinCodeAuthBloc.add(const PinCodeAuthEvent.numberDeleted());
  }

  Future<void> _onAuthenticated() async {
    await Future<void>.delayed(_hapticWaitDuration);
    await Haptics.vibrate(HapticsType.success);

    await Future<void>.delayed(_authenticatedWaitDuration);
    widget.onSuccess?.call();
  }

  void _onAuthenticatedByBiometrics() {
    _pinCodeAuthBloc.add(const PinCodeAuthEvent.authByBiometrics());
  }

  Future<void> _onIncorrectPinCode() async {
    await Future<void>.delayed(_hapticWaitDuration);
    await Haptics.vibrate(HapticsType.error);

    await Future<void>.delayed(_mismatchResetWaitDuration);

    _pinCodeAuthBloc.add(
      const PinCodeAuthEvent.resetToEntering(resetAttempts: false),
    );
  }

  void _onForgotPinCode() {
    _pinCodeAuthBloc.add(const PinCodeAuthEvent.pinCodeResetRequested());
    widget.onFailure?.call();
  }

  Future<void> _onAttemptsExceeded() async {
    await Future<void>.delayed(_hapticWaitDuration);
    await Haptics.vibrate(HapticsType.error);

    await Future<void>.delayed(_availableAttemptsAreOverWaitDuration);
    await _showNoMoreAttemptsModal();

    _pinCodeAuthBloc.add(
      const PinCodeAuthEvent.resetToEntering(resetAttempts: true),
    );
    widget.onFailure?.call();
  }

  void _requestBiometricsAuthentication() {
    _biometricsAuthBloc.add(
      BiometricsAuthEvent.authRequested(
        signInTitle: "localAuthConfirmBiometricsTitle",
        reason: "localAuthConfirmBiometricsReason",
        cancelButton: "cancel",
      ),
    );
  }

  void _resolveIconTap({
    required AvailableBiometrics availableBiometrics,
    required bool isPinEmpty,
  }) {
    if (_ableUseBiometrics && availableBiometrics.any && isPinEmpty) {
      _requestBiometricsAuthentication();
      return;
    }

    _onBackspaceTap();
  }

  Widget _getIconButton({
    required AvailableBiometrics availableBiometrics,
    required bool isPinEmpty,
  }) {
    if (!_ableUseBiometrics || !isPinEmpty) {
      return Icon(Icons.backspace, color: context.colorScheme.onPrimary);
    }

    if (Theme.of(context).platform == TargetPlatform.android &&
        availableBiometrics.any) {
      return Icon(Icons.fingerprint, color: context.colorScheme.onPrimary);
    }

    if (Theme.of(context).platform == TargetPlatform.iOS &&
        availableBiometrics.containsFace) {
      return Icon(Icons.face, color: context.colorScheme.onPrimary);
    }

    if (Theme.of(context).platform == TargetPlatform.iOS &&
        availableBiometrics.containsFingerprint) {
      return Icon(Icons.fingerprint, color: context.colorScheme.onPrimary);
    }

    return Icon(Icons.backspace, color: context.colorScheme.onPrimary);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<
          BiometricsAvailabilityStatusBloc,
          BiometricsAvailabilityStatusState
        >(
          listenWhen:
              (prev, next) =>
                  !prev.isBiometricsAvailable && next.isBiometricsAvailable,
          listener: (_, state) {
            _ableUseBiometrics =
                widget.isBiometricsEnabled &&
                _isBiometricsOn &&
                state.isBiometricsAvailable;
            if (_ableUseBiometrics) _requestBiometricsAuthentication();
          },
        ),
        BlocListener<PinCodeAuthBloc, PinCodeAuthState>(
          listenWhen:
              (prev, next) => !prev.isAuthenticated && next.isAuthenticated,
          listener: (context, state) {
            _onAuthenticated();
          },
        ),
        BlocListener<BiometricsAuthBloc, BiometricsAuthState>(
          listenWhen:
              (prev, next) => !prev.isAuthenticated && next.isAuthenticated,
          listener: (_, __) => _onAuthenticatedByBiometrics(),
        ),
        BlocListener<BiometricsAuthBloc, BiometricsAuthState>(
          listenWhen: (prev, next) => !prev.isError && next.isError,
          listener: (_, state) {
            if (state.error is BiometricsAuthenticateException) {
              setState(() {
                _ableUseBiometrics = false;
              });
            }
          },
        ),
        BlocListener<PinCodeAuthBloc, PinCodeAuthState>(
          listenWhen: (prev, next) => !prev.isError && next.isError,
          listener: (_, state) {
            if (state.error is AttemptsExceededPinCodeException) {
              _onAttemptsExceeded();
            }
            if (state.error is IncorrectPinCodeException) {
              _onIncorrectPinCode();
            }
          },
        ),
        BlocListener<PinCodeAuthBloc, PinCodeAuthState>(
          listenWhen: (prev, next) => !prev.isReset && next.isReset,
          listener: (context, _) {},
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _PinCodeStatus(),
          BlocBuilder<
            BiometricsAvailabilityStatusBloc,
            BiometricsAvailabilityStatusState
          >(
            builder: (_, biometricsState) {
              return BlocBuilder<PinCodeAuthBloc, PinCodeAuthState>(
                builder: (_, pinCodeAuthState) {
                  return PinKeyboard(
                    isBlocked:
                        pinCodeAuthState.isNotEntering &&
                        biometricsState.isNotLoading,
                    textButtonTitle: "localAuthTextButtonForgotPassword",
                    iconButtonChild: Builder(
                      builder: (_) {
                        if (!widget.isBiometricsEnabled) {
                          return Icon(
                            Icons.backspace,
                            color: context.colorScheme.onPrimary,
                          );
                        }
                        return switch (biometricsState) {
                          BiometricsAvailabilityStatusLoading() =>
                            const SizedBox.shrink(),
                          BiometricsAvailabilityStatusError() =>
                            const SizedBox.shrink(),
                          BiometricsAvailabilityStatusData(
                            availableBiometrics: final availableBiometrics,
                          ) =>
                            _getIconButton(
                              availableBiometrics: availableBiometrics,
                              isPinEmpty: pinCodeAuthState.pin.isEmpty,
                            ),
                        };
                      },
                    ),
                    onIconTap:
                        () => _resolveIconTap(
                          availableBiometrics:
                              biometricsState.availableBiometrics,
                          isPinEmpty: pinCodeAuthState.pin.isEmpty,
                        ),
                    onNumberTap: _onNumberTap,
                    onTextTap: () async {
                      await _showForgotModal(onTap: _onForgotPinCode);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showForgotModal({required VoidCallback onTap}) async {
    final modal = EasyDialog.positioned(
      id: _localAuthModalId,
      position: EasyDialogPosition.bottom,
      animationConfiguration: const EasyDialogAnimationConfiguration.bounded(
        duration: Duration(milliseconds: 200),
      ),
      decoration: const EasyDialogAnimation.fadeBackground(
        backgroundColor: Colors.transparent,
        blur: 10,
        curve: Curves.easeInOut,
      ),
      autoHideDuration: null,
      content: ForgotPinCodeModal(
        onConfirmTap: () async {
          await FlutterEasyDialogs.hide(id: _localAuthModalId, instantly: true);
          onTap.call();
        },
        onCancelTap: () async {
          await FlutterEasyDialogs.hide(id: _localAuthModalId);
        },
      ),
    );

    await modal.show();
  }

  Future<void> _showNoMoreAttemptsModal() async {
    final modal = EasyDialog.positioned(
      id: _localAuthModalId,
      position: EasyDialogPosition.bottom,
      animationConfiguration: const EasyDialogAnimationConfiguration.bounded(
        duration: Duration(milliseconds: 200),
      ),
      decoration: const EasyDialogAnimation.fadeBackground(
        backgroundColor: Colors.transparent,
        blur: 10,
        curve: Curves.easeInOut,
      ),
      autoHideDuration: null,
      content: NoMoreAttemptsModal(
        onConfirmTap: () async {
          await FlutterEasyDialogs.hide(id: _localAuthModalId, instantly: true);
        },
      ),
    );

    await modal.show();
  }
}

class _PinCodeStatus extends StatelessWidget {
  const _PinCodeStatus();

  String getStatusText(BuildContext context, PinCodeAuthState state) {
    if (state.isAuthenticated) return "localAuthCorrectPinCode";
    if (state.isError) return "localAuthWrongPinCode";
    return "localAuthEnterPinCode";
  }

  Color? getIndicatorColor(BuildContext context, PinCodeAuthState state) {
    if (state.isError) return context.colorScheme.error;
    if (state.isAuthenticated) return context.colorScheme.primary;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PinCodeAuthBloc, PinCodeAuthState>(
      builder: (context, authBlocState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PinIndicator(
              statusText: getStatusText(context, authBlocState),
              indicatorTextColor:
                  authBlocState.isError ? context.colorScheme.error : null,
              indicatorDotColor: getIndicatorColor(context, authBlocState),
              maxPinLength: authBlocState.maxPinCodeLength,
              currentPinLength: authBlocState.enteredPinLength,
            ),
            authBlocState.isThresholdBeforeWarningReached
                ? Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 48),
                  child: Text(
                    authBlocState.numberAttemptsBeforeLogout.toString(),

                    style: context.textTheme.labelMedium?.copyWith(
                      color: getIndicatorColor(context, authBlocState),
                    ),
                  ),
                )
                : const SizedBox(height: 79),
          ],
        );
      },
    );
  }
}
