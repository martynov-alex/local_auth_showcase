part of 'bloc.dart';

/// Состояния [LocalAuthStatusBloc].
@immutable
sealed class LocalAuthStatusState with EquatableMixin {
  const LocalAuthStatusState();

  /// Состояние загрузки.
  const factory LocalAuthStatusState.loading() = LocalAuthStatusLoading;

  /// Состояние ошибки.
  const factory LocalAuthStatusState.error(Object error) = LocalAuthStatusError;

  /// Состояние загруженных данных.
  const factory LocalAuthStatusState.data({
    required bool isPinCodeSet,
    required bool isBiometricsOn,
  }) = LocalAuthStatusData;

  bool get isLoading => this is LocalAuthStatusLoading;

  bool get isError => this is LocalAuthStatusError;

  bool get isPinCodeSet => switch (this) {
    LocalAuthStatusData(isPinCodeSet: final isPinCodeSet) => isPinCodeSet,
    _ => false,
  };

  bool get isBiometricsOn => switch (this) {
    LocalAuthStatusData(isBiometricsOn: final isBiometricsOn) => isBiometricsOn,
    _ => false,
  };

  @override
  List<Object> get props => [];
}

final class LocalAuthStatusLoading extends LocalAuthStatusState {
  const LocalAuthStatusLoading();
}

final class LocalAuthStatusError extends LocalAuthStatusState {
  const LocalAuthStatusError(this.error);

  final Object error;

  @override
  List<Object> get props => [...super.props, error];
}

final class LocalAuthStatusData extends LocalAuthStatusState {
  const LocalAuthStatusData({
    required this.isPinCodeSet,
    required this.isBiometricsOn,
  });

  @override
  final bool isPinCodeSet;

  @override
  final bool isBiometricsOn;

  @override
  List<Object> get props => [...super.props, isPinCodeSet, isBiometricsOn];
}
