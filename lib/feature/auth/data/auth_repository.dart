import 'package:local_auth_showcase/feature/auth/data/auth_data_source.dart';
import 'package:local_auth_showcase/feature/auth/data/token_storage.dart';
import 'package:local_auth_showcase/feature/auth/domain/entity/token.dart';

abstract interface class AuthRepository {
  Future<Token> signInWithOAuth();

  Future<void> logout();
}

final class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;
  final TokenStorage _storage;

  const AuthRepositoryImpl({
    required AuthDataSource dataSource,
    required TokenStorage storage,
  }) : _dataSource = dataSource,
       _storage = storage;

  @override
  Future<Token> signInWithOAuth() async {
    final token = await _dataSource.signInWithOAuth();
    await _storage.save(token);

    return token;
  }

  @override
  Future<void> logout() async {
    await _dataSource.logout();
    await _storage.clear();
  }
}
