import 'package:local_auth_showcase/feature/auth/data/auth_data_source.dart';
import 'package:local_auth_showcase/feature/auth/data/token_storage.dart';

abstract interface class AuthRepository<T> {
  Future<T> signInWithOAuth();

  Future<void> signOut();
}

final class AuthRepositoryImpl<T> implements AuthRepository<T> {
  final AuthDataSource<T> _dataSource;
  final TokenStorage<T> _storage;

  /// Create an [AuthRepositoryImpl]
  const AuthRepositoryImpl({
    required AuthDataSource<T> dataSource,
    required TokenStorage<T> storage,
  }) : _dataSource = dataSource,
       _storage = storage;

  @override
  Future<T> signInWithOAuth() async {
    final token = await _dataSource.signInWithOAuth();
    await _storage.save(token);

    return token;
  }

  @override
  Future<void> signOut() async {
    await _dataSource.signOut();
    await _storage.clear();
  }
}
