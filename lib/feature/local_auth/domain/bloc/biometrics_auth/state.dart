part of 'bloc.dart';

/// Состояния [BiometricsAuthBloc].
sealed class BiometricsAuthState with EquatableMixin {
  const BiometricsAuthState();

  /// Начальное состояние.
  const factory BiometricsAuthState.notAuthenticated() = _NotAuthenticated;

  /// Процесс аутентификации по биометрии.
  const factory BiometricsAuthState.authenticating() = _Authenticating;

  /// Пользователь успешно аутентифицировался.
  const factory BiometricsAuthState.authenticated() = _Authenticated;

  /// Состояние ошибки.
  const factory BiometricsAuthState.error({required Object error}) = _Error;

  bool get isAuthenticated => this is _Authenticated;

  bool get isNotAuthenticating => this is! _Authenticating;

  bool get isError => this is _Error;

  Object? get error => switch (this) {
    _Error(error: final error) => error,
    _ => null,
  };

  @override
  List<Object> get props => [];
}

final class _NotAuthenticated extends BiometricsAuthState {
  const _NotAuthenticated();
}

final class _Authenticating extends BiometricsAuthState {
  const _Authenticating();
}

final class _Authenticated extends BiometricsAuthState {
  const _Authenticated();
}

final class _Error extends BiometricsAuthState {
  const _Error({required this.error});

  @override
  final Object error;

  @override
  List<Object> get props => [...super.props, error];
}
