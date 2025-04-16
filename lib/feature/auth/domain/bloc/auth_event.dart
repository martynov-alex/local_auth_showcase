part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();

  const factory AuthEvent.signInWithOAuth() = _SignInWithOAuth;

  const factory AuthEvent.logout() = _LogOut;
}

final class _SignInWithOAuth extends AuthEvent {
  const _SignInWithOAuth();

  @override
  String toString() => "Sign in with OAuth event";
}

final class _LogOut extends AuthEvent {
  const _LogOut();

  @override
  String toString() => "Log out event";
}
