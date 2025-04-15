part of 'bloc.dart';

/// События [PinCodeAuthBloc].
@immutable
sealed class PinCodeAuthEvent with EquatableMixin {
  const PinCodeAuthEvent();

  /// Ввод цифры пин-кода.
  const factory PinCodeAuthEvent.numberAdded(String number) = _NumberAdded;

  /// Удаление цифры пин-кода.
  const factory PinCodeAuthEvent.numberDeleted() = _NumberDeleted;

  /// Событие при сбросе пин-кода.
  const factory PinCodeAuthEvent.pinCodeResetRequested() =
      _PinCodeResetRequested;

  /// Событие сброса к состоянию ввода пин-кода.
  const factory PinCodeAuthEvent.resetToEntering({
    required bool resetAttempts,
  }) = _ResetToEntering;

  /// Событие успешной авторизации через биометрию.
  const factory PinCodeAuthEvent.authByBiometrics() = _AuthByBiometrics;

  @override
  List<Object> get props => [];
}

final class _NumberAdded extends PinCodeAuthEvent {
  const _NumberAdded(this.number);

  final String number;

  @override
  List<Object> get props => [...super.props, number];
}

final class _NumberDeleted extends PinCodeAuthEvent {
  const _NumberDeleted();
}

final class _PinCodeResetRequested extends PinCodeAuthEvent {
  const _PinCodeResetRequested();
}

final class _ResetToEntering extends PinCodeAuthEvent {
  const _ResetToEntering({required this.resetAttempts});

  final bool resetAttempts;

  @override
  List<Object> get props => [...super.props, resetAttempts];
}

final class _AuthByBiometrics extends PinCodeAuthEvent {
  const _AuthByBiometrics();
}
