part of 'auth_bloc.dart';

@immutable
sealed class AuthState with EquatableMixin {
  const AuthState({required this.status});

  final AuthenticationStatus status;

  const factory AuthState.idle({required AuthenticationStatus status}) =
      _AuthStateIdle;

  const factory AuthState.processing({required AuthenticationStatus status}) =
      _AuthStateProcessing;

  const factory AuthState.logoutProcessing({
    required AuthenticationStatus status,
  }) = _AuthStateLogoutProcessing;

  const factory AuthState.error({
    required AuthenticationStatus status,
    required Object error,
  }) = _AuthStateError;

  bool get isProcessing => this is _AuthStateProcessing;
  bool get isLogoutProcessing => this is _AuthStateLogoutProcessing;
  bool get isError => this is _AuthStateError;
  bool get isAuthenticated => status == AuthenticationStatus.authenticated;
  bool get isUnauthenticated => status == AuthenticationStatus.unauthenticated;

  Object? get error => switch (this) {
    final _AuthStateError e => e.error,
    _ => null,
  };

  @override
  List<Object> get props => [status];
}

final class _AuthStateIdle extends AuthState {
  const _AuthStateIdle({required super.status});
}

final class _AuthStateProcessing extends AuthState {
  const _AuthStateProcessing({required super.status});
}

final class _AuthStateLogoutProcessing extends AuthState {
  const _AuthStateLogoutProcessing({required super.status});
}

final class _AuthStateError extends AuthState {
  @override
  final Object error;

  const _AuthStateError({required this.error, required super.status});

  @override
  List<Object> get props => [...super.props, error];
}
