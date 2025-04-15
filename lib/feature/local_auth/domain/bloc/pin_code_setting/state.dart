part of 'bloc.dart';

/// Состояния [PinCodeSettingsBloc].
@immutable
sealed class PinCodeSettingState with EquatableMixin {
  const PinCodeSettingState({
    required this.enteredPin,
    required this.confirmedPin,
  });

  final PinCode enteredPin;
  final PinCode confirmedPin;

  /// Ввод пин-кода.
  const factory PinCodeSettingState.entering({
    PinCode? enteredPin,
    PinCode? confirmedPin,
  }) = _Entering;

  /// Подтверждение пин-кода.
  const factory PinCodeSettingState.confirming({
    required PinCode enteredPin,
    required PinCode confirmedPin,
  }) = _Confirming;

  /// Обработка данных.
  const factory PinCodeSettingState.processing({
    required PinCode enteredPin,
    required PinCode confirmedPin,
  }) = _Processing;

  /// пин-код установлен.
  const factory PinCodeSettingState.success({
    required PinCode enteredPin,
    required PinCode confirmedPin,
  }) = _Success;

  /// Состояние ошибки.
  const factory PinCodeSettingState.error({
    required Object error,
    required PinCode enteredPin,
    required PinCode confirmedPin,
  }) = _Error;

  @override
  List<Object> get props => [enteredPin, confirmedPin];

  /// Совпадает ли введенный пин-код с повторным.
  bool get isMatch => enteredPin == confirmedPin;

  /// Состояние ввода пин-кода.
  bool get isEnteringState => this is _Entering;

  /// Состояние ошибки ввода.
  bool get isError => this is _Error;

  /// Состояние установленного пин-кода.
  bool get isSuccess => this is _Success;

  /// Возвращает максимальную длину пин-кода из [PinCode].
  int get maxPinCodeLength => PinCode.maxPinCodeLength;

  /// Возвращает текущую длину введенного пин-кода.
  int get enteredPinLength => enteredPin.value.length;

  /// Возвращает текущую длину подтверждающего пин-кода.
  int get confirmedPinLength => confirmedPin.value.length;

  /// Достигнута максимальная длина подтверждающего пин-кода.
  bool get isConfirmedPinLengthReached => confirmedPin.isMaxLengthReached;

  /// Состояние ошибки или успеха.
  bool get isErrorOrSuccess => isError || isSuccess;
}

final class _Entering extends PinCodeSettingState {
  const _Entering({PinCode? enteredPin, PinCode? confirmedPin})
    : super(
        enteredPin: enteredPin ?? const PinCode(''),
        confirmedPin: confirmedPin ?? const PinCode(''),
      );
}

final class _Confirming extends PinCodeSettingState {
  const _Confirming({required super.enteredPin, required super.confirmedPin});
}

final class _Processing extends PinCodeSettingState {
  const _Processing({required super.enteredPin, required super.confirmedPin});
}

final class _Success extends PinCodeSettingState {
  const _Success({required super.enteredPin, required super.confirmedPin});
}

final class _Error extends PinCodeSettingState {
  const _Error({
    required this.error,
    required super.enteredPin,
    required super.confirmedPin,
  });

  final Object error;

  @override
  List<Object> get props => [...super.props, error];
}
