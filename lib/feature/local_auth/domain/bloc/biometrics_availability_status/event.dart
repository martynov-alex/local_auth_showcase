
part of 'bloc.dart';

/// События [BiometricsAvailabilityStatusBloc].
@immutable
sealed class BiometricsAvailabilityStatusEvent {
  const BiometricsAvailabilityStatusEvent();

  /// Проверка состояния локальной аутентификации.
  const factory BiometricsAvailabilityStatusEvent.check() = _Check;
}

final class _Check extends BiometricsAvailabilityStatusEvent {
  const _Check();
}
