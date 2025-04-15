part of 'bloc.dart';

/// Состояния [BiometricsAvailabilityStatusBloc].
@immutable
sealed class BiometricsAvailabilityStatusState with EquatableMixin {
  const BiometricsAvailabilityStatusState();

  /// Состояние загрузки.
  const factory BiometricsAvailabilityStatusState.loading() =
      BiometricsAvailabilityStatusLoading;

  /// Состояние ошибки.
  const factory BiometricsAvailabilityStatusState.error(Object error) =
      BiometricsAvailabilityStatusError;

  /// Состояние загруженных данных.
  const factory BiometricsAvailabilityStatusState.data({
    required AvailableBiometrics availableBiometrics,
  }) = BiometricsAvailabilityStatusData;

  bool get isBiometricsAvailable => availableBiometrics.any;

  AvailableBiometrics get availableBiometrics => switch (this) {
    BiometricsAvailabilityStatusData(:final availableBiometrics) =>
      availableBiometrics,
    _ => AvailableBiometrics.none(),
  };

  bool get isLoading => this is BiometricsAvailabilityStatusLoading;
  bool get isNotLoading => this is! BiometricsAvailabilityStatusLoading;

  @override
  List<Object> get props => [];
}

final class BiometricsAvailabilityStatusLoading
    extends BiometricsAvailabilityStatusState {
  const BiometricsAvailabilityStatusLoading();
}

final class BiometricsAvailabilityStatusError
    extends BiometricsAvailabilityStatusState {
  const BiometricsAvailabilityStatusError(this.error);

  final Object error;

  @override
  List<Object> get props => [...super.props, error];
}

final class BiometricsAvailabilityStatusData
    extends BiometricsAvailabilityStatusState {
  const BiometricsAvailabilityStatusData({required this.availableBiometrics});

  @override
  final AvailableBiometrics availableBiometrics;

  @override
  List<Object> get props => [...super.props, availableBiometrics];
}
