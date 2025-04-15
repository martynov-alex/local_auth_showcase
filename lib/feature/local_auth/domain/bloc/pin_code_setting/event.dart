part of 'bloc.dart';

/// События [ExampleBloc].
@immutable
sealed class PinCodeSettingEvent with EquatableMixin {
  const PinCodeSettingEvent();

  /// Ввод цифры пин-кода.
  const factory PinCodeSettingEvent.numberAdded(String number) = _NumberAdded;

  /// Удаление цифры пин-кода.
  const factory PinCodeSettingEvent.numberDeleted() = _NumberDeleted;

  /// Событие отмены ввода.
  const factory PinCodeSettingEvent.resetToEntering() = _ResetToEntering;

  /// Событие сброса к состоянию подтверждения пин-кода.
  const factory PinCodeSettingEvent.resetToConfirming() = _ResetToConfirming;

  @override
  List<Object> get props => [];
}

final class _NumberAdded extends PinCodeSettingEvent {
  const _NumberAdded(this.number);

  final String number;

  @override
  List<Object> get props => [...super.props, number];
}

final class _NumberDeleted extends PinCodeSettingEvent {
  const _NumberDeleted();
}

final class _ResetToEntering extends PinCodeSettingEvent {
  const _ResetToEntering();
}

final class _ResetToConfirming extends PinCodeSettingEvent {
  const _ResetToConfirming();
}
