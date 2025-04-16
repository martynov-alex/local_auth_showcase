import 'package:local_auth_showcase/core/utils/preferences_dao.dart';
import 'package:local_auth_showcase/feature/auth/domain/entity/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class TokenStorage {
  Future<Token?> load();

  Future<void> save(Token tokenPair);

  Future<void> clear();
}

final class TokenStorageImpl implements TokenStorage {
  TokenStorageImpl({required SharedPreferences sharedPreferences})
    : _accessToken = TypedEntry(
        sharedPreferences: sharedPreferences,
        key: 'authorization.access_token',
      ),
      _refreshToken = TypedEntry(
        sharedPreferences: sharedPreferences,
        key: 'authorization.refresh_token',
      );

  late final PreferencesEntry<String> _accessToken;
  late final PreferencesEntry<String> _refreshToken;

  @override
  Future<Token?> load() async {
    final accessToken = _accessToken.read();
    final refreshToken = _refreshToken.read();

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return Token(accessToken, refreshToken);
  }

  @override
  Future<void> save(Token tokenPair) async {
    await (
      _accessToken.set(tokenPair.accessToken),
      _refreshToken.set(tokenPair.refreshToken),
    ).wait;
  }

  @override
  Future<void> clear() async {
    await (_accessToken.remove(), _refreshToken.remove()).wait;
  }
}
