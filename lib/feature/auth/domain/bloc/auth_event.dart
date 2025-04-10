part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();

  const factory AuthEvent.signInWithOAuth() = _SignInWithOAuth;

  const factory AuthEvent.signOut() = _SignOut;
}

final class _SignInWithOAuth extends AuthEvent {
  const _SignInWithOAuth();
}

final class _SignOut extends AuthEvent {
  const _SignOut();
}
