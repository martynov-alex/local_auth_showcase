part of 'bloc.dart';

/// Состояния [PinCodeAuthBloc].
@immutable
sealed class PinCodeAuthState with EquatableMixin {
  const PinCodeAuthState({required this.pin, required this.attempts});

  final PinCode pin;
  final AttemptsEnterPinCode attempts;

  /// Ввод пин-кода.
  const factory PinCodeAuthState.entering({
    PinCode? pin,
    AttemptsEnterPinCode? attempts,
  }) = _Entering;

  /// Состояние аутентификации.
  const factory PinCodeAuthState.authenticating({
    required PinCode pin,
    required AttemptsEnterPinCode attempts,
  }) = _Authenticating;

  /// Обработка данных.
  const factory PinCodeAuthState.processing({
    required PinCode pin,
    required AttemptsEnterPinCode attempts,
  }) = _Processing;

  /// Аутентификация пройдена.
  const factory PinCodeAuthState.authenticated({
    required PinCode pin,
    required AttemptsEnterPinCode attempts,
    bool? isBiometricsUsed,
  }) = _Authenticated;

  /// Состояние сброшенных данных.
  const factory PinCodeAuthState.reset({
    required PinCode pin,
    required AttemptsEnterPinCode attempts,
  }) = _Reset;

  /// Состояние ошибки.
  const factory PinCodeAuthState.error({
    required Object error,
    required PinCode pin,
    required AttemptsEnterPinCode attempts,
  }) = _Error;

  /// Состояние не ввода пин-кода.
  bool get isNotEntering => this is! _Entering;

  /// Состояние успешной авторизации.
  bool get isAuthenticated => this is _Authenticated;

  /// Состояние ошибки ввода.
  bool get isError => this is _Error;

  /// Состояние сброса данных.
  bool get isReset => this is _Reset;

  /// Возвращает максимальную длину пин-кода из [PinCode].
  int get maxPinCodeLength => PinCode.maxPinCodeLength;

  /// Возвращает текущую длину введенного пин-кода.
  int get enteredPinLength => pin.value.length;

  /// Сколько осталось попыток до логаута.
  int get numberAttemptsBeforeLogout => attempts.numberAttemptsBeforeLogout;

  /// Достигнут ли порог для показа предупреждения о количестве оставшихся попыток.
  bool get isThresholdBeforeWarningReached =>
      attempts.isMaxBeforeWarningReached;

  /// Любая ошибка.
  Object? get error => switch (this) {
    _Error(error: final error) => error,
    _ => null,
  };

  /// Использовалась ли биометрия для аутентификации.
  bool? get isBiometricsUsed => switch (this) {
    _Authenticated(:final _isBiometricsUsed) => _isBiometricsUsed,
    _ => null,
  };

  @override
  List<Object> get props => [pin, attempts];
}

final class _Entering extends PinCodeAuthState {
  const _Entering({PinCode? pin, AttemptsEnterPinCode? attempts})
    : super(
        pin: pin ?? const PinCode(''),
        attempts: attempts ?? const AttemptsEnterPinCode(0),
      );
}

final class _Authenticating extends PinCodeAuthState {
  const _Authenticating({required super.pin, required super.attempts});
}

final class _Processing extends PinCodeAuthState {
  const _Processing({required super.pin, required super.attempts});
}

final class _Authenticated extends PinCodeAuthState {
  const _Authenticated({
    required super.pin,
    required super.attempts,
    bool? isBiometricsUsed,
  }) : _isBiometricsUsed = isBiometricsUsed ?? false;

  final bool _isBiometricsUsed;

  @override
  List<Object> get props => [...super.props, _isBiometricsUsed];
}

final class _Reset extends PinCodeAuthState {
  const _Reset({required super.pin, required super.attempts});
}

final class _Error extends PinCodeAuthState {
  const _Error({
    required this.error,
    required super.pin,
    required super.attempts,
  });

  @override
  final Object error;

  @override
  List<Object> get props => [...super.props, error];
}
