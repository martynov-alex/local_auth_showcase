import 'package:local_auth_showcase/feature/auth/domain/entity/token.dart';

abstract interface class AuthDataSource<T> {
  Future<T> signInWithOAuth();

  Future<void> signOut();
}

final class FakeAuthDataSource implements AuthDataSource<Token> {
  const FakeAuthDataSource();

  @override
  Future<Token> signInWithOAuth() async {
    // Kinda fake auth
    await Future.delayed(const Duration(seconds: 2));

    final String accessToken = 'accessToken';
    final String refreshToken = 'refreshToken';

    return Token(accessToken, refreshToken);
  }

  @override
  Future<void> signOut() async {
    // Kinda fake sign out
    await Future.delayed(const Duration(seconds: 2));
  }
}
